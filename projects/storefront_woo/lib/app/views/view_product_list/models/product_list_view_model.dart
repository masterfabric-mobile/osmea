import 'package:core/core.dart' as core;
import 'package:core/core.dart' show PriceInfoCurrencyHelper;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/abstract/store_product_attributes_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attribute_terms/abstract/store_product_attribute_terms_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';

import 'package:apis/utils/api_error_utils.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

/// Product filter model for e-commerce filtering
class ProductFilters {
  final String? search;
  final int?
  category; // Single category for API (uses first from selectedCategories)
  final int? tag; // Single tag for API (uses first from selectedTags)
  final List<int>? selectedCategories; // Multiple categories selection
  final List<int>? selectedTags; // Multiple tags selection
  final Map<int, List<int>>?
  selectedAttributes; // Map of attributeId -> list of termIds
  final bool? onSale;
  final String? minPrice;
  final String? maxPrice;
  final String? stockStatus;
  final String?
  orderBy; // 'date', 'id', 'title', 'price', 'popularity', 'rating'
  final String? order; // 'asc' or 'desc'
  final bool? featured;

  const ProductFilters({
    this.search,
    this.category,
    this.tag,
    this.selectedCategories,
    this.selectedTags,
    this.selectedAttributes,
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
    List<int>? selectedCategories,
    List<int>? selectedTags,
    Map<int, List<int>>? selectedAttributes,
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
    bool clearSelectedCategories = false,
    bool clearSelectedTags = false,
    bool clearSelectedAttributes = false,
    bool clearOnSale = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearStockStatus = false,
    bool clearOrderBy = false,
    bool clearOrder = false,
    bool clearFeatured = false,
  }) {
    // Use first selected category/tag for API compatibility
    final apiCategory = clearSelectedCategories
        ? null
        : (selectedCategories?.isNotEmpty == true
              ? selectedCategories!.first
              : (clearCategory
                    ? null
                    : (category ??
                          (this.selectedCategories?.isNotEmpty == true
                              ? this.selectedCategories!.first
                              : this.category))));
    final apiTag = clearSelectedTags
        ? null
        : (selectedTags?.isNotEmpty == true
              ? selectedTags!.first
              : (clearTag
                    ? null
                    : (tag ??
                          (this.selectedTags?.isNotEmpty == true
                              ? this.selectedTags!.first
                              : this.tag))));

    // Handle minPrice and maxPrice: empty string should be treated as null
    final String? finalMinPrice = clearMinPrice
        ? null
        : (minPrice != null
              ? (minPrice.isEmpty ? null : minPrice)
              : this.minPrice);
    final String? finalMaxPrice = clearMaxPrice
        ? null
        : (maxPrice != null
              ? (maxPrice.isEmpty ? null : maxPrice)
              : this.maxPrice);

    // Handle selectedAttributes: empty map {} should be kept, not converted to null
    final Map<int, List<int>>? finalSelectedAttributes = clearSelectedAttributes
        ? null
        : (selectedAttributes != null
              ? (selectedAttributes.isEmpty ? {} : selectedAttributes)
              : this.selectedAttributes);

    return ProductFilters(
      search: clearSearch ? null : (search ?? this.search),
      category: apiCategory,
      tag: apiTag,
      selectedCategories: clearSelectedCategories
          ? null
          : (selectedCategories ?? this.selectedCategories),
      selectedTags: clearSelectedTags
          ? null
          : (selectedTags ?? this.selectedTags),
      selectedAttributes: finalSelectedAttributes,
      onSale: clearOnSale ? null : (onSale ?? this.onSale),
      minPrice: finalMinPrice,
      maxPrice: finalMaxPrice,
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
        (selectedCategories != null && selectedCategories!.isNotEmpty) ||
        (selectedTags != null && selectedTags!.isNotEmpty) ||
        (selectedAttributes != null && selectedAttributes!.isNotEmpty) ||
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
  final StoreProductAttributesService _attributesService =
      GetIt.I<StoreProductAttributesService>();
  final StoreProductAttributeTermsService _attributeTermsService =
      GetIt.I<StoreProductAttributeTermsService>();
  final StoreProductCategoriesService _categoriesService =
      GetIt.I<StoreProductCategoriesService>();
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
  final int _perPage =
      50; // Increased from default to accommodate client-side filtering
  List<ListAllProductsResponseModel> _allProducts = [];

  // Attributes with terms for filtering
  List<AttributeWithTerms> _attributesWithTerms = [];

  // Categories
  List<ListProductCategoriesResponseModel> _categories = [];
  List<ListProductCategoriesResponseModel> get categories =>
      List.unmodifiable(_categories);

  // Guard to prevent multiple loadProducts calls
  bool _isLoadingProducts = false;

  // Track if initial load has been completed
  bool _hasInitialLoadCompleted = false;

  // Expanded sections state for filter UI
  final Set<String> _expandedSections = {};
  Set<String> get expandedSections => Set.unmodifiable(_expandedSections);

  /// Toggle expanded state for a filter section
  void toggleExpandedSection(String sectionKey) {
    if (_expandedSections.contains(sectionKey)) {
      _expandedSections.remove(sectionKey);
    } else {
      _expandedSections.add(sectionKey);
      // Don't call loadFilterOptions here - it's already called in initFilterDialog
      // This prevents infinite loop
    }
    // Emit current state to trigger UI rebuild
    final currentState = state;
    if (currentState is ProductListLoadedState) {
      emit(currentState);
    }
  }

  /// Check if a section is expanded
  bool isSectionExpanded(String sectionKey) {
    return _expandedSections.contains(sectionKey);
  }

  /// Check if temp filters have any active selections
  bool hasTempFilters() {
    final temp = _tempFilters;
    final hasCategories = (temp.selectedCategories?.isNotEmpty ?? false);
    final hasTags = (temp.selectedTags?.isNotEmpty ?? false);
    final hasAttributes = (temp.selectedAttributes?.isNotEmpty ?? false);
    final hasPrice = temp.minPrice != null || temp.maxPrice != null;
    final hasOnSale = temp.onSale == true;
    final hasStockStatus = temp.stockStatus != null;

    return hasCategories ||
        hasTags ||
        hasAttributes ||
        hasPrice ||
        hasOnSale ||
        hasStockStatus;
  }

  @override
  String get id => 'product_list_view_model_v1';

  /// Helper method to emit products loading state
  void _emitProductsLoading() {
    emit(
      ProductListLoadingState(
        products: state.products,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        attributesWithTerms: state.attributesWithTerms,
        categories: state.categories,
      ),
    );
  }

  /// Helper method to emit products loaded state
  void _emitProductsLoaded() {
    emit(
      ProductListLoadedState(
        products: _allProducts,
        hasMore: _allProducts.length >= _perPage,
        currentPage: _currentPage,
        totalPages: _totalPages,
        attributesWithTerms: _attributesWithTerms,
        categories: _categories,
      ),
    );
  }

  /// Helper method to emit products error state
  void _emitProductsError(String message) {
    emit(
      ProductListErrorState(
        message: message,
        products: state.products,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        attributesWithTerms: state.attributesWithTerms,
        categories: state.categories,
      ),
    );
  }

  /// Load products with current filters
  Future<void> loadProducts({bool refresh = false}) async {
    // Prevent multiple concurrent calls
    if (_isLoadingProducts) {
      debugPrint(
        '🚫 loadProducts already in progress (refresh: $refresh), skipping...',
      );
      return;
    }

    // If not refreshing and we already have products loaded, don't reload
    if (!refresh && _hasInitialLoadCompleted) {
      debugPrint(
        '🚫 Products already loaded (has ${_allProducts.length} products), skipping...',
      );
      return;
    }

    debugPrint(
      '🚀 ProductListViewModel.loadProducts called (refresh: $refresh, hasInitialLoad: $_hasInitialLoadCompleted, productsCount: ${_allProducts.length})',
    );

    _isLoadingProducts = true;

    try {
      if (refresh) {
        _currentPage = 1;
        _allProducts = [];
        _hasInitialLoadCompleted = false;
        _emitProductsLoading();
      } else {
        final currentState = state;
        if (currentState is! ProductListLoadedState) {
          _emitProductsLoading();
        }
      }

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Prepare price filters - ensure they're cleaned and valid
      // WooCommerce Store API expects price as string in the same format as product prices
      // Product prices are typically stored as strings like "2.00" or "100.50"
      // We need to match the exact format that products use
      String? minPrice;
      String? maxPrice;

      // Get currency info from first product to determine format
      int? currencyMinorUnit;
      if (_allProducts.isNotEmpty && _allProducts.first.prices != null) {
        currencyMinorUnit = _allProducts.first.prices!.currencyMinorUnit;
      }

      if (_filters.minPrice != null && _filters.minPrice!.isNotEmpty) {
        minPrice = _cleanPriceForApi(_filters.minPrice, currencyMinorUnit);
        if (minPrice == null || minPrice.isEmpty) {
          minPrice = null;
        }
      }

      if (_filters.maxPrice != null && _filters.maxPrice!.isNotEmpty) {
        maxPrice = _cleanPriceForApi(_filters.maxPrice, currencyMinorUnit);
        if (maxPrice == null || maxPrice.isEmpty) {
          maxPrice = null;
        }
      }

      // Get category - use first from selectedCategories if available
      int? categoryId;
      if (_filters.selectedCategories != null &&
          _filters.selectedCategories!.isNotEmpty) {
        categoryId = _filters.selectedCategories!.first;
      } else if (_filters.category != null) {
        categoryId = _filters.category;
      }

      // Get tag - use first from selectedTags if available
      int? tagId;
      if (_filters.selectedTags != null && _filters.selectedTags!.isNotEmpty) {
        tagId = _filters.selectedTags!.first;
      } else if (_filters.tag != null) {
        tagId = _filters.tag;
      }

      // Get first attribute and term for API (API supports single attribute/term)
      // WooCommerce Store API only supports filtering by one attribute and one term at a time
      // We need to use taxonomy name for attribute, not ID
      String? attributeId;
      String? attributeTermId;
      if (_filters.selectedAttributes != null &&
          _filters.selectedAttributes!.isNotEmpty) {
        final firstAttribute = _filters.selectedAttributes!.entries.first;
        final selectedAttributeId = firstAttribute.key;

        // Find the attribute from loaded attributes to get its taxonomy
        AttributeWithTerms? attributeWithTerms;
        try {
          attributeWithTerms = _attributesWithTerms.firstWhere(
            (attr) => attr.attribute.id == selectedAttributeId,
          );
        } catch (e) {
          debugPrint(
            '⚠️ Attribute $selectedAttributeId not found in loaded attributes, using ID as fallback',
          );
        }

        // Use taxonomy if available, otherwise fall back to ID as string
        attributeId =
            attributeWithTerms?.attribute.taxonomy ??
            selectedAttributeId.toString();

        if (firstAttribute.value.isNotEmpty) {
          final selectedTermId = firstAttribute.value.first;
          // Find the term to get its ID (already have it, but ensure it's correct)
          attributeTermId = selectedTermId.toString();
        }
        debugPrint(
          '🔍 Attribute filter: Using attribute taxonomy/ID "$attributeId" with term $attributeTermId',
        );
      } else {
        debugPrint('🔍 Attribute filter: No attributes selected');
      }

      debugPrint('🔍 ProductListViewModel: Loading products with filters:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Page: $_currentPage, Per Page: $_perPage');
      debugPrint('  - Min Price: $minPrice (raw: ${_filters.minPrice})');
      debugPrint('  - Max Price: $maxPrice (raw: ${_filters.maxPrice})');
      debugPrint('  - On Sale: ${_filters.onSale}');
      debugPrint('  - Stock Status: ${_filters.stockStatus}');
      debugPrint(
        '  - Category: $categoryId (from selected: ${_filters.selectedCategories})',
      );
      debugPrint('  - Tag: $tagId (from selected: ${_filters.selectedTags})');
      debugPrint(
        '  - Attribute: $attributeId, Term: $attributeTermId (from selected: ${_filters.selectedAttributes})',
      );
      debugPrint('  - Order By: ${_filters.orderBy}');
      debugPrint('  - Order: ${_filters.order}');
      debugPrint('  - Featured: ${_filters.featured}');
      debugPrint('  - Search: ${_filters.search}');

      final products = await _productService.listAllProducts(
        apiVersion: apiVersion,
        page: _currentPage,
        perPage: _perPage,
        search: _filters.search,
        category: categoryId,
        tag: tagId,
        onSale: _filters.onSale,
        minPrice: minPrice,
        maxPrice: maxPrice,
        stockStatus: _filters.stockStatus,
        orderBy: _filters.orderBy,
        order: _filters.order,
        featured: _filters.featured,
        attribute: attributeId,
        attributeTerm: attributeTermId,
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
            debugPrint(
              '    - regular_price: "${product.prices!.regularPrice}"',
            );
            debugPrint('    - sale_price: "${product.prices!.salePrice}"');
            debugPrint(
              '    - currency_code: "${product.prices!.currencyCode}"',
            );
            debugPrint(
              '    - currency_symbol: "${product.prices!.currencySymbol}"',
            );
            debugPrint(
              '    - currency_minor_unit: ${product.prices!.currencyMinorUnit}',
            );
          }
        }
      }

      if (products.isNotEmpty) {
        debugPrint(
          '✅ First product: ${products.first.name} (ID: ${products.first.id})',
        );
        if (products.first.prices != null) {
          debugPrint('✅ First product price: ${products.first.prices!.price}');
          debugPrint(
            '✅ First product regular price: ${products.first.prices!.regularPrice}',
          );
          debugPrint(
            '✅ First product sale price: ${products.first.prices!.salePrice}',
          );
        }
      }

      if (refresh || _currentPage == 1) {
        _allProducts = products;
      } else {
        _allProducts.addAll(products);
      }

      // Calculate total pages (assuming we have at least 1 page if products exist)
      _totalPages = products.length < _perPage
          ? _currentPage
          : _currentPage + 1; // Estimate, API doesn't always return total

      debugPrint(
        '📦 ProductListViewModel: Emitting loaded state with ${_allProducts.length} products',
      );
      _hasInitialLoadCompleted = true;
      _emitProductsLoaded();
      debugPrint('✅ ProductListViewModel: State emitted successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ ProductListViewModel: Error loading products: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      debugPrint('❌ Stack trace: $stackTrace');
      _emitProductsError(_getErrorMessage(e));
    } finally {
      _isLoadingProducts = false;
    }
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    // Prevent loading more if already loading
    if (_isLoadingProducts) {
      debugPrint('🚫 loadMore: Already loading products, skipping...');
      return;
    }

    final currentState = state;
    if (currentState.hasMore && !_isLoadingProducts) {
      _currentPage++;
      await loadProducts();
    }
  }

  // Track if dialog is initialized to prevent multiple initializations
  bool _dialogInitialized = false;
  // Track if attributes are being loaded to prevent multiple loads
  bool _isLoadingAttributes = false;
  bool _attributesLoaded = false;

  /// Initialize filter dialog - sets temp filters and controllers
  void initFilterDialog() {
    if (!_dialogInitialized) {
      debugPrint('🔧 initFilterDialog called - initializing...');
      _tempFilters = _filters;
      _minPriceController.text = _filters.minPrice ?? '';
      _maxPriceController.text = _filters.maxPrice ?? '';
      _dialogInitialized = true;
      debugPrint('✅ Filter dialog initialized');
      // Load attributes if not already loaded
      if (!_attributesLoaded && !_isLoadingAttributes) {
        loadAttributes();
      }

      // Load categories if not already loaded
      if (_categories.isEmpty) {
        loadCategories();
      }
    } else {
      debugPrint('🚫 initFilterDialog already initialized, skipping...');
    }
  }

  /// Load attributes and their terms for filtering
  Future<void> loadAttributes() async {
    // Prevent multiple concurrent loads
    if (_isLoadingAttributes) {
      debugPrint('🚫 loadAttributes already in progress, skipping...');
      return;
    }

    // If already loaded, skip
    if (_attributesLoaded && _attributesWithTerms.isNotEmpty) {
      debugPrint('✅ Attributes already loaded, skipping...');
      return;
    }

    try {
      _isLoadingAttributes = true;
      debugPrint('🔍 Loading attributes...');

      // Emit loading state only if we have products loaded
      final currentState = state;
      if (currentState is ProductListLoadedState) {
        emit(
          ProductListLoadedState(
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
            isLoadingFilterOptions: true,
          ),
        );
      } else {
        emit(
          ProductListFilterOptionsLoadingState(
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
          ),
        );
      }

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Load all attributes
      final attributes = await _attributesService.listProductAttributes(
        apiVersion: apiVersion,
        perPage: 100,
        hideEmpty: true,
      );

      debugPrint('✅ Loaded ${attributes.length} attributes');

      // Load terms for each attribute
      final List<AttributeWithTerms> attributesWithTermsList = [];
      for (final attribute in attributes) {
        if (attribute.id != null) {
          try {
            final terms = await _attributeTermsService
                .listProductAttributeTerms(
                  apiVersion: apiVersion,
                  attributeId: attribute.id!,
                  perPage: 100,
                  hideEmpty: true,
                );
            attributesWithTermsList.add(
              AttributeWithTerms(attribute: attribute, terms: terms),
            );
            debugPrint(
              '✅ Loaded ${terms.length} terms for attribute: ${attribute.name}',
            );
          } catch (e) {
            debugPrint(
              '⚠️ Failed to load terms for attribute ${attribute.id}: $e',
            );
            // Add attribute without terms if loading fails
            attributesWithTermsList.add(
              AttributeWithTerms(attribute: attribute, terms: []),
            );
          }
        }
      }

      _attributesWithTerms = attributesWithTermsList;
      _attributesLoaded = true;

      // Emit loaded state - preserve products state
      final updatedState = state;
      if (updatedState is ProductListLoadedState) {
        emit(
          ProductListLoadedState(
            products: updatedState.products,
            hasMore: updatedState.hasMore,
            currentPage: updatedState.currentPage,
            totalPages: updatedState.totalPages,
            attributesWithTerms: _attributesWithTerms,
            categories: updatedState.categories,
            isLoadingFilterOptions: false,
          ),
        );
      } else {
        emit(
          ProductListFilterOptionsLoadedState(
            products: updatedState.products,
            hasMore: updatedState.hasMore,
            currentPage: updatedState.currentPage,
            totalPages: updatedState.totalPages,
            attributesWithTerms: _attributesWithTerms,
            categories: updatedState.categories,
          ),
        );
      }

      debugPrint('✅ Attributes loaded successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading attributes: $e');
      debugPrint('❌ Stack trace: $stackTrace');

      // Emit error state - preserve products state
      final currentState = state;
      if (currentState is ProductListLoadedState) {
        emit(
          ProductListLoadedState(
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
            isLoadingFilterOptions: false,
            filterOptionsError:
                'Failed to load attributes: ${_getErrorMessage(e)}',
          ),
        );
      } else {
        emit(
          ProductListFilterOptionsErrorState(
            message: 'Failed to load attributes: ${_getErrorMessage(e)}',
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
          ),
        );
      }
    } finally {
      _isLoadingAttributes = false;
    }
  }

  /// Reset dialog initialization flag (call when dialog closes)
  void resetDialogInit() {
    _dialogInitialized = false;
  }

  /// Update temp filter (for filter dialog)
  /// Note: When a parameter is provided (even if null), it will update the filter
  /// When a parameter is not provided (omitted), it keeps the existing value
  void updateTempFilter({
    String? minPrice,
    String? maxPrice,
    bool? onSale,
    String? stockStatus,
    String? orderBy,
    String? order,
    List<int>? selectedCategories,
    List<int>? selectedTags,
    Map<int, List<int>>? selectedAttributes,
  }) {
    // Create a new map to track which parameters were explicitly provided
    // For Map and List, we need to handle them specially since null can mean "clear" or "don't change"
    // We'll use a wrapper approach: if parameter is provided in the function call, update it

    // For selectedAttributes: if provided (even if empty map), update it
    // If not provided, keep existing
    final Map<int, List<int>>? finalSelectedAttributes =
        selectedAttributes != null
        ? (selectedAttributes.isEmpty ? {} : selectedAttributes)
        : _tempFilters.selectedAttributes;

    // For selectedCategories: if provided (even if empty list), update it
    // If not provided, keep existing
    final List<int>? finalSelectedCategories = selectedCategories != null
        ? (selectedCategories.isEmpty ? [] : selectedCategories)
        : _tempFilters.selectedCategories;

    _tempFilters = _tempFilters.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      onSale: onSale,
      stockStatus: stockStatus,
      orderBy: orderBy,
      order: order,
      selectedCategories: finalSelectedCategories,
      selectedTags: selectedTags,
      selectedAttributes: finalSelectedAttributes,
    );

    debugPrint('🔍 updateTempFilter called:');
    debugPrint(
      '  - selectedCategories provided: ${selectedCategories != null}',
    );
    debugPrint('  - selectedCategories value: $selectedCategories');
    debugPrint('  - finalSelectedCategories: $finalSelectedCategories');
    debugPrint(
      '  - _tempFilters.selectedCategories after: ${_tempFilters.selectedCategories}',
    );
    debugPrint(
      '  - selectedAttributes provided: ${selectedAttributes != null}',
    );
    debugPrint('  - finalSelectedAttributes: $finalSelectedAttributes');
    debugPrint(
      '  - _tempFilters.selectedAttributes after: ${_tempFilters.selectedAttributes}',
    );

    // Emit current state to trigger rebuild in filter dialog
    // Preserve products and other state while updating filter options
    final currentState = state;
    if (currentState is ProductListLoadedState) {
      emit(
        ProductListLoadedState(
          products: currentState.products,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          attributesWithTerms: currentState.attributesWithTerms,
          categories: currentState.categories,
        ),
      );
    } else if (currentState is ProductListFilterOptionsLoadedState) {
      emit(
        ProductListFilterOptionsLoadedState(
          products: currentState.products,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          attributesWithTerms: currentState.attributesWithTerms,
          categories: currentState.categories,
        ),
      );
    } else {
      // Fallback: emit current state as-is
      emit(currentState);
    }
  }

