import 'dart:async';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/module/states.dart';

@injectable
class ProductListViewModel
    extends core.BaseViewModelHydratedCubit<ProductListState> {
  final SupabaseClient _supabaseClient;

  ProductListViewModel(this._supabaseClient) : super(ProductListInitialState());

  // Optional route/view arguments holder
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
    
    // Parse category_id from arguments
    if (args.containsKey('category_id')) {
      final categoryIdValue = args['category_id'];
      String? categoryId;
      if (categoryIdValue != null) {
        categoryId = categoryIdValue.toString();
        _filters = _filters.copyWith(categoryId: categoryId);
      }
    }
    // Parse search from arguments
    if (args.containsKey('search')) {
      final search = args['search'] as String?;
      if (search != null) {
        _filters = _filters.copyWith(search: search);
      }
    }
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Filter state
  ProductFilters _filters = const ProductFilters(
    orderBy: 'date',
    order: 'desc',
  );

  ProductFilters get filters => _filters;

  // Text editing controllers for price filters
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  TextEditingController get minPriceController => _minPriceController;
  TextEditingController get maxPriceController => _maxPriceController;

  // Temporary filter state for filter dialog
  ProductFilters _tempFilters = const ProductFilters(
    orderBy: 'date',
    order: 'desc',
  );

  ProductFilters get tempFilters => _tempFilters;

  // Pagination
  int _currentPage = 1;
  final int _perPage = 20;
  List<Product> _allProducts = [];

  // Filter options
  List<Category> _categories = [];
  bool _isLoadingProducts = false;

  @override
  String get id => 'product_list_view_model_supa_v1';

  /// Load products with current filters
  Future<void> loadProducts({bool refresh = false}) async {
    if (_isLoadingProducts) return;

    _isLoadingProducts = true;

    try {
      if (refresh) {
        _currentPage = 1;
        _allProducts = [];
        emit(ProductListLoadingState(
          categories: state.categories,
          tags: state.tags,
        ));
      } else {
        if (state is! ProductListLoadedState) {
          emit(ProductListLoadingState(
            categories: state.categories,
            tags: state.tags,
          ));
        }
      }

      // Build query (use dynamic to allow both PostgrestFilterBuilder and PostgrestTransformBuilder in chain)
      dynamic query = _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order), brand(name)'); // Join brands too if needed

      // Filters
      if (_filters.search != null && _filters.search!.isNotEmpty) {
        query = query.ilike('name', '%${_filters.search}%');
      }
      
      if (_filters.categoryId != null) {
        // Need recursive category check? Or simple eq?
        // Supabase simple model: direct category_id
        query = query.eq('category_id', _filters.categoryId!);
      }

      if (_filters.onSale == true) {
        query = query.not('sale_price', 'is', null);
      }

      if (_filters.minPrice != null) {
        query = query.gte('price', _filters.minPrice!);
      }
      
      if (_filters.maxPrice != null) {
        query = query.lte('price', _filters.maxPrice!);
      }

      // Sort
      if (_filters.orderBy == 'price') {
        query = query.order('price', ascending: _filters.order == 'asc');
      } else {
        query = query.order('created_at', ascending: _filters.order == 'asc'); // Default date
      }

      // Pagination
      final from = (_currentPage - 1) * _perPage;
      final to = from + _perPage - 1;
      query = query.range(from, to);

      final response = await query;
      final products = (response as List).map((data) => Product.fromJson(data as Map<String, dynamic>)).toList();

      // Client-side filtering for tags (since tags are stored as comma-separated string or array in some models)
      // Supabase Product model has `List<String>? tags`.
      // If we filtered by tags in DB, we'd need Postgrest filter.
      // `tags` column is text[] or text? Assuming text[] for better filtering or simple filtering here.
      // Let's assume we filter in memory for now if tags are selected.
      List<Product> filteredProducts = products;
      if (_filters.selectedTags != null && _filters.selectedTags!.isNotEmpty) {
        filteredProducts = products.where((p) {
          if (p.tags == null) return false;
          return p.tags!.any((t) => _filters.selectedTags!.contains(t));
        }).toList();
      }

      if (refresh || _currentPage == 1) {
        _allProducts = filteredProducts;
      } else {
        _allProducts.addAll(filteredProducts);
      }

      
      emit(ProductListLoadedState(
        products: _allProducts,
        hasMore: products.length == _perPage,
        currentPage: _currentPage,
        categories: state.categories,
        tags: state.tags,
      ));

    } catch (e) {
      emit(ProductListErrorState(
        message: 'Failed to load products: $e',
        products: state.products,
        categories: state.categories,
        tags: state.tags,
      ));
    } finally {
      _isLoadingProducts = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingProducts || !state.hasMore) return;
    _currentPage++;
    await loadProducts();
  }

  void initFilterDialog() {
    _tempFilters = _filters;
    _minPriceController.text = _filters.minPrice?.toString() ?? '';
    _maxPriceController.text = _filters.maxPrice?.toString() ?? '';
    
    // Load filter options if needed
    if (_categories.isEmpty) loadCategories();
    // Tags are hardcoded or loaded from products?
    // Let's load unique tags from all products or a separate table if available.
    // For now, assuming static tags or extracted from products.
  }

  Future<void> loadCategories() async {
    try {
      emit(ProductListFilterOptionsLoadingState(
        products: state.products,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        categories: state.categories,
        tags: state.tags,
      ));

      final response = await _supabaseClient.from('categories').select().order('name');
      _categories = (response as List).map((data) => Category.fromJson(data)).toList();

      emit(ProductListFilterOptionsLoadedState(
        products: state.products,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        categories: _categories,
        tags: state.tags,
      ));
    } catch (e) {
      emit(ProductListFilterOptionsErrorState(
        message: 'Failed to load categories: $e',
        products: state.products,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        categories: state.categories,
        tags: state.tags,
      ));
    }
  }

  void updateTempFilter({
    String? search,
    String? categoryId,
    List<String>? selectedTags,
    bool? onSale,
    String? minPrice, // String input from controller
    String? maxPrice,
    String? orderBy,
    String? order,
  }) {
    double? min = minPrice != null ? double.tryParse(minPrice) : _tempFilters.minPrice;
    double? max = maxPrice != null ? double.tryParse(maxPrice) : _tempFilters.maxPrice;

    _tempFilters = _tempFilters.copyWith(
      search: search,
      categoryId: categoryId,
      selectedTags: selectedTags,
      onSale: onSale,
      minPrice: min,
      maxPrice: max,
      orderBy: orderBy,
      order: order,
      clearCategory: categoryId == null, // Simplified logic: pass null to clear
      clearSearch: search == null,
      clearSelectedTags: selectedTags == null,
      clearOnSale: onSale == null,
      clearMinPrice: minPrice == null,
      clearMaxPrice: maxPrice == null,
      clearOrderBy: orderBy == null,
      clearOrder: order == null,
    );
    
    // Emit state to update UI if needed (though tempFilters is not in state, UI reads it from VM)
    // We can emit current state to force rebuild
    emit(state);
  }

  Future<void> applyFilters() async {
    _filters = _tempFilters;
    await loadProducts(refresh: true);
  }

  Future<void> clearFilters() async {
    _filters = const ProductFilters(orderBy: 'date', order: 'desc');
    _tempFilters = _filters;
    _minPriceController.clear();
    _maxPriceController.clear();
    await loadProducts(refresh: true);
  }

  @override
  Map<String, dynamic>? toJson(ProductListState state) {
    return null;
  }

  @override
  ProductListState? fromJson(Map<String, dynamic> json) {
    return null;
  }
}
