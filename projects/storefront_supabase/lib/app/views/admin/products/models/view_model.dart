import 'dart:async';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class AdminProductsViewModel
    extends BaseViewModelCubit<AdminProductsState> {
  final SupabaseClient _supabaseClient;
  Timer? _debounce;
  final TextEditingController searchController;

  AdminProductsViewModel(this._supabaseClient)
      : searchController = TextEditingController(),
        super(AdminProductsLoaded(products: []));

  /* -------------------- SEARCH -------------------- */

  void setSearchQuery(String query) {
    if (state is! AdminProductsLoaded) return;
    final currentState = state as AdminProductsLoaded;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (currentState.searchQuery != query) {
        fetchProducts(searchQuery: query);
      }
    });
  }

  /* -------------------- SORTS -------------------- */

  void setPriceSort(PriceSort sort) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(priceSort: sort);
  }

  void setDateSort(DateSort sort) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(dateSort: sort);
  }

  void setPopularitySort(PopularitySort sort) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(popularitySort: sort);
  }

  /* -------------------- FILTERS -------------------- */

  void setCategoryFilters(Set<String> categoryIds) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(selectedCategoryIds: categoryIds);
  }

  void setBrandFilters(Set<int> brandIds) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(selectedBrandIds: brandIds);
  }

  /* -------------------- FETCH -------------------- */

  Future<void> fetchProducts({
    String? searchQuery,
    PriceSort? priceSort,
    DateSort? dateSort,
    PopularitySort? popularitySort,
    Set<String>? selectedCategoryIds,
    Set<int>? selectedBrandIds,
  }) async {
    AdminProductsLoaded currentState =
        state is AdminProductsLoaded
            ? state as AdminProductsLoaded
            : AdminProductsLoaded(products: []);

    stateChanger(AdminProductsLoading());

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

      var baseQuery = _supabaseClient
          .from('products_with_wishlist_count')
          .select('*, product_images(*)')
          .eq('is_active', true); // Only active products in admin panel

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

      // Apply the selected sort order
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

      final response = await finalOrderedQuery; // Await the final ordered query
      final products = (response as List)
          .map((e) => Product.fromJson(e))
          .toList();

      stateChanger(
        AdminProductsLoaded(
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
      stateChanger(
        AdminProductsError('Failed to load products: $e'),
      );
    }
  }

  /* -------------------- DISPOSE -------------------- */

  @override
  Future<void> close() {
    _debounce?.cancel();
    searchController.dispose();
    return super.close();
  }
}