  /// Clean price string for API - uses PriceInfoCurrencyHelper for consistent parsing
  /// Returns price as plain numeric string matching product price format
  /// WooCommerce Store API expects price as string in the same format as product prices
  /// Product prices come as String from API (e.g., "2.00", "100.50", "1,234.56")
  /// We need to parse user input and return in the same format as products use
  String? _cleanPriceForApi(String? priceString, int? currencyMinorUnit) {
    if (priceString == null || priceString.isEmpty) return null;

    // Get currency info from first product (most accurate) or filter options
    String? currencyCode;
    String? currencyDecimalSeparator;
    String? currencyThousandSeparator;
    int? finalCurrencyMinorUnit = currencyMinorUnit;

    if (_allProducts.isNotEmpty && _allProducts.first.prices != null) {
      final productPrices = _allProducts.first.prices!;
      currencyCode = productPrices.currencyCode?.toLowerCase();
      currencyDecimalSeparator = productPrices.currencyDecimalSeparator;
      currencyThousandSeparator = productPrices.currencyThousandSeparator;
      finalCurrencyMinorUnit ??= productPrices.currencyMinorUnit;
    }

    finalCurrencyMinorUnit ??= 2;

    // Use PriceInfoCurrencyHelper to parse the price (handles all formats)
    final parsedPrice = PriceInfoCurrencyHelper.parsePriceToDouble(
      priceString,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      currencyMinorUnit: finalCurrencyMinorUnit,
    );

    if (parsedPrice == null || parsedPrice < 0) {
      debugPrint(
        '⚠️ Price conversion failed: "$priceString" -> null (invalid)',
      );
      return null;
    }

    // Return as plain numeric string with decimal point
    // IMPORTANT: Match product price format exactly
    // Product prices from API are plain numeric strings like "2.00" or "100.50"
    // Always use dot as decimal separator for API (WooCommerce standard)
    // Keep all decimal places to match product format
    final formatted = parsedPrice.toStringAsFixed(finalCurrencyMinorUnit);

    debugPrint(
      '🔍 Price conversion: "$priceString" -> $parsedPrice -> "$formatted" (minorUnit: $finalCurrencyMinorUnit)',
    );

    return formatted;
  }

