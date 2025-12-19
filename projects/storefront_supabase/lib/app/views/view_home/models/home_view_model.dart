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

  // Options for sizes/ages
  final List<String> clothingSizesAndAges = [
    'Baby (0-2)', 'Toddler (2-4)', 'Kids (4-8)', 'Pre-Teen (9-12)',
    'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'
  ];
  final List<String> shoeSizes = List.generate(14, (index) => (34 + index).toString());

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
      applyFilter: true,
    );
  }

  void setBrandFilters(Set<int> brandIds) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(selectedBrandIds: brandIds, applyFilter: true);
  }

  void setSizeFilters(List<String> sizes) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(selectedSizesOrAges: sizes, applyFilter: true);
  }

  /* -------------------- HELPERS -------------------- */

  bool isShoeCategory(Category? leaf, Category? sub, Category? root) {
    final slugToCheck = (leaf?.slug ?? sub?.slug ?? root?.slug ?? '').toLowerCase();
    return slugToCheck.contains('shoe') || slugToCheck.contains('boot') || slugToCheck.contains('sneaker');
  }
  
  bool isFashionCategory(Category? root) {
     final rootSlug = root?.slug.toLowerCase() ?? '';
     return rootSlug == 'fashion' || rootSlug == 'clothing' || rootSlug.contains('cloth');
  }

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
    List<String>? selectedSizesOrAges,
    bool applyFilter = false,
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
      
      // Handle Filters
      // If applyFilter is true, use the passed values (even if null/empty) to override.
      // Otherwise, fallback to current state.
      
      final activeRoot = applyFilter ? selectedRoot : (selectedRoot ?? currentState.selectedRootCategory);
      final activeSub = applyFilter ? selectedSub : (selectedSub ?? currentState.selectedSubCategory);
      final activeLeaf = applyFilter ? selectedLeaf : (selectedLeaf ?? currentState.selectedLeafCategory);
      
      final finalBrandIds = applyFilter 
          ? (selectedBrandIds ?? const {}) 
          : (selectedBrandIds ?? currentState.selectedBrandIds);
          
      final finalSizes = applyFilter 
          ? (selectedSizesOrAges ?? const []) 
          : (selectedSizesOrAges ?? currentState.selectedSizesOrAges);

      /* -------- Base query -------- */
      
      // Use products table by default to ensure we have all latest columns (like target_age_group).
      var baseQuery = _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order), brand(name)')
          .eq('is_active', true);

      PostgrestFilterBuilder currentFilteredQuery = baseQuery;

      /* -------- Text Search -------- */
      if (finalQuery.isNotEmpty) {
        final sanitizedQuery = finalQuery.replaceAll(',', ' ');
        
        // 1. Find brands that match the query
        final brandResponse = await _supabaseClient
            .from('brand')
            .select('id')
            .ilike('name', '%$sanitizedQuery%');
        
        final brandIds = (brandResponse as List)
            .map((e) => e['id'] as int)
            .toList();

        // 2. Build the OR filter string
        String orFilter = 'name.ilike.*$sanitizedQuery*';
        if (brandIds.isNotEmpty) {
          orFilter += ',brand_id.in.(${brandIds.join(',')})';
        }
        
        currentFilteredQuery = currentFilteredQuery.or(orFilter);
      }

      /* -------- Hierarchy Filter (Deep Search) -------- */
      final targetCategory = activeLeaf ?? activeSub ?? activeRoot;
      if (targetCategory != null) {
        // Get all descendant IDs
        final descendantIds = await _getAllDescendantIds(targetCategory.id);
        descendantIds.add(targetCategory.id);
        
        currentFilteredQuery = currentFilteredQuery.inFilter('category_id', descendantIds);
      }

      /* -------- Brand Filter -------- */
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
        // Fallback to price if wishlist_count column missing on raw table
        finalOrderedQuery = currentFilteredQuery.order('price'); 
      } else {
        finalOrderedQuery = currentFilteredQuery.order(
          'created_at',
          ascending: finalDateSort == DateSort.oldestFirst,
        );
      }

      /* -------- Execute & Client-side Size Filter -------- */
      final response = await finalOrderedQuery;
      var products = (response as List)
          .map((e) => Product.fromJson(e))
          .toList();

      // Client-side filtering for sizes (comma-separated string in DB)
      if (finalSizes.isNotEmpty) {
        products = products.where((p) {
          if (p.targetAgeGroup == null) return false;
          // DB: "S, M, L" -> List: ["S", "M", "L"]
          final productSizes = p.targetAgeGroup!.split(',').map((e) => e.trim()).toList();
          // Check intersection: Does product have *any* of the selected filters?
          return productSizes.any((s) => finalSizes.contains(s));
        }).toList();
      }

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
          selectedSizesOrAges: finalSizes,
        ),
      );
    } catch (e) {
      stateChanger(SupabaseHomeErrorState('Failed to load products: $e'));
    }
  }
}