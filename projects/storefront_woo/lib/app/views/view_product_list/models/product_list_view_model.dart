import 'package:core/core.dart' as core;
import 'package:core/core.dart' show PriceInfoCurrencyHelper;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/get_filter_options_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_tags_api/abstract/store_product_tags_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/abstract/store_product_attributes_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attribute_terms/abstract/store_product_attribute_terms_service.dart';
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
  final StoreProductCategoriesService _categoriesService =
      GetIt.I<StoreProductCategoriesService>();
  final StoreProductTagsService _tagsService =
      GetIt.I<StoreProductTagsService>();
  final StoreProductAttributesService _attributesService =
      GetIt.I<StoreProductAttributesService>();
  final StoreProductAttributeTermsService _attributeTermsService =
      GetIt.I<StoreProductAttributeTermsService>();
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

  // Filter options from API
  GetFilterOptionsResponseModel? _filterOptions;
  GetFilterOptionsResponseModel? get filterOptions => _filterOptions;

  // Guard to prevent multiple loadFilterOptions calls
  bool _isLoadingFilterOptions = false;

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

  /// Load filter options from API
  /// This method loads all filter options from APIs without any mock data
  Future<void> loadFilterOptions() async {
    // Prevent multiple concurrent calls
    if (_isLoadingFilterOptions) {
      debugPrint('🚫 loadFilterOptions already in progress, skipping...');
      return;
    }

    _isLoadingFilterOptions = true;
    debugPrint('🔧 ProductListViewModel.loadFilterOptions called');

    // Emit loading state for filter options
    _emitFilterOptionsLoading();

    try {
      // Get API version with fallback
      final apiVersion = _config.getString('woocommerce_configuration.version');

      final finalApiVersion = apiVersion.isEmpty ? 'v1' : apiVersion;
      debugPrint(
        '🔧 Loading filter options with API version: $finalApiVersion',
      );

      // Try to load from getFilterOptions API first
      GetFilterOptionsResponseModel? filterOptionsResponse;
      try {
        filterOptionsResponse = await _productService.getFilterOptions(
          apiVersion: finalApiVersion,
          includeAttributes: true,
          includeCategories: true,
          includeTags: true,
        );
        debugPrint('✅ Filter options loaded from getFilterOptions API');
      } catch (apiError) {
        debugPrint(
          '⚠️ getFilterOptions API failed, loading from individual APIs: $apiError',
        );
      }

      // If getFilterOptions doesn't have categories/tags/attributes, load them separately
      List<FilterCategoryModel>? categories;
      List<FilterTagModel>? tags;
      List<FilterAttributeModel>? attributes;

      // Load categories if not available in filterOptionsResponse
      if (filterOptionsResponse == null ||
          filterOptionsResponse.categories == null ||
          filterOptionsResponse.categories!.isEmpty) {
        try {
          debugPrint('📂 Loading categories from API...');
          // Only load parent categories (parent: 0) to avoid showing parent then children
          final categoriesList = await _categoriesService.listProductCategories(
            apiVersion: finalApiVersion,
            hideEmpty: true,
            perPage: 100,
            parent: 0, // Only get top-level categories
          );
          categories = categoriesList
              .map(
                (cat) => FilterCategoryModel(
                  id: cat.id ?? 0,
                  name: cat.name ?? '',
                  slug: cat.slug ?? '',
                  count: cat.count,
                ),
              )
              .toList();
          debugPrint(
            '✅ Loaded ${categories.length} parent categories from API',
          );
        } catch (e) {
          debugPrint('❌ Error loading categories: $e');
        }
      } else {
        categories = filterOptionsResponse.categories;
        debugPrint(
          '✅ Using categories from getFilterOptions API: ${categories?.length ?? 0}',
        );
      }

      // Load tags if not available in filterOptionsResponse
      if (filterOptionsResponse == null ||
          filterOptionsResponse.tags == null ||
          filterOptionsResponse.tags!.isEmpty) {
        try {
          debugPrint('🏷️ Loading tags from API...');
          final tagsList = await _tagsService.listProductTags(
            apiVersion: finalApiVersion,
            hideEmpty: true,
            perPage: 100,
          );
          tags = tagsList
              .map(
                (tag) => FilterTagModel(
                  id: tag.id ?? 0,
                  name: tag.name ?? '',
                  slug: tag.slug ?? '',
                  count: tag.count,
                ),
              )
              .toList();
          debugPrint('✅ Loaded ${tags.length} tags from API');
        } catch (e) {
          debugPrint('❌ Error loading tags: $e');
        }
      } else {
        tags = filterOptionsResponse.tags;
        debugPrint(
          '✅ Using tags from getFilterOptions API: ${tags?.length ?? 0}',
        );
      }

      // Load attributes if not available in filterOptionsResponse
      if (filterOptionsResponse == null ||
          filterOptionsResponse.availableAttributes == null ||
          filterOptionsResponse.availableAttributes!.isEmpty) {
        try {
          debugPrint('🎨 Loading attributes from API...');
          final attributesList = await _attributesService.listProductAttributes(
            apiVersion: finalApiVersion,
            hideEmpty: true,
            perPage: 100,
          );
          debugPrint(
            '📋 Found ${attributesList.length} attributes, loading terms...',
          );

          // Load terms for each attribute
          final attributesWithTerms = <FilterAttributeModel>[];
          for (final attr in attributesList) {
            try {
              debugPrint(
                '  🔍 Loading terms for attribute: ${attr.name} (ID: ${attr.id})',
              );
              final termsList = await _attributeTermsService
                  .listProductAttributeTerms(
                    apiVersion: finalApiVersion,
                    attributeId: attr.id ?? 0,
                    hideEmpty: true,
                    perPage: 100,
                  );
              debugPrint(
                '  ✅ Loaded ${termsList.length} terms for attribute ${attr.name}',
              );
              attributesWithTerms.add(
                FilterAttributeModel(
                  id: attr.id ?? 0,
                  name: attr.name ?? '',
                  slug: attr.taxonomy ?? '',
                  terms: termsList
                      .map(
                        (term) => FilterTermModel(
                          id: term.id ?? 0,
                          name: term.name ?? '',
                          slug: term.slug ?? '',
                          count: term.count,
                        ),
                      )
                      .toList(),
                ),
              );
            } catch (e) {
              debugPrint(
                '❌ Error loading terms for attribute ${attr.id} (${attr.name}): $e',
              );
            }
          }
          attributes = attributesWithTerms;
          debugPrint(
            '✅ Loaded ${attributes.length} attributes with terms from API',
          );
        } catch (e) {
          debugPrint('❌ Error loading attributes: $e');
        }
      } else {
        attributes = filterOptionsResponse.availableAttributes;
        debugPrint(
          '✅ Using attributes from getFilterOptions API: ${attributes?.length ?? 0}',
        );
      }

      // Build final filter options response
      // IMPORTANT: Only use real data from API - NO MOCK DATA
      if (filterOptionsResponse != null) {
        // We have a response from getFilterOptions API
        _filterOptions = GetFilterOptionsResponseModel(
          sortOptions: filterOptionsResponse.sortOptions,
          stockStatuses: filterOptionsResponse.stockStatuses,
          priceRange: filterOptionsResponse.priceRange,
          categories: categories ?? filterOptionsResponse.categories,
          tags: tags ?? filterOptionsResponse.tags,
          availableAttributes:
              attributes ?? filterOptionsResponse.availableAttributes,
        );
      } else {
        // getFilterOptions API failed or doesn't exist
        // Create filter options from individual API data with default sort/stock/price range
        // This is acceptable because sort options and stock statuses are standard in WooCommerce
        debugPrint(
          '⚠️ getFilterOptions API not available, creating filter options from individual APIs',
        );

        // Create filter options with default/standard values for sort, stock, and price
        // These are standard WooCommerce values that work with the Store API
        _filterOptions = GetFilterOptionsResponseModel(
          sortOptions: const [
            SortOptionModel(
              key: 'date',
              label: 'Date',
              orders: [
                OrderOptionModel(key: 'desc', label: 'Newest'),
                OrderOptionModel(key: 'asc', label: 'Oldest'),
              ],
            ),
            SortOptionModel(
              key: 'price',
              label: 'Price',
              orders: [
                OrderOptionModel(key: 'asc', label: 'Low to High'),
                OrderOptionModel(key: 'desc', label: 'High to Low'),
              ],
            ),
            SortOptionModel(
              key: 'title',
              label: 'Name',
              orders: [
                OrderOptionModel(key: 'asc', label: 'A to Z'),
                OrderOptionModel(key: 'desc', label: 'Z to A'),
              ],
            ),
            SortOptionModel(
              key: 'popularity',
              label: 'Popularity',
              orders: [
                OrderOptionModel(key: 'desc', label: 'Most Popular'),
                OrderOptionModel(key: 'asc', label: 'Least Popular'),
              ],
            ),
            SortOptionModel(
              key: 'rating',
              label: 'Rating',
              orders: [
                OrderOptionModel(key: 'desc', label: 'Highest Rated'),
                OrderOptionModel(key: 'asc', label: 'Lowest Rated'),
              ],
            ),
          ],
          stockStatuses: const [
            StockStatusModel(key: 'instock', label: 'In stock', enabled: true),
            StockStatusModel(
              key: 'outofstock',
              label: 'Out of stock',
              enabled: true,
            ),
            StockStatusModel(
              key: 'onbackorder',
              label: 'On backorder',
              enabled: true,
            ),
          ],
          priceRange: const PriceRangeModel(
            minPrice: 0.0,
            maxPrice: 999999.99,
            currency: 'USD',
            currencySymbol: '\$',
            currencyMinorUnit: 2,
          ),
          categories: categories,
          tags: tags,
          availableAttributes: attributes,
        );

        debugPrint(
          '✅ Created filter options from individual APIs with default sort/stock/price',
        );
      }

      // Validate we have at least some filter options
      if (_filterOptions == null) {
        debugPrint('❌ No filter data available from API');
        _emitFilterOptionsError('No filter options available from API');
        return;
      }

      debugPrint('✅ Final filter options:');
      debugPrint('   - Categories: ${_filterOptions!.categories?.length ?? 0}');
      debugPrint('   - Tags: ${_filterOptions!.tags?.length ?? 0}');
      debugPrint(
        '   - Attributes: ${_filterOptions!.availableAttributes?.length ?? 0}',
      );

      // Emit success state with filter options
      _emitFilterOptionsLoaded();
    } catch (e, stackTrace) {
      debugPrint('❌ ProductListViewModel: Error loading filter options: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      _emitFilterOptionsError(_getErrorMessage(e));
    } finally {
      _isLoadingFilterOptions = false;
    }
  }

  /// Helper method to emit filter options loading state
  void _emitFilterOptionsLoading() {
    final currentState = state;
    emit(
      ProductListFilterOptionsLoadingState(
        products: currentState.products,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        filterOptions: currentState.filterOptions,
        isLoadingProducts: currentState.isLoadingProducts,
        productsError: currentState.productsError,
      ),
    );
  }

  /// Helper method to emit filter options loaded state
  void _emitFilterOptionsLoaded() {
    final currentState = state;
    emit(
      ProductListFilterOptionsLoadedState(
        filterOptions: _filterOptions!,
        products: currentState.products,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        isLoadingProducts: currentState.isLoadingProducts,
        productsError: currentState.productsError,
      ),
    );
  }

  /// Helper method to emit filter options error state
  void _emitFilterOptionsError(String message) {
    final currentState = state;
    emit(
      ProductListFilterOptionsErrorState(
        message: message,
        products: currentState.products,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        filterOptions: currentState.filterOptions,
        isLoadingProducts: currentState.isLoadingProducts,
        productsError: currentState.productsError,
      ),
    );
  }

  /// Helper method to emit products loading state
  void _emitProductsLoading() {
    final currentState = state;
    emit(
      ProductListLoadingState(
        products: currentState.products,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        filterOptions: currentState.filterOptions,
        isLoadingFilterOptions: currentState.isLoadingFilterOptions,
        filterOptionsError: currentState.filterOptionsError,
      ),
    );
  }

  /// Helper method to emit products loaded state
  void _emitProductsLoaded() {
    final currentState = state;
    emit(
      ProductListLoadedState(
        products: _allProducts,
        hasMore: _allProducts.length >= _perPage,
        currentPage: _currentPage,
        totalPages: _totalPages,
        filterOptions: currentState.filterOptions ?? _filterOptions,
        isLoadingFilterOptions: currentState.isLoadingFilterOptions,
        filterOptionsError: currentState.filterOptionsError,
      ),
    );
  }

  /// Helper method to emit products error state
  void _emitProductsError(String message) {
    final currentState = state;
    emit(
      ProductListErrorState(
        message: message,
        products: currentState.products,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        filterOptions: currentState.filterOptions,
        isLoadingFilterOptions: currentState.isLoadingFilterOptions,
        filterOptionsError: currentState.filterOptionsError,
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

      // Get currency info from first product or filter options to determine format
      int? currencyMinorUnit;
      if (_allProducts.isNotEmpty && _allProducts.first.prices != null) {
        currencyMinorUnit = _allProducts.first.prices!.currencyMinorUnit;
      } else if (_filterOptions?.priceRange != null) {
        currencyMinorUnit = _filterOptions!.priceRange.currencyMinorUnit;
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
      // IMPORTANT: WooCommerce Store API expects attribute as taxonomy slug (e.g., "pa_color") not ID
      String? attributeId;
      String? attributeTermId;
      if (_filters.selectedAttributes != null &&
          _filters.selectedAttributes!.isNotEmpty) {
        final firstAttribute = _filters.selectedAttributes!.entries.first;
        final selectedAttributeId = firstAttribute.key;

        // Find the attribute in filter options to get its slug/taxonomy
        if (_filterOptions?.availableAttributes != null) {
          try {
            final matchingAttribute = _filterOptions!.availableAttributes!
                .firstWhere((attr) => attr.id == selectedAttributeId);

            // Use attribute slug (taxonomy) instead of ID for API
            // WooCommerce Store API expects taxonomy like "pa_color" or "pa_size"
            attributeId = matchingAttribute.slug;

            if (firstAttribute.value.isNotEmpty) {
              // Find the term to verify it exists
              final selectedTermId = firstAttribute.value.first;
              final matchingTerm = matchingAttribute.terms.firstWhere(
                (term) => term.id == selectedTermId,
                orElse: () => throw StateError(
                  'Term ID $selectedTermId not found in attribute ${matchingAttribute.name}',
                ),
              );
              // WooCommerce Store API expects term as ID (string), not slug
              // Use term ID as string for API compatibility
              attributeTermId = matchingTerm.id.toString();

              debugPrint(
                '🔍 Attribute filter: Found ${_filters.selectedAttributes!.length} attributes',
              );
              debugPrint(
                '  - Selected attribute: ${matchingAttribute.name} (ID: ${matchingAttribute.id}, Slug: ${matchingAttribute.slug})',
              );
              debugPrint(
                '  - Selected term: ${matchingTerm.name} (ID: ${matchingTerm.id})',
              );
              debugPrint('  - Using attribute slug for API: $attributeId');
              debugPrint('  - Using term ID for API: $attributeTermId');
            }
          } catch (e) {
            debugPrint('❌ Error finding attribute/term in filter options: $e');
            debugPrint('  - Selected attribute ID: $selectedAttributeId');
            debugPrint(
              '  - Available attributes: ${_filterOptions!.availableAttributes!.map((a) => '${a.name} (ID: ${a.id}, Slug: ${a.slug})').join(', ')}',
            );
            // Fallback: use ID as string (might not work but worth trying)
            attributeId = selectedAttributeId.toString();
            if (firstAttribute.value.isNotEmpty) {
              attributeTermId = firstAttribute.value.first.toString();
            }
            debugPrint(
              '  - ⚠️ Fallback: Using attribute ID as string: $attributeId',
            );
          }
        } else {
          // No filter options available, use ID as fallback
          attributeId = selectedAttributeId.toString();
          if (firstAttribute.value.isNotEmpty) {
            attributeTermId = firstAttribute.value.first.toString();
          }
          debugPrint(
            '⚠️ No filter options available, using attribute ID as fallback: $attributeId',
          );
        }
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

  /// Initialize filter dialog - sets temp filters and controllers
  void initFilterDialog() {
    if (!_dialogInitialized && !_isLoadingFilterOptions) {
      debugPrint('🔧 initFilterDialog called - initializing...');

      // Always load filter options when dialog opens to ensure fresh data
      // Only load if not already loading and not already loaded
      if (_filterOptions == null && !_isLoadingFilterOptions) {
        debugPrint('🔧 Loading filter options...');
        loadFilterOptions();
      } else {
        debugPrint('⏳ Filter options already loaded or loading...');
      }

      _tempFilters = _filters;
      _minPriceController.text = _filters.minPrice ?? '';
      _maxPriceController.text = _filters.maxPrice ?? '';
      _dialogInitialized = true;

      // Don't emit state here - it causes infinite rebuild loop
      // State will be updated when loadFilterOptions completes
      debugPrint('✅ Filter dialog initialized');
    } else {
      debugPrint(
        '🚫 initFilterDialog already initialized or loading, skipping... (initialized: $_dialogInitialized, loading: $_isLoadingFilterOptions)',
      );
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

    _tempFilters = _tempFilters.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      onSale: onSale,
      stockStatus: stockStatus,
      orderBy: orderBy,
      order: order,
      selectedCategories: selectedCategories,
      selectedTags: selectedTags,
      selectedAttributes: finalSelectedAttributes,
    );

    debugPrint('🔍 updateTempFilter called:');
    debugPrint(
      '  - selectedAttributes provided: ${selectedAttributes != null}',
    );
    debugPrint('  - finalSelectedAttributes: $finalSelectedAttributes');
    debugPrint(
      '  - _tempFilters.selectedAttributes after: ${_tempFilters.selectedAttributes}',
    );

    // Emit current state to trigger rebuild in filter dialog
    final currentState = state;
    // Preserve current state structure
    if (currentState is ProductListLoadedState) {
      emit(
        ProductListLoadedState(
          products: currentState.products,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          filterOptions: currentState.filterOptions ?? _filterOptions,
          isLoadingFilterOptions: currentState.isLoadingFilterOptions,
          filterOptionsError: currentState.filterOptionsError,
        ),
      );
    } else if (currentState is ProductListFilterOptionsLoadedState) {
      emit(
        ProductListFilterOptionsLoadedState(
          filterOptions: currentState.filterOptions ?? _filterOptions!,
          products: currentState.products,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          isLoadingProducts: currentState.isLoadingProducts,
          productsError: currentState.productsError,
        ),
      );
    } else {
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
    } else if (_filterOptions?.priceRange != null) {
      final priceRange = _filterOptions!.priceRange;
      currencyCode = priceRange.currency?.toLowerCase();
      finalCurrencyMinorUnit ??= priceRange.currencyMinorUnit;
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
    } else if (_filterOptions?.priceRange != null) {
      currencyMinorUnit = _filterOptions!.priceRange.currencyMinorUnit;
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