  /// Apply filters and reload products
  Future<void> applyFilters() async {
    // Get currency info for price formatting
    int? currencyMinorUnit;
    if (_allProducts.isNotEmpty && _allProducts.first.prices != null) {
      currencyMinorUnit = _allProducts.first.prices!.currencyMinorUnit;
    }

    // Clean price values for API
    final cleanMinPrice = _cleanPriceForApi(
      _tempFilters.minPrice,
      currencyMinorUnit,
    );
    final cleanMaxPrice = _cleanPriceForApi(
      _tempFilters.maxPrice,
      currencyMinorUnit,
    );

    debugPrint('🔍 ProductListViewModel: Applying filters:');
    debugPrint('  - Temp Min Price: ${_tempFilters.minPrice}');
    debugPrint('  - Cleaned Min Price: $cleanMinPrice');
    debugPrint('  - Temp Max Price: ${_tempFilters.maxPrice}');
    debugPrint('  - Cleaned Max Price: $cleanMaxPrice');
    debugPrint('  - Selected Categories: ${_tempFilters.selectedCategories}');
    debugPrint('  - Selected Tags: ${_tempFilters.selectedTags}');
    debugPrint('  - Selected Attributes: ${_tempFilters.selectedAttributes}');
    debugPrint('  - On Sale: ${_tempFilters.onSale}');
    debugPrint('  - Stock Status: ${_tempFilters.stockStatus}');
    debugPrint('  - Order By: ${_tempFilters.orderBy}');
    debugPrint('  - Order: ${_tempFilters.order}');

    // Copy ALL filters from tempFilters to filters, including cleaned prices
    // Explicitly copy all filters to ensure they're properly transferred
    _filters = _tempFilters.copyWith(
      minPrice: cleanMinPrice,
      maxPrice: cleanMaxPrice,
      selectedCategories: _tempFilters.selectedCategories,
      selectedTags: _tempFilters.selectedTags,
      selectedAttributes: _tempFilters.selectedAttributes,
      onSale: _tempFilters.onSale,
      stockStatus: _tempFilters.stockStatus,
      orderBy: _tempFilters.orderBy,
      order: _tempFilters.order,
      // All other filters are already in _tempFilters, so they'll be copied
      // by copyWith's default behavior (using ?? operator)
    );

    debugPrint('🔍 ProductListViewModel: After applyFilters:');
    debugPrint(
      '  - _filters.selectedAttributes: ${_filters.selectedAttributes}',
    );
    debugPrint(
      '  - _filters.selectedCategories: ${_filters.selectedCategories}',
    );
    debugPrint('  - _filters.selectedTags: ${_filters.selectedTags}');
    _currentPage = 1;
    _allProducts = [];
    await loadProducts(refresh: true);
  }

