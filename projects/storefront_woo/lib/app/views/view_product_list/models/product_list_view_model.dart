import 'package:core/core.dart' as core;
import 'package:flutter/foundation.dart';
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
  final int? category; // Single category for API (uses first from selectedCategories)
  final int? tag; // Single tag for API (uses first from selectedTags)
  final List<int>? selectedCategories; // Multiple categories selection
  final List<int>? selectedTags; // Multiple tags selection
  final Map<int, List<int>>? selectedAttributes; // Map of attributeId -> list of termIds
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
            : (clearCategory ? null : (category ?? (this.selectedCategories?.isNotEmpty == true ? this.selectedCategories!.first : this.category))));
    final apiTag = clearSelectedTags 
        ? null 
        : (selectedTags?.isNotEmpty == true 
            ? selectedTags!.first 
            : (clearTag ? null : (tag ?? (this.selectedTags?.isNotEmpty == true ? this.selectedTags!.first : this.tag))));
    
    return ProductFilters(
      search: clearSearch ? null : (search ?? this.search),
      category: apiCategory,
      tag: apiTag,
      selectedCategories: clearSelectedCategories ? null : (selectedCategories ?? this.selectedCategories),
      selectedTags: clearSelectedTags ? null : (selectedTags ?? this.selectedTags),
      selectedAttributes: clearSelectedAttributes ? null : (selectedAttributes ?? this.selectedAttributes),
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
  final StoreProductCategoriesService _categoriesService = GetIt.I<StoreProductCategoriesService>();
  final StoreProductTagsService _tagsService = GetIt.I<StoreProductTagsService>();
  final StoreProductAttributesService _attributesService = GetIt.I<StoreProductAttributesService>();
  final StoreProductAttributeTermsService _attributeTermsService = GetIt.I<StoreProductAttributeTermsService>();
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

  // Filter options from API
  GetFilterOptionsResponseModel? _filterOptions;
  GetFilterOptionsResponseModel? get filterOptions => _filterOptions;
  
  // Guard to prevent multiple loadFilterOptions calls
  bool _isLoadingFilterOptions = false;

  // Expanded sections state for filter UI
  final Set<String> _expandedSections = {};
  Set<String> get expandedSections => Set.unmodifiable(_expandedSections);

  /// Toggle expanded state for a filter section
  void toggleExpandedSection(String sectionKey) {
    if (_expandedSections.contains(sectionKey)) {
      _expandedSections.remove(sectionKey);
    } else {
      _expandedSections.add(sectionKey);
      // Load filter options when section is expanded
      if (sectionKey == 'categories' || sectionKey == 'tags') {
        if (_filterOptions == null) {
          loadFilterOptions();
        }
      }
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
    
    return hasCategories || hasTags || hasAttributes || hasPrice || hasOnSale || hasStockStatus;
  }

  @override
  String get id => 'product_list_view_model_v1';

  /// Load filter options from API
  Future<void> loadFilterOptions() async {
    // Prevent multiple concurrent calls
    if (_isLoadingFilterOptions) {
      debugPrint('🚫 loadFilterOptions already in progress, skipping...');
      return;
    }
    
    _isLoadingFilterOptions = true;
    debugPrint('🔧 ProductListViewModel.loadFilterOptions called');
    
    try {
      // Get API version with fallback
      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
      );
      
      final finalApiVersion = apiVersion.isEmpty ? 'v1' : apiVersion;
      debugPrint('🔧 Loading filter options with API version: $finalApiVersion');
      
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
        debugPrint('⚠️ getFilterOptions API failed, loading from individual APIs: $apiError');
      }

      // If getFilterOptions doesn't have categories/tags/attributes, load them separately
      List<FilterCategoryModel>? categories;
      List<FilterTagModel>? tags;
      List<FilterAttributeModel>? attributes;

      // Load categories if not available in filterOptionsResponse
      if (filterOptionsResponse == null || filterOptionsResponse.categories == null || filterOptionsResponse.categories!.isEmpty) {
        try {
          debugPrint('📂 Loading categories from API...');
          final categoriesList = await _categoriesService.listProductCategories(
            apiVersion: finalApiVersion,
            hideEmpty: true,
            perPage: 100,
          );
          categories = categoriesList.map((cat) => FilterCategoryModel(
            id: cat.id ?? 0,
            name: cat.name ?? '',
            slug: cat.slug ?? '',
            count: cat.count,
          )).toList();
          debugPrint('✅ Loaded ${categories.length} categories from API');
        } catch (e) {
          debugPrint('❌ Error loading categories: $e');
        }
      } else {
        categories = filterOptionsResponse.categories;
        debugPrint('✅ Using categories from getFilterOptions API: ${categories?.length ?? 0}');
      }

      // Load tags if not available in filterOptionsResponse
      if (filterOptionsResponse == null || filterOptionsResponse.tags == null || filterOptionsResponse.tags!.isEmpty) {
        try {
          debugPrint('🏷️ Loading tags from API...');
          final tagsList = await _tagsService.listProductTags(
            apiVersion: finalApiVersion,
            hideEmpty: true,
            perPage: 100,
          );
          tags = tagsList.map((tag) => FilterTagModel(
            id: tag.id ?? 0,
            name: tag.name ?? '',
            slug: tag.slug ?? '',
            count: tag.count,
          )).toList();
          debugPrint('✅ Loaded ${tags.length} tags from API');
        } catch (e) {
          debugPrint('❌ Error loading tags: $e');
        }
      } else {
        tags = filterOptionsResponse.tags;
        debugPrint('✅ Using tags from getFilterOptions API: ${tags?.length ?? 0}');
      }

      // Load attributes if not available in filterOptionsResponse
      if (filterOptionsResponse == null || filterOptionsResponse.availableAttributes == null || filterOptionsResponse.availableAttributes!.isEmpty) {
        try {
          debugPrint('🎨 Loading attributes from API...');
          final attributesList = await _attributesService.listProductAttributes(
            apiVersion: finalApiVersion,
            hideEmpty: true,
            perPage: 100,
          );
          debugPrint('📋 Found ${attributesList.length} attributes, loading terms...');
          
          // Load terms for each attribute
          final attributesWithTerms = <FilterAttributeModel>[];
          for (final attr in attributesList) {
            try {
              debugPrint('  🔍 Loading terms for attribute: ${attr.name} (ID: ${attr.id})');
              final termsList = await _attributeTermsService.listProductAttributeTerms(
                apiVersion: finalApiVersion,
                attributeId: attr.id ?? 0,
                hideEmpty: true,
                perPage: 100,
              );
              debugPrint('  ✅ Loaded ${termsList.length} terms for attribute ${attr.name}');
              attributesWithTerms.add(FilterAttributeModel(
                id: attr.id ?? 0,
                name: attr.name ?? '',
                slug: attr.taxonomy ?? '',
                terms: termsList.map((term) => FilterTermModel(
                  id: term.id ?? 0,
                  name: term.name ?? '',
                  slug: term.slug ?? '',
                  count: term.count,
                )).toList(),
              ));
            } catch (e) {
              debugPrint('❌ Error loading terms for attribute ${attr.id} (${attr.name}): $e');
            }
          }
          attributes = attributesWithTerms;
          debugPrint('✅ Loaded ${attributes.length} attributes with terms from API');
        } catch (e) {
          debugPrint('❌ Error loading attributes: $e');
        }
      } else {
        attributes = filterOptionsResponse.availableAttributes;
        debugPrint('✅ Using attributes from getFilterOptions API: ${attributes?.length ?? 0}');
      }

      // Build final filter options response
      if (filterOptionsResponse != null) {
        _filterOptions = GetFilterOptionsResponseModel(
          sortOptions: filterOptionsResponse.sortOptions,
          stockStatuses: filterOptionsResponse.stockStatuses,
          priceRange: filterOptionsResponse.priceRange,
          categories: categories ?? filterOptionsResponse.categories,
          tags: tags ?? filterOptionsResponse.tags,
          availableAttributes: attributes ?? filterOptionsResponse.availableAttributes,
        );
      } else {
        // If getFilterOptions completely failed, use mock data but with real categories/tags/attributes
        _filterOptions = _createMockFilterOptions(
          categories: categories,
          tags: tags,
          attributes: attributes,
        );
      }

      debugPrint('✅ Final filter options:');
      debugPrint('   - Categories: ${_filterOptions!.categories?.length ?? 0}');
      debugPrint('   - Tags: ${_filterOptions!.tags?.length ?? 0}');
      debugPrint('   - Attributes: ${_filterOptions!.availableAttributes?.length ?? 0}');
      
      // Update current state to include filter options
      final currentState = state;
      if (currentState is ProductListLoadedState) {
        emit(ProductListLoadedState(
          products: currentState.products,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          filterOptions: _filterOptions,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ ProductListViewModel: Error loading filter options: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      // Don't emit error state for filter options as it's not critical
      // Just log the error and continue with static filters
    } finally {
      _isLoadingFilterOptions = false;
    }
  }

  /// Test method to force load real API data
  /// Call this from debug UI to test real API
  Future<void> testRealApiFilterOptions() async {
    if (!kDebugMode) return;
    
    debugPrint('🧪 Testing REAL API filter options...');
    
    // Reset loading flag to allow real API test
    _isLoadingFilterOptions = false;
    
    try {
      // Get API version with fallback
      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
      );
      
      final finalApiVersion = apiVersion.isEmpty ? 'v1' : apiVersion;
      debugPrint('🧪 Testing with API version: $finalApiVersion');
      
      final filterOptionsResponse = await _productService.getFilterOptions(
        apiVersion: finalApiVersion,
      );
      _filterOptions = filterOptionsResponse;
      debugPrint('✅ REAL API Success! Filter options loaded');
      debugPrint('📊 Real API data contains:');
      debugPrint('   - Sort options: ${filterOptionsResponse.sortOptions.length}');
      debugPrint('   - Stock statuses: ${filterOptionsResponse.stockStatuses.length}');
      
      // Force state update
      final currentState = state;
      if (currentState is ProductListLoadedState) {
        emit(ProductListLoadedState(
          products: currentState.products,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          filterOptions: _filterOptions,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ REAL API Error: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      debugPrint('💡 This is expected if backend endpoint is not implemented yet');
      // Maybe API endpoint doesn't exist yet
    }
  }

  /// Create mock filter options (temporary until backend implements the endpoint)
  GetFilterOptionsResponseModel _createMockFilterOptions({
    List<FilterCategoryModel>? categories,
    List<FilterTagModel>? tags,
    List<FilterAttributeModel>? attributes,
  }) {
    return GetFilterOptionsResponseModel(
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
            OrderOptionModel(key: 'asc', label: 'A-Z'),
            OrderOptionModel(key: 'desc', label: 'Z-A'),
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
        StockStatusModel(key: 'instock', label: 'In stock'),
        StockStatusModel(key: 'outofstock', label: 'Out of stock'),
        StockStatusModel(key: 'onbackorder', label: 'On backorder'),
      ],
      priceRange: const PriceRangeModel(
        minPrice: 0.0,
        maxPrice: 9999.99,
        currency: 'USD',
        currencySymbol: '\$',
        currencyMinorUnit: 2,
      ),
      categories: categories ?? [
        const FilterCategoryModel(
          id: 1,
          name: 'Electronics',
          slug: 'electronics',
          count: 15,
        ),
        const FilterCategoryModel(
          id: 2,
          name: 'Clothing',
          slug: 'clothing',
          count: 23,
        ),
        const FilterCategoryModel(
          id: 3,
          name: 'Home & Garden',
          slug: 'home-garden',
          count: 8,
        ),
        const FilterCategoryModel(
          id: 4,
          name: 'Sports',
          slug: 'sports',
          count: 12,
        ),
        const FilterCategoryModel(
          id: 5,
          name: 'Books',
          slug: 'books',
          count: 5,
        ),
      ],
      tags: tags ?? [
        const FilterTagModel(
          id: 1,
          name: 'Sale',
          slug: 'sale',
          count: 20,
        ),
        const FilterTagModel(
          id: 2,
          name: 'New',
          slug: 'new',
          count: 15,
        ),
        const FilterTagModel(
          id: 3,
          name: 'Featured',
          slug: 'featured',
          count: 10,
        ),
        const FilterTagModel(
          id: 4,
          name: 'Best Seller',
          slug: 'best-seller',
          count: 8,
        ),
      ],
      availableAttributes: attributes ?? [
        FilterAttributeModel(
          id: 1,
          name: 'Color',
          slug: 'color',
          terms: const [
            FilterTermModel(id: 1, name: 'Red', slug: 'red', count: 5),
            FilterTermModel(id: 2, name: 'Blue', slug: 'blue', count: 7),
            FilterTermModel(id: 3, name: 'Green', slug: 'green', count: 4),
            FilterTermModel(id: 4, name: 'Black', slug: 'black', count: 12),
            FilterTermModel(id: 5, name: 'White', slug: 'white', count: 9),
          ],
        ),
        FilterAttributeModel(
          id: 2,
          name: 'Size',
          slug: 'size',
          terms: const [
            FilterTermModel(id: 6, name: 'Small', slug: 'small', count: 8),
            FilterTermModel(id: 7, name: 'Medium', slug: 'medium', count: 15),
            FilterTermModel(id: 8, name: 'Large', slug: 'large', count: 10),
            FilterTermModel(id: 9, name: 'X-Large', slug: 'x-large', count: 6),
          ],
        ),
        FilterAttributeModel(
          id: 3,
          name: 'Material',
          slug: 'material',
          terms: const [
            FilterTermModel(id: 10, name: 'Cotton', slug: 'cotton', count: 14),
            FilterTermModel(id: 11, name: 'Polyester', slug: 'polyester', count: 9),
            FilterTermModel(id: 12, name: 'Leather', slug: 'leather', count: 5),
            FilterTermModel(id: 13, name: 'Wool', slug: 'wool', count: 3),
          ],
        ),
      ],
    );
  }

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

      // Prepare price filters - use directly as they're already cleaned in applyFilters
      // Only clean if they're not already in the correct format (safety check)
      String? minPrice = _filters.minPrice != null && _filters.minPrice!.isNotEmpty
          ? _filters.minPrice
          : null;
      String? maxPrice = _filters.maxPrice != null && _filters.maxPrice!.isNotEmpty
          ? _filters.maxPrice
          : null;

      // Get category - use first from selectedCategories if available
      int? categoryId;
      if (_filters.selectedCategories != null && _filters.selectedCategories!.isNotEmpty) {
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
      String? attributeId;
      String? attributeTermId;
      if (_filters.selectedAttributes != null && _filters.selectedAttributes!.isNotEmpty) {
        final firstAttribute = _filters.selectedAttributes!.entries.first;
        attributeId = firstAttribute.key.toString();
        if (firstAttribute.value.isNotEmpty) {
          attributeTermId = firstAttribute.value.first.toString();
        }
      }

      debugPrint('🔍 ProductListViewModel: Loading products with filters:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Page: $_currentPage, Per Page: $_perPage');
      debugPrint('  - Min Price: $minPrice (raw: ${_filters.minPrice})');
      debugPrint('  - Max Price: $maxPrice (raw: ${_filters.maxPrice})');
      debugPrint('  - On Sale: ${_filters.onSale}');
      debugPrint('  - Stock Status: ${_filters.stockStatus}');
      debugPrint('  - Category: $categoryId (from selected: ${_filters.selectedCategories})');
      debugPrint('  - Tag: $tagId (from selected: ${_filters.selectedTags})');
      debugPrint('  - Attribute: $attributeId, Term: $attributeTermId (from selected: ${_filters.selectedAttributes})');
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
            debugPrint('    - regular_price: "${product.prices!.regularPrice}"');
            debugPrint('    - sale_price: "${product.prices!.salePrice}"');
            debugPrint('    - currency_code: "${product.prices!.currencyCode}"');
            debugPrint('    - currency_symbol: "${product.prices!.currencySymbol}"');
            debugPrint('    - currency_minor_unit: ${product.prices!.currencyMinorUnit}');
          }
        }
      }
      
      if (products.isNotEmpty) {
        debugPrint('✅ First product: ${products.first.name} (ID: ${products.first.id})');
        if (products.first.prices != null) {
          debugPrint('✅ First product price: ${products.first.prices!.price}');
          debugPrint('✅ First product regular price: ${products.first.prices!.regularPrice}');
          debugPrint('✅ First product sale price: ${products.first.prices!.salePrice}');
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

      debugPrint('📦 ProductListViewModel: Emitting loaded state with ${_allProducts.length} products');
      emit(
        ProductListLoadedState(
          products: _allProducts,
          hasMore: products.length >= _perPage,
          currentPage: _currentPage,
          totalPages: _totalPages,
          filterOptions: _filterOptions,
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
      debugPrint('🔧 initFilterDialog called - initializing...');
      
      // Always load filter options when dialog opens to ensure fresh data
      if (!_isLoadingFilterOptions) {
        debugPrint('🔧 Loading filter options...');
        loadFilterOptions();
      } else {
        debugPrint('⏳ Filter options already loading...');
      }
      
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
          filterOptions: _filterOptions,
        ));
      } else {
        emit(currentState);
      }
    } else {
      debugPrint('🚫 initFilterDialog already initialized, skipping...');
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
    List<int>? selectedCategories,
    List<int>? selectedTags,
    Map<int, List<int>>? selectedAttributes,
  }) {
    _tempFilters = _tempFilters.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      onSale: onSale,
      stockStatus: stockStatus,
      orderBy: orderBy,
      order: order,
      selectedCategories: selectedCategories,
      selectedTags: selectedTags,
      selectedAttributes: selectedAttributes,
    );
    // Emit current state to trigger rebuild in filter dialog
    final currentState = state;
    if (currentState is ProductListLoadedState) {
      emit(ProductListLoadedState(
        products: currentState.products,
        hasMore: currentState.hasMore,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        filterOptions: _filterOptions,
      ));
    } else {
      emit(currentState);
    }
  }

  /// Clean price string for API - removes currency symbols, thousand separators, keeps only numeric value
  /// Returns price as plain numeric string (e.g., "2" or "100.50")
  /// WooCommerce Store API expects price as string in the same currency format as products
  String? _cleanPriceForApi(String? priceString) {
    if (priceString == null || priceString.isEmpty) return null;
    
    // Remove all whitespace
    String cleaned = priceString.trim();
    if (cleaned.isEmpty) return null;
    
    // Try to parse directly as number first (handles "2", "100", "2.5", etc.)
    final directParse = double.tryParse(cleaned);
    if (directParse != null && directParse >= 0) {
      debugPrint('🔍 Price conversion (direct): "$priceString" -> "$cleaned" -> $directParse');
      // Return as string without unnecessary decimal places
      if (directParse == directParse.truncateToDouble()) {
        return directParse.toInt().toString();
      }
      return directParse.toString();
    }
    
    // Remove all non-numeric characters except decimal point and comma
    cleaned = cleaned.replaceAll(RegExp(r'[^\d.,]'), '');
    if (cleaned.isEmpty) return null;
    
    // Handle thousand separators (commas) vs decimal separators
    if (cleaned.contains(',') && cleaned.contains('.')) {
      // Both comma and dot present - comma is likely thousand separator
      cleaned = cleaned.replaceAll(',', '');
    } else if (cleaned.contains(',') && !cleaned.contains('.')) {
      // Only comma - check position to determine if decimal or thousand separator
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
    if (parsed == null || parsed < 0) {
      debugPrint('⚠️ Price conversion failed: "$priceString" -> "$cleaned" (invalid)');
      return null;
    }
    
    debugPrint('🔍 Price conversion: "$priceString" -> "$cleaned" -> $parsed');
    
    // Return the price as plain numeric string
    // Remove unnecessary decimal places (e.g., "2.0" -> "2", "100.50" -> "100.5" or "100.50")
    if (parsed == parsed.truncateToDouble()) {
      return parsed.toInt().toString();
    }
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
    debugPrint('  - Selected Categories: ${_tempFilters.selectedCategories}');
    debugPrint('  - Selected Tags: ${_tempFilters.selectedTags}');
    debugPrint('  - Selected Attributes: ${_tempFilters.selectedAttributes}');

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

