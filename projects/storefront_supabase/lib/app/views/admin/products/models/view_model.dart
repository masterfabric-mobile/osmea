import 'dart:async';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/admin/products/models/product_filters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class AdminProductsViewModel extends BaseViewModelCubit<AdminProductsState> {
  final SupabaseClient _supabaseClient;
  Timer? _debounce;
  final TextEditingController searchController;

  AdminProductsViewModel(this._supabaseClient)
      : searchController = TextEditingController(),
        super(AdminProductsLoaded(products: []));

  void setSearchQuery(String query) {
    if (state is! AdminProductsLoaded) return;
    final currentState = state as AdminProductsLoaded;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (currentState.searchQuery != query) {
        fetchProducts(searchQuery: query);
      }
    });
  }

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

  void setCategoryFilters(Set<String> categoryIds) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(selectedCategoryIds: categoryIds);
  }

  void setBrandFilters(Set<String> brandIds) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(selectedBrandIds: brandIds);
  }

  Future<void> fetchProducts({
    String? searchQuery,
    PriceSort? priceSort,
    DateSort? dateSort,
    PopularitySort? popularitySort,
    Set<String>? selectedCategoryIds,
    Set<String>? selectedBrandIds,
  }) async {
    AdminProductsLoaded currentState;
    if (state is AdminProductsLoaded) {
      currentState = state as AdminProductsLoaded;
    } else {
      // Initial load, create a default state
      currentState = AdminProductsLoaded(products: []);
    }

    stateChanger(AdminProductsLoading());

    try {
      // On initial load, fetch categories and brands
      if (currentState.allCategories.isEmpty || currentState.allBrands.isEmpty) {
        final responses = await Future.wait([
          _supabaseClient.from('categories').select(),
          _supabaseClient.from('brand').select(),
        ]);
        currentState = currentState.copyWith(
          allCategories: (responses[0] as List).map((e) => Category.fromJson(e)).toList(),
          allBrands: (responses[1] as List).map((e) => Brand.fromJson(e)).toList(),
        );
      }

      final finalQuery = searchQuery ?? currentState.searchQuery;
      final finalPriceSort = priceSort ?? currentState.priceSort;
      final finalDateSort = dateSort ?? currentState.dateSort;
      final finalPopularitySort = popularitySort ?? currentState.popularitySort;
      final finalCategoryIds = selectedCategoryIds ?? currentState.selectedCategoryIds;
      final finalBrandIds = selectedBrandIds ?? currentState.selectedBrandIds;
      
      dynamic query = _supabaseClient.from('products_with_wishlist_count').select('*, product_images(*)');

      if (finalQuery.isNotEmpty) {
        query = query.ilike('name', '%$finalQuery%');
      }
      if (finalCategoryIds.isNotEmpty) {
        query = query.in_('category_id', finalCategoryIds.toList());
      }
      if (finalBrandIds.isNotEmpty) {
        query = query.in_('brand_id', finalBrandIds.toList());
      }

      if (finalPriceSort != PriceSort.none) {
        query = query.order('price', ascending: finalPriceSort == PriceSort.lowToHigh);
      } else if (finalPopularitySort != PopularitySort.none) {
        query = query.order('wishlist_count', ascending: false);
      }
      
      query = query.order('created_at', ascending: finalDateSort == DateSort.oldestFirst);

      final response = await query;
      final products = (response as List).map((e) => Product.fromJson(e)).toList();

      stateChanger(AdminProductsLoaded(
        products: products,
        searchQuery: finalQuery,
        priceSort: finalPriceSort,
        dateSort: finalDateSort,
        popularitySort: finalPopularitySort,
        allCategories: currentState.allCategories,
        allBrands: currentState.allBrands,
        selectedCategoryIds: finalCategoryIds,
        selectedBrandIds: finalBrandIds,
      ));
    } catch (e) {
      stateChanger(AdminProductsError('Error: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    searchController.dispose();
    return super.close();
  }
}