  /// Update a single filter (for chip close actions)
  Future<void> updateFilter({
    String? search,
    int? category,
    int? tag,
    List<int>? selectedCategories,
    List<int>? selectedTags,
    Map<int, List<int>>? selectedAttributes,
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
      selectedCategories: selectedCategories,
      selectedTags: selectedTags,
      selectedAttributes: selectedAttributes,
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
      clearSelectedCategories: selectedCategories == null,
      clearSelectedTags: selectedTags == null,
      clearSelectedAttributes: selectedAttributes == null,
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
    _filters = const ProductFilters(orderBy: 'date', order: 'desc');
    _tempFilters = const ProductFilters(orderBy: 'date', order: 'desc');
    _minPriceController.clear();
    _maxPriceController.clear();
    _currentPage = 1;
    _allProducts = [];
    _hasInitialLoadCompleted = false; // Reset flag to allow reload
    await loadProducts(refresh: true);
  }

  /// Load categories from API
  Future<void> loadCategories() async {
    try {
      debugPrint('📂 ProductListViewModel: Loading categories...');

      // Emit loading state for filter options
      final currentState = state;
      if (currentState is ProductListLoadedState) {
        emit(
          ProductListLoadedState(
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
            isLoadingFilterOptions: true,
          ),
        );
      } else {
        emit(
          ProductListFilterOptionsLoadingState(
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
          ),
        );
      }

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      final categories = await _categoriesService.listProductCategories(
        apiVersion: apiVersion,
        perPage: 100, // Get all categories
        hideEmpty: true, // Only get categories with products
      );

      _categories = categories;
      debugPrint(
        '✅ ProductListViewModel: Loaded ${categories.length} categories',
      );

      // Emit loaded state with categories - preserve products and attributes
      final updatedState = state;
      if (updatedState is ProductListLoadedState) {
        emit(
          ProductListLoadedState(
            products: updatedState.products,
            hasMore: updatedState.hasMore,
            currentPage: updatedState.currentPage,
            totalPages: updatedState.totalPages,
            attributesWithTerms: updatedState.attributesWithTerms,
            categories: _categories,
            isLoadingFilterOptions: false,
          ),
        );
      } else {
        emit(
          ProductListFilterOptionsLoadedState(
            products: updatedState.products,
            hasMore: updatedState.hasMore,
            currentPage: updatedState.currentPage,
            totalPages: updatedState.totalPages,
            attributesWithTerms: updatedState.attributesWithTerms,
            categories: _categories,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ ProductListViewModel: Error loading categories: $e');
      debugPrint('❌ Stack trace: $stackTrace');

      final currentState = state;
      if (currentState is ProductListLoadedState) {
        emit(
          ProductListLoadedState(
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
            isLoadingFilterOptions: false,
            filterOptionsError: 'Failed to load categories: ${_getErrorMessage(e)}',
          ),
        );
      } else {
        emit(
          ProductListFilterOptionsErrorState(
            message: 'Failed to load categories: ${_getErrorMessage(e)}',
            products: currentState.products,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            totalPages: currentState.totalPages,
            attributesWithTerms: currentState.attributesWithTerms,
            categories: currentState.categories,
          ),
        );
      }
    }
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
