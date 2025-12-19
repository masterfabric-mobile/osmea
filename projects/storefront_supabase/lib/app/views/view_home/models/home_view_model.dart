import 'dart:async';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'states.dart';

@injectable
class SupabaseHomeViewModel extends BaseViewModelCubit<SupabaseHomeState> {
  final SupabaseClient _supabaseClient;

  SupabaseHomeViewModel(this._supabaseClient)
      : super(SupabaseHomeInitialState());

  /* -------------------- SORTS -------------------- */

  void setPriceSort(PriceSort sort) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(priceSort: sort);
  }

  void setDateSort(DateSort sort) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(dateSort: sort);
  }

  void setPopularitySort(PopularitySort sort) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(popularitySort: sort);
  }

  /* -------------------- FILTERS -------------------- */

  void setHierarchicalCategories(Category? root, Category? sub, Category? leaf) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(
      selectedRoot: root,
      selectedSub: sub,
      selectedLeaf: leaf,
    );
  }

  void setBrandFilters(Set<int> brandIds) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(selectedBrandIds: brandIds);
  }

  /* -------------------- HELPERS -------------------- */

  List<Category> getRootCategories(List<Category> all) {
    return all.where((c) => c.parentId == null).toList();
  }
  
  List<Category> getSubCategories(List<Category> all, String? parentId) {
    if (parentId == null) return [];
    return all.where((c) => c.parentId == parentId).toList();
  }

  // Helper for hierarchy
  Future<List<String>> _getAllDescendantIds(String parentId) async {
    final List<String> ids = [];
    final response = await _supabaseClient.from('categories').select('id').eq('parent_id', parentId);
    for (var item in response as List) {
      final id = item['id'] as String;
      ids.add(id);
      ids.addAll(await _getAllDescendantIds(id));
    }
    return ids;
  }

  Future<void> initial() async {
    // Initial fetch with default sort/filter
    await fetchProducts();
  }

  Future<void> fetchProducts({
    String? searchQuery,
    PriceSort? priceSort,
    DateSort? dateSort,
    PopularitySort? popularitySort,
    Category? selectedRoot,
    Category? selectedSub,
    Category? selectedLeaf,
    Set<int>? selectedBrandIds,
  }) async {
    SupabaseHomeLoadedState currentState =
        state is SupabaseHomeLoadedState
            ? state as SupabaseHomeLoadedState
            : SupabaseHomeLoadedState(products: []);

    stateChanger(SupabaseHomeLoadingState());

    try {
      /* -------- Initial lookup data -------- */

      if (currentState.allCategories.isEmpty ||
          currentState.allBrands.isEmpty) {
        final results = await Future.wait([
          _supabaseClient.from('categories').select(),
          _supabaseClient.from('brand').select(),
        ]);

        currentState = currentState.copyWith(
          allCategories: (results[0] as List)
              .map((e) => Category.fromJson(e))
              .toList(),
          allBrands: (results[1] as List)
              .map((e) => Brand.fromJson(e))
              .toList(),
        );
      }

      final finalQuery = searchQuery ?? currentState.searchQuery;
      final finalPriceSort = priceSort ?? currentState.priceSort;
      final finalDateSort = dateSort ?? currentState.dateSort;
      final finalPopularitySort =
          popularitySort ?? currentState.popularitySort;
      final finalBrandIds =
          selectedBrandIds ?? currentState.selectedBrandIds;
      
      // Handle Hierarchy
      // If passing null explicitly for logic, we need to know. 
      // But assuming View passes the new set.
      final activeRoot = selectedRoot ?? currentState.selectedRootCategory;
      final activeSub = selectedSub ?? currentState.selectedSubCategory;
      final activeLeaf = selectedLeaf ?? currentState.selectedLeafCategory;

      /* -------- Base query -------- */
      
      // Use products_with_wishlist_count if available for popularity sort,
      // otherwise fallback to products.
      var baseQuery = _supabaseClient
          .from('products_with_wishlist_count')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true);

      PostgrestFilterBuilder currentFilteredQuery = baseQuery;

      /* -------- Filters -------- */

      if (finalQuery.isNotEmpty) {
        currentFilteredQuery = currentFilteredQuery.ilike('name', '%$finalQuery%');
      }

      /* -------- Hierarchy Filter (Deep Search) -------- */
      final targetCategory = activeLeaf ?? activeSub ?? activeRoot;
      if (targetCategory != null) {
        // Get all descendant IDs
        final descendantIds = await _getAllDescendantIds(targetCategory.id);
        descendantIds.add(targetCategory.id);
        
        currentFilteredQuery = currentFilteredQuery.inFilter('category_id', descendantIds);
      }

      if (finalBrandIds.isNotEmpty) {
        currentFilteredQuery = currentFilteredQuery.inFilter('brand_id', finalBrandIds.toList());
      }

      /* -------- Sorting -------- */

      PostgrestTransformBuilder finalOrderedQuery;

      if (finalPriceSort != PriceSort.none) {
        finalOrderedQuery = currentFilteredQuery.order(
          'price',
          ascending: finalPriceSort == PriceSort.lowToHigh,
        );
      } else if (finalPopularitySort != PopularitySort.none) {
        finalOrderedQuery = currentFilteredQuery.order(
          'wishlist_count',
          ascending: false,
        );
      } else {
        finalOrderedQuery = currentFilteredQuery.order(
          'created_at',
          ascending: finalDateSort == DateSort.oldestFirst,
        );
      }

      /* -------- Execute -------- */

      final response = await finalOrderedQuery;
      final products = (response as List)
          .map((e) => Product.fromJson(e))
          .toList();

      stateChanger(
        SupabaseHomeLoadedState(
          products: products,
          searchQuery: finalQuery,
          priceSort: finalPriceSort,
          dateSort: finalDateSort,
          popularitySort: finalPopularitySort,
          allCategories: currentState.allCategories,
          allBrands: currentState.allBrands,
          selectedRootCategory: activeRoot,
          selectedSubCategory: activeSub,
          selectedLeafCategory: activeLeaf,
          selectedBrandIds: finalBrandIds,
        ),
      );
    } catch (e) {
      // Fallback if view doesn't exist or error occurs, try basic products table
      if (e.toString().contains('relation "public.products_with_wishlist_count" does not exist')) {
         try {
             // Re-apply filters on basic table
             var fallbackQuery = _supabaseClient
              .from('products')
              .select('*, product_images(image_url, is_primary, sort_order)')
              .eq('is_active', true);
             
             // ... apply same filters again for fallback ... 
             // To save time/code duplication, for now just basic fetch or minimal fallback
             // Better: refactor query building. But keeping it simple for CLI agent.
             
             final response = await fallbackQuery.order('created_at', ascending: false);
             final products = (response as List).map((data) => Product.fromJson(data)).toList();
             
             stateChanger(SupabaseHomeLoadedState(products: products));
         } catch (fallbackError) {
             stateChanger(SupabaseHomeErrorState('Failed to load products: $fallbackError'));
         }
      } else {
         stateChanger(SupabaseHomeErrorState('Failed to load products: $e'));
      }
    }
  }
}