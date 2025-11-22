import 'package:core/core.dart' as core;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/utils/api_error_utils.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

/// Product filter model for e-commerce filtering
class ProductFilters {
  final String? search;
  final int? category;
  final int? tag;
  final bool? onSale;
  final String? minPrice;
  final String? maxPrice;
  final String? stockStatus;
  final String? orderBy; // 'date', 'id', 'title', 'price', 'popularity', 'rating'
  final String? order; // 'asc' or 'desc'
  final bool? featured;

  const ProductFilters({
    this.search,
    this.category,
    this.tag,
    this.onSale,
    this.minPrice,
    this.maxPrice,
    this.stockStatus,
    this.orderBy,
    this.order,
    this.featured,
  });

  ProductFilters copyWith({
    String? search,
    int? category,
    int? tag,
    bool? onSale,
    String? minPrice,
    String? maxPrice,
    String? stockStatus,
    String? orderBy,
    String? order,
    bool? featured,
    bool clearSearch = false,
    bool clearCategory = false,
    bool clearTag = false,
    bool clearOnSale = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearStockStatus = false,
    bool clearOrderBy = false,
    bool clearOrder = false,
    bool clearFeatured = false,
  }) {
    return ProductFilters(
      search: clearSearch ? null : (search ?? this.search),
      category: clearCategory ? null : (category ?? this.category),
      tag: clearTag ? null : (tag ?? this.tag),
      onSale: clearOnSale ? null : (onSale ?? this.onSale),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      stockStatus: clearStockStatus ? null : (stockStatus ?? this.stockStatus),
      orderBy: clearOrderBy ? null : (orderBy ?? this.orderBy),
      order: clearOrder ? null : (order ?? this.order),
      featured: clearFeatured ? null : (featured ?? this.featured),
    );
  }

  /// Check if any filter is active
  bool get hasActiveFilters {
    return search != null ||
        category != null ||
        tag != null ||
        onSale != null ||
        minPrice != null ||
        maxPrice != null ||
        stockStatus != null ||
        orderBy != null ||
        featured != null;
  }

  /// Reset all filters
  ProductFilters reset() {
    return const ProductFilters();
  }
}

@injectable
class ProductListViewModel
    extends core.BaseViewModelHydratedCubit<ProductListState> {
  ProductListViewModel() : super(ProductListInitialState());

  final ProductService _productService = GetIt.I<ProductService>();
  final core.AssetConfigHelper _config = core.AssetConfigHelper();
  
  // Optional route/view arguments holder
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
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
  int _totalPages = 1;
  // Increase per_page when using client-side filtering to get more products for filtering
  final int _perPage = 50; // Increased from default to accommodate client-side filtering
  List<ListAllProductsResponseModel> _allProducts = [];

  @override
  String get id => 'product_list_view_model_v1';

  /// Load products with current filters
  Future<void> loadProducts({bool refresh = false}) async {
    debugPrint('🚀 ProductListViewModel.loadProducts called (refresh: $refresh)');
    try {
      if (refresh) {
        _currentPage = 1;
        _allProducts = [];
        emit(ProductListLoadingState());
      } else {
        final currentState = state;
        if (currentState is! ProductListLoadedState) {
          emit(ProductListLoadingState());
        }
      }

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Prepare price filters - only send if not null and not empty
      final minPrice = _filters.minPrice != null && _filters.minPrice!.isNotEmpty
          ? _filters.minPrice
          : null;
      final maxPrice = _filters.maxPrice != null && _filters.maxPrice!.isNotEmpty
          ? _filters.maxPrice
          : null;

      debugPrint('🔍 ProductListViewModel: Loading products with filters:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Page: $_currentPage, Per Page: $_perPage');
      debugPrint('  - Min Price: $minPrice (raw: ${_filters.minPrice})');
      debugPrint('  - Max Price: $maxPrice (raw: ${_filters.maxPrice})');
      debugPrint('  - On Sale: ${_filters.onSale}');
      debugPrint('  - Stock Status: ${_filters.stockStatus}');
      debugPrint('  - Category: ${_filters.category}');
      debugPrint('  - Tag: ${_filters.tag}');
      debugPrint('  - Order By: ${_filters.orderBy}');
      debugPrint('  - Order: ${_filters.order}');
      debugPrint('  - Featured: ${_filters.featured}');
      debugPrint('  - Search: ${_filters.search}');

      final products = await _productService.listAllProducts(
        apiVersion: apiVersion,
        page: _currentPage,
        perPage: _perPage,
        search: _filters.search,
        category: _filters.category,
        tag: _filters.tag,
        onSale: _filters.onSale,
        // Note: Store API v1 doesn't reliably support min_price/max_price filtering
        // We'll implement client-side price filtering below
        minPrice: null, // Disable server-side price filtering
        maxPrice: null, // Disable server-side price filtering
        stockStatus: _filters.stockStatus,
        orderBy: _filters.orderBy,
        order: _filters.order,
        featured: _filters.featured,
      );

      debugPrint('✅ ProductListViewModel: Loaded ${products.length} products');
      
      // Debug: Log first 3 product prices to understand format
      if (products.isNotEmpty) {
        debugPrint('🔍 Sample product prices from API:');
        for (int i = 0; i < products.length && i < 3; i++) {
          final product = products[i];
          if (product.prices != null) {
            debugPrint('  Product ${i + 1}: ${product.name}');
            debugPrint('    - price: "${product.prices!.price}"');
            debugPrint('    - regular_price: "${product.prices!.regularPrice}"');
            debugPrint('    - sale_price: "${product.prices!.salePrice}"');
            debugPrint('    - currency_code: "${product.prices!.currencyCode}"');
            debugPrint('    - currency_symbol: "${product.prices!.currencySymbol}"');
            debugPrint('    - currency_minor_unit: ${product.prices!.currencyMinorUnit}');
          }
        }
      }
      
      // Client-side price filtering (since Store API v1 doesn't support it reliably)
      List<ListAllProductsResponseModel> filteredProducts = products;
      if (minPrice != null || maxPrice != null) {
        final minPriceValue = minPrice != null ? double.tryParse(minPrice) : null;
        final maxPriceValue = maxPrice != null ? double.tryParse(maxPrice) : null;
        
        debugPrint('🔍 Applying client-side price filtering:');
        debugPrint('  - Min Price: $minPrice (parsed: $minPriceValue)');
        debugPrint('  - Max Price: $maxPrice (parsed: $maxPriceValue)');
        
        filteredProducts = products.where((product) {
          if (product.prices == null) {
            debugPrint('  ❌ Product ${product.name} has no prices');
            return false;
          }
          
          // Get the current price (could be sale price or regular price)
          final priceString = product.prices!.price;
          if (priceString == null || priceString.isEmpty) {
            debugPrint('  ❌ Product ${product.name} has empty price string');
            return false;
          }
          
          // Parse price (remove currency symbols and convert to double)
          final priceValue = _parsePrice(priceString, currencyMinorUnit: product.prices!.currencyMinorUnit);
          if (priceValue == null) {
            debugPrint('  ❌ Product ${product.name} price parsing failed: $priceString');
            return false;
          }
          
          debugPrint('  🔍 Product ${product.name}: price=$priceString -> $priceValue');
          
          // Check min price
          if (minPriceValue != null && priceValue < minPriceValue) {
            debugPrint('    ❌ Below min price: $priceValue < $minPriceValue');
            return false;
          }
          
          // Check max price
          if (maxPriceValue != null && priceValue > maxPriceValue) {
            debugPrint('    ❌ Above max price: $priceValue > $maxPriceValue');
            return false;
          }
          
          debugPrint('    ✅ Price in range: $priceValue');
          return true;
        }).toList();
        
        debugPrint('🔍 Client-side filtering result: ${products.length} -> ${filteredProducts.length} products');
      }
      
      if (filteredProducts.isNotEmpty) {
        debugPrint('✅ First product: ${filteredProducts.first.name} (ID: ${filteredProducts.first.id})');
        if (filteredProducts.first.prices != null) {
          debugPrint('✅ First product price: ${filteredProducts.first.prices!.price}');
          debugPrint('✅ First product regular price: ${filteredProducts.first.prices!.regularPrice}');
          debugPrint('✅ First product sale price: ${filteredProducts.first.prices!.salePrice}');
        }
        // Log all product prices if filtering by price
        if (minPrice != null || maxPrice != null) {
          debugPrint('🔍 Price filtering active - checking filtered products:');
          for (int i = 0; i < filteredProducts.length && i < 5; i++) {
            final product = filteredProducts[i];
            if (product.prices != null) {
              final priceValue = _parsePrice(product.prices!.price, currencyMinorUnit: product.prices!.currencyMinorUnit);
              debugPrint('  - ${product.name}: price=${product.prices!.price} (parsed: $priceValue)');
            }
          }
        }
      } else {
        debugPrint('⚠️ ProductListViewModel: No products after filtering');
        if (minPrice != null || maxPrice != null) {
          debugPrint('⚠️ This might indicate that no products match the price range: $minPrice - $maxPrice');
        }
      }

      if (refresh || _currentPage == 1) {
        _allProducts = filteredProducts;
      } else {
        _allProducts.addAll(filteredProducts);
      }

      // Calculate total pages (assuming we have at least 1 page if products exist)
      _totalPages = filteredProducts.length < _perPage
          ? _currentPage
          : _currentPage + 1; // Estimate, API doesn't always return total

      debugPrint('📦 ProductListViewModel: Emitting loaded state with ${_allProducts.length} products');
      emit(
        ProductListLoadedState(
          products: _allProducts,
          hasMore: products.length >= _perPage,
          currentPage: _currentPage,
          totalPages: _totalPages,
        ),
      );
      debugPrint('✅ ProductListViewModel: State emitted successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ ProductListViewModel: Error loading products: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      debugPrint('❌ Stack trace: $stackTrace');
      emit(ProductListErrorState(message: _getErrorMessage(e)));
    }
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is ProductListLoadedState && currentState.hasMore) {
      _currentPage++;
      await loadProducts();
    }
  }

  // Track if dialog is initialized to prevent multiple initializations
  bool _dialogInitialized = false;

  /// Initialize filter dialog - sets temp filters and controllers
  void initFilterDialog() {
    if (!_dialogInitialized) {
      _tempFilters = _filters;
      _minPriceController.text = _filters.minPrice ?? '';
      _maxPriceController.text = _filters.maxPrice ?? '';
      _dialogInitialized = true;
      // Emit to trigger rebuild with initial values
      final currentState = state;
      if (currentState is ProductListLoadedState) {
        emit(ProductListLoadedState(
          products: currentState.products,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
        ));
      } else {
        emit(currentState);
      }
    }
  }

  /// Reset dialog initialization flag (call when dialog closes)
  void resetDialogInit() {
    _dialogInitialized = false;
  }

  /// Update temp filter (for filter dialog)
  void updateTempFilter({
    String? minPrice,
    String? maxPrice,
    bool? onSale,
    String? stockStatus,
    String? orderBy,
    String? order,
  }) {
    _tempFilters = _tempFilters.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      onSale: onSale,
      stockStatus: stockStatus,
      orderBy: orderBy,
      order: order,
    );
    // Emit current state to trigger rebuild in filter dialog
    final currentState = state;
    if (currentState is ProductListLoadedState) {
      emit(ProductListLoadedState(
        products: currentState.products,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
      ));
    } else {
      emit(currentState);
    }
  }

  /// Parse price string to double value (handles WooCommerce API format)
  double? _parsePrice(String? priceString, {int? currencyMinorUnit}) {
    if (priceString == null || priceString.isEmpty) return null;
    
    debugPrint('🔍 Parsing price: $priceString (minor_unit: $currencyMinorUnit)');
    
    // WooCommerce API sometimes returns prices in minor units (cents)
    // Use currency_minor_unit to determine the conversion factor
    final intValue = int.tryParse(priceString);
    if (intValue != null && currencyMinorUnit != null && currencyMinorUnit > 0) {
      // This is likely in minor units, convert to major units
      double divisor = 1.0;
      for (int i = 0; i < currencyMinorUnit; i++) {
        divisor *= 10.0;
      }
      final doubleValue = intValue / divisor;
      debugPrint('🔍 Parsed as minor units: $intValue -> $doubleValue (divisor: $divisor)');
      return doubleValue;
    } else if (intValue != null) {
      // Default to cents conversion if no minor unit info
      final doubleValue = intValue / 100.0;
      debugPrint('🔍 Parsed as cents (default): $intValue -> $doubleValue');
      return doubleValue;
    }
    
    // If not integer, try parsing as decimal string
    // Remove all non-numeric characters except decimal point
    String cleaned = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    
    // Handle thousand separators (commas) vs decimal separators
    if (cleaned.contains(',') && cleaned.contains('.')) {
      // Both comma and dot present - comma is likely thousand separator
      cleaned = cleaned.replaceAll(',', '');
    } else if (cleaned.contains(',') && !cleaned.contains('.')) {
      // Only comma - could be decimal separator (European format)
      final commaIndex = cleaned.lastIndexOf(',');
      if (commaIndex >= cleaned.length - 3) {
        // Comma is near the end, treat as decimal separator
        cleaned = cleaned.replaceAll(',', '.');
      } else {
        // Comma is not near the end, treat as thousand separator
        cleaned = cleaned.replaceAll(',', '');
      }
    }
    
    // Ensure only one decimal point
    final parts = cleaned.split('.');
    if (parts.length > 2) {
      cleaned = '${parts[0]}.${parts.sublist(1).join()}';
    }
    
    // Parse to double
    final result = double.tryParse(cleaned);
    debugPrint('🔍 Parsed as decimal: $cleaned -> $result');
    return result;
  }

  /// Clean price string for API - removes currency symbols, thousand separators, keeps only numeric value
  String? _cleanPriceForApi(String? priceString) {
    if (priceString == null || priceString.isEmpty) return null;
    
    // Remove all non-numeric characters except decimal point
    String cleaned = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    
    // Handle thousand separators (commas) vs decimal separators
    // If there's a comma, check if it's a thousand separator or decimal separator
    if (cleaned.contains(',') && cleaned.contains('.')) {
      // Both comma and dot present - comma is likely thousand separator
      cleaned = cleaned.replaceAll(',', '');
    } else if (cleaned.contains(',') && !cleaned.contains('.')) {
      // Only comma - could be decimal separator (European format) or thousand separator
      // Check position: if comma is near the end (last 3 chars), it's likely decimal
      final commaIndex = cleaned.lastIndexOf(',');
      if (commaIndex >= cleaned.length - 3) {
        // Comma is near the end, treat as decimal separator
        cleaned = cleaned.replaceAll(',', '.');
      } else {
        // Comma is not near the end, treat as thousand separator
        cleaned = cleaned.replaceAll(',', '');
      }
    }
    
    // Ensure only one decimal point
    final parts = cleaned.split('.');
    if (parts.length > 2) {
      cleaned = '${parts[0]}.${parts.sublist(1).join()}';
    }
    
    // Validate it's a valid number
    if (cleaned.isEmpty) return null;
    final parsed = double.tryParse(cleaned);
    if (parsed == null || parsed < 0) return null;
    
    // WooCommerce Store API might expect price in cents (integer)
    // Try converting to cents first, then back to string
    final priceInCents = (parsed * 100).round();
    debugPrint('🔍 Price conversion: $priceString -> $cleaned -> $parsed -> ${priceInCents}c');
    
    // Return the price as string (WooCommerce Store API typically expects string format)
    return cleaned;
  }

  /// Apply filters and reload products
  Future<void> applyFilters() async {
    // Clean price values for API
    final cleanMinPrice = _cleanPriceForApi(_tempFilters.minPrice);
    final cleanMaxPrice = _cleanPriceForApi(_tempFilters.maxPrice);

    debugPrint('🔍 ProductListViewModel: Applying filters:');
    debugPrint('  - Temp Min Price: ${_tempFilters.minPrice}');
    debugPrint('  - Cleaned Min Price: $cleanMinPrice');
    debugPrint('  - Temp Max Price: ${_tempFilters.maxPrice}');
    debugPrint('  - Cleaned Max Price: $cleanMaxPrice');

    _filters = _tempFilters.copyWith(
      minPrice: cleanMinPrice,
      maxPrice: cleanMaxPrice,
    );
    _currentPage = 1;
    _allProducts = [];
    await loadProducts(refresh: true);
  }

  /// Update a single filter (for chip close actions)
  Future<void> updateFilter({
    String? search,
    int? category,
    int? tag,
    bool? onSale,
    String? minPrice,
    String? maxPrice,
    String? stockStatus,
    String? orderBy,
    String? order,
    bool? featured,
  }) async {
    _filters = _filters.copyWith(
      search: search,
      category: category,
      tag: tag,
      onSale: onSale,
      minPrice: minPrice,
      maxPrice: maxPrice,
      stockStatus: stockStatus,
      orderBy: orderBy,
      order: order,
      featured: featured,
      clearSearch: search == null,
      clearCategory: category == null,
      clearTag: tag == null,
      clearOnSale: onSale == null,
      clearMinPrice: minPrice == null,
      clearMaxPrice: maxPrice == null,
      clearStockStatus: stockStatus == null,
      clearOrderBy: orderBy == null,
      clearOrder: order == null,
      clearFeatured: featured == null,
    );
    _currentPage = 1;
    _allProducts = [];
    await loadProducts(refresh: true);
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    _filters = const ProductFilters(
      orderBy: 'date',
      order: 'desc',
    );
    _currentPage = 1;
    _allProducts = [];
    await loadProducts(refresh: true);
  }

  /// Get user-friendly error message
  /// Uses ApiErrorUtils for consistent error handling
  String _getErrorMessage(dynamic error) {
    return ApiErrorUtils.getErrorMessage(error);
  }

  @override
  ProductListState? fromJson(Map<String, dynamic> json) {
    // Don't persist state - always load fresh
    return null;
  }

  @override
  Map<String, dynamic>? toJson(ProductListState state) {
    // Don't persist state
    return null;
  }
}

