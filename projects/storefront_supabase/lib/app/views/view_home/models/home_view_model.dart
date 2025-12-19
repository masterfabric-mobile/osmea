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

  void setCategoryFilters(Set<String> categoryIds) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(selectedCategoryIds: categoryIds);
  }

  void setBrandFilters(Set<int> brandIds) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(selectedBrandIds: brandIds);
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
    Set<String>? selectedCategoryIds,
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
      final finalCategoryIds =
          selectedCategoryIds ?? currentState.selectedCategoryIds;
      final finalBrandIds =
          selectedBrandIds ?? currentState.selectedBrandIds;

      /* -------- Base query -------- */
      
      // Use products_with_wishlist_count if available for popularity sort,
      // otherwise fallback to products. Assuming view exists per Admin logic.
      var baseQuery = _supabaseClient
          .from('products_with_wishlist_count')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true);

      PostgrestFilterBuilder currentFilteredQuery = baseQuery;

      /* -------- Filters -------- */

      if (finalQuery.isNotEmpty) {
        currentFilteredQuery = currentFilteredQuery.ilike('name', '%$finalQuery%');
      }

      if (finalCategoryIds.isNotEmpty) {
        currentFilteredQuery = currentFilteredQuery.filter('category_id', 'in', finalCategoryIds.toList());
      }

      if (finalBrandIds.isNotEmpty) {
        currentFilteredQuery = currentFilteredQuery.filter('brand_id', 'in', finalBrandIds.toList());
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
          selectedCategoryIds: finalCategoryIds,
          selectedBrandIds: finalBrandIds,
        ),
      );
    } catch (e) {
      // Fallback if view doesn't exist or error occurs, try basic products table
      if (e.toString().contains('relation "public.products_with_wishlist_count" does not exist')) {
         try {
             final response = await _supabaseClient
              .from('products')
              .select('*, product_images(image_url, is_primary, sort_order)')
              .eq('is_active', true)
              .order('created_at', ascending: false);
              
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
