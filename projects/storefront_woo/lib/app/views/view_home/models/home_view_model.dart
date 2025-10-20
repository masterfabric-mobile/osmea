/*
 * HomeViewModel
 * -------------
 * ViewModel for the home view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Based on admin_dashboard pattern for consistency.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart' as FlutterMaterial show Image;
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/apis.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/services/cart_service.dart';
import 'package:storefront_woo/app/views/view_product_detail/product_detail_view.dart';
import 'package:get_it/get_it.dart';

@injectable
class HomeViewModel extends BaseViewModelHydratedCubit<HomeState> {
  HomeViewModel() : super(HomeInitialState());

  // Dependencies
  final ProductService _productService = GetIt.I<ProductService>();
  final CartService _cartService = CartService();

  // State variables
  List<ListAllProductsResponseModel> _products = [];
  List<ListAllProductsResponseModel> _allProducts = [];
  bool _hasMore = true;
  int _currentPage = 1;
  String? _searchQuery;
  int? _selectedCategoryId;
  final int _productsPerPage = 20;

  // TextEditingController for search
  final TextEditingController searchController = TextEditingController();

  // Public trigger functions - HydratedCubit pattern
  void initial() {
    loadProducts();
  }

  // Public trigger functions - HydratedCubit pattern
  void loadProducts() => _loadProducts();
  void loadMoreProducts() => _loadMoreProducts();
  void refreshProducts() => _refreshProducts();
  void searchProducts(String query) => _searchProducts(query);
  void clearSearch() => _clearSearch();
  void restart() => _restart();
  void filterByCategory(int? categoryId) => _filterByCategory(categoryId);
  void addProductToCart(int productId) => _addToCart(productId);
  void addProductToWishlist(int productId) => _addToWishlist(productId);
  void selectProduct(ListAllProductsResponseModel product) =>
      _selectProduct(product);

  // Private methods - HydratedCubit pattern
  void _restart() {
    searchController.clear();
    _searchQuery = null;
    _selectedCategoryId = null;
    _currentPage = 1;
    _products = [];
    _allProducts = [];
    _hasMore = true;
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      emit(HomeLoadingState());

      _currentPage = 1;
      _products = [];
      _hasMore = true;
      _searchQuery = null;
      _selectedCategoryId = null;

      debugPrint('🛍️ Making API call to WooCommerce Store API...');
      debugPrint('🛍️ Store URL: ${WooNetwork.storeUrl}');
      debugPrint('🛍️ API Version: v1');
      debugPrint('🛍️ Page: $_currentPage, Per Page: $_productsPerPage');

      final products = await _productService.listAllProducts(
        apiVersion: 'v1',
        page: _currentPage,
        perPage: _productsPerPage,
        status: 'publish',
        stockStatus: 'instock',
      );

      debugPrint('🛍️ API Response received: ${products.length} products');
      if (products.isNotEmpty) {
        debugPrint('🛍️ First product: ${products.first.name}');
        debugPrint('🛍️ First product ID: ${products.first.id}');
        debugPrint(
          '🛍️ First product prices: ${products.first.prices?.toJson()}',
        );
        debugPrint(
          '🛍️ First product images: ${products.first.images?.length} images',
        );
        if (products.first.images?.isNotEmpty == true) {
          debugPrint(
            '🛍️ First image URL: ${products.first.images!.first.src}',
          );
        }
      } else {
        debugPrint('⚠️ No products returned from API');
      }

      _products = products;
      _allProducts = List.from(
        products,
      ); // Store all products for local filtering
      _hasMore = products.length == _productsPerPage;

      emit(
        HomeLoadedState(
          products: _products,
          hasMore: _hasMore,
          currentPage: _currentPage,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading products: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      emit(HomeErrorState(message: 'Failed to load products: $e'));
    }
  }

  Future<void> _loadMoreProducts() async {
    if (!_hasMore) return;

    try {
      _currentPage++;
      final products = await _productService.listAllProducts(
        apiVersion: 'v1',
        page: _currentPage,
        perPage: _productsPerPage,
        status: 'publish',
        stockStatus: 'instock',
      );

      _products.addAll(products);
      _allProducts.addAll(products); // Add to all products cache
      _hasMore = products.length == _productsPerPage;

      emit(
        HomeLoadedState(
          products: _products,
          hasMore: _hasMore,
          currentPage: _currentPage,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    } catch (e) {
      emit(HomeErrorState(message: 'Failed to load more products: $e'));
    }
  }

  void _searchProducts(String query) {
    try {
      _searchQuery = query;

      // Update controller text
      if (searchController.text != query) {
        searchController.text = query;
      }

      if (query.isEmpty) {
        // If search is empty, show all products
        _products = List.from(_allProducts);
      } else {
        // Filter products locally
        _products = _allProducts.where((product) {
          final productName = product.name?.toLowerCase() ?? '';
          final productDescription = product.description?.toLowerCase() ?? '';
          final searchTerm = query.toLowerCase();

          return productName.contains(searchTerm) ||
              productDescription.contains(searchTerm);
        }).toList();
      }

      emit(
        HomeLoadedState(
          products: _products,
          hasMore: false, // Local filtering doesn't support pagination
          currentPage: 1,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    } catch (e) {
      emit(HomeErrorState(message: 'Failed to search products: $e'));
    }
  }

  void _clearSearch() {
    try {
      searchController.clear();
      _searchQuery = null;
      _products = List.from(_allProducts);

      emit(
        HomeLoadedState(
          products: _products,
          hasMore: _allProducts.length == _productsPerPage,
          currentPage: 1,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    } catch (e) {
      emit(HomeErrorState(message: 'Failed to clear search: $e'));
    }
  }

  void _filterByCategory(int? categoryId) {
    try {
      _selectedCategoryId = categoryId;

      if (categoryId == null) {
        // Show all products
        _products = List.from(_allProducts);
      } else {
        // Filter by category
        _products = _allProducts.where((product) {
          return product.categories?.any(
                (category) => category.id == categoryId,
              ) ??
              false;
        }).toList();
      }

      emit(
        HomeLoadedState(
          products: _products,
          hasMore: false, // Category filtering doesn't support pagination
          currentPage: 1,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    } catch (e) {
      emit(HomeErrorState(message: 'Failed to filter by category: $e'));
    }
  }

  Future<void> _addToCart(int productId) async {
    try {
      // Find the product to add to cart
      final product = _allProducts.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception('Product not found'),
      );

      // Create cart item
      final cartItem = CartItem(
        productId: product.id ?? 0,
        productName: product.name ?? 'Unknown Product',
        price: _parsePrice(product.prices),
        quantity: 1,
        imageUrl: product.images?.isNotEmpty == true
            ? product.images!.first.src
            : null,
      );

      // Add to cart service
      _cartService.addItem(cartItem);

      debugPrint('✅ Added product ${product.name} to cart');

      // Show success state
      emit(
        HomeLoadedState(
          products: _products,
          hasMore: _hasMore,
          currentPage: _currentPage,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    } catch (e) {
      debugPrint('❌ Failed to add to cart: $e');
      emit(HomeErrorState(message: 'Failed to add to cart: $e'));
    }
  }

  Future<void> _refreshProducts() async {
    try {
      emit(HomeLoadingState());
      _currentPage = 1;
      await _loadProducts();
    } catch (e) {
      emit(HomeErrorState(message: 'Failed to refresh products: $e'));
    }
  }

  Future<void> _addToWishlist(int productId) async {
    try {
      // TODO: Implement add to wishlist logic
      debugPrint('Adding product $productId to wishlist');

      // For now, just show success state
      emit(
        HomeLoadedState(
          products: _products,
          hasMore: _hasMore,
          currentPage: _currentPage,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    } catch (e) {
      debugPrint('❌ Failed to add to wishlist: $e');
      emit(HomeErrorState(message: 'Failed to add to wishlist: $e'));
    }
  }

  void _selectProduct(ListAllProductsResponseModel product) {
    try {
      debugPrint('Selecting product: ${product.name}');

      // Update state with selected product
      emit(
        HomeLoadedState(
          products: _products,
          hasMore: _hasMore,
          currentPage: _currentPage,
          searchQuery: _searchQuery,
          selectedCategoryId: _selectedCategoryId,
          selectedProduct: product, // Store selected product in state
        ),
      );
    } catch (e) {
      debugPrint('❌ Failed to select product: $e');
      emit(HomeErrorState(message: 'Failed to select product: $e'));
    }
  }

  /// Builds content based on current state
  Widget buildContent(BuildContext context, HomeState state) {
    // Error state
    if (state is HomeErrorState) {
      return _buildErrorState(context, state);
    }

    // Loading state
    if (state is HomeLoadingState) {
      return _buildLoadingState(context);
    }

    // Loaded state
    if (state is HomeLoadedState) {
      return _buildLoadedState(context, state);
    }

    // Initial state
    return _buildLoadingState(context);
  }

  /// Builds error state with retry functionality
  Widget _buildErrorState(BuildContext context, HomeErrorState state) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: OsmeaColors.red),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            state.message,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            color: OsmeaColors.thunder,
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(
            onPressed: () => loadProducts(),
            backgroundColor: OsmeaColors.nordicBlue,
            textColor: OsmeaColors.paperWhite,
            text: 'Retry',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(color: OsmeaColors.paperWhite),
          ),
        ],
      ),
    );
  }

  /// Builds loading state
  Widget _buildLoadingState(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        color: OsmeaColors.nordicBlue,
        size: 40,
      ),
    );
  }

  /// Builds loaded state with products - SIMPLE PRODUCT FOCUSED
  Widget _buildLoadedState(BuildContext context, HomeLoadedState state) {
    return OsmeaComponents.column(
      children: [
        // Simple search bar
        _buildSearchBar(context),
        // Products grid - Direct focus
        OsmeaComponents.expanded(child: _buildProductsGrid(context, state)),
      ],
    );
  }

  /// Builds search bar using OSMEA searchbar component - OPTIMIZED SPACING
  Widget _buildSearchBar(BuildContext context) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
      child: OsmeaComponents.searchbar(
        hint: 'Search products...',
        searchbarVariant: SearchbarVariant.outlined,
        searchbarStyle: SearchbarStyle.standard,
        backgroundColor: OsmeaColors.white,
        borderColor: OsmeaColors.silver,
        focusColor: OsmeaColors.nordicBlue,
        hintColor: OsmeaColors.pewter,
        textColor: OsmeaColors.thunder,
        size: TextFieldSize.medium,
        showClearButton: true,
        showSearchIcon: true,
        debounceDuration: const Duration(milliseconds: 300),
        onSearch: (query) {
          searchProducts(query);
        },
        onClear: () {
          clearSearch();
        },
      ),
    );
  }

  /// Builds products grid following OSMEA standards
  Widget _buildProductsGrid(BuildContext context, HomeLoadedState state) {
    if (state.products.isEmpty) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: OsmeaColors.pewter),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              'No products found',
              textStyle: OsmeaTextStyle.titleMedium(context),
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'Try adjusting your search or filters',
              textStyle: OsmeaTextStyle.bodyMedium(context),
              color: OsmeaColors.pewter,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => refreshProducts(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjusted for larger images
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  /// Builds ultra-minimalist product card
  Widget _buildProductCard(BuildContext context, dynamic product) {
    return GestureDetector(
      onTap: () => _navigateToProductDetail(context, product.id ?? 0),
      child: Container(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section - Ultra minimal
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: OsmeaColors.pewter.withOpacity(0.03),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: product.images?.isNotEmpty == true
                        ? FlutterMaterial.Image.network(
                            product.images!.first.src ?? '',
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 140,
                                color: OsmeaColors.pewter.withOpacity(0.05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      color: OsmeaColors.pewter.withOpacity(
                                        0.3,
                                      ),
                                      size: 28,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'No Image',
                                      style: OsmeaTextStyle.bodySmall(context)
                                          .copyWith(
                                            color: OsmeaColors.pewter
                                                .withOpacity(0.5),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            height: 140,
                            color: OsmeaColors.pewter.withOpacity(0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: OsmeaColors.pewter.withOpacity(0.3),
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'No Image',
                                  style: OsmeaTextStyle.bodySmall(context)
                                      .copyWith(
                                        color: OsmeaColors.pewter.withOpacity(
                                          0.5,
                                        ),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),
                  ),

                  // Discount Badge - Ultra minimal
                  if (product.onSale == true)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: OsmeaColors.nordicBlue,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '60% OFF',
                          style: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Like button - Ultra minimal
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => addProductToWishlist(product.id ?? 0),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: OsmeaColors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: OsmeaColors.pewter.withOpacity(0.6),
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section - Ultra minimal padding
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name - Ultra minimal typography
                  Text(
                    product.name ?? 'Unknown Product',
                    style: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Price Section - Ultra minimal
                  _buildUltraMinimalPriceSection(context, product),

                  const SizedBox(height: 8),

                  // Minimalist Cart Icon Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => addProductToCart(product.id ?? 0),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: OsmeaColors.nordicBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: OsmeaColors.nordicBlue,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds ultra-minimal price section
  Widget _buildUltraMinimalPriceSection(BuildContext context, dynamic product) {
    final prices = product.prices;
    if (prices == null) {
      return Text(
        'Price not available',
        style: OsmeaTextStyle.bodySmall(
          context,
        ).copyWith(color: OsmeaColors.pewter.withOpacity(0.5), fontSize: 10),
      );
    }

    final regularPrice = prices.regularPrice;
    final salePrice = prices.salePrice;
    final currency = prices.currencySymbol ?? '£';

    // If there's a sale price, show both
    if (salePrice != null &&
        salePrice.isNotEmpty &&
        salePrice != regularPrice) {
      return Row(
        children: [
          // Sale Price - Blue color
          Text(
            '$currency${_formatPriceString(salePrice)}',
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              fontWeight: FontWeight.w600,
              color: OsmeaColors.nordicBlue,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 4),
          // Regular Price - Crossed out, gray
          Text(
            '$currency${_formatPriceString(regularPrice)}',
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              decoration: TextDecoration.lineThrough,
              color: OsmeaColors.pewter.withOpacity(0.5),
              fontSize: 9,
            ),
          ),
        ],
      );
    } else {
      // Only regular price
      return Text(
        '$currency${_formatPriceString(regularPrice)}',
        style: OsmeaTextStyle.bodySmall(context).copyWith(
          fontWeight: FontWeight.w500,
          color: OsmeaColors.thunder,
          fontSize: 11,
        ),
      );
    }
  }

  void _navigateToProductDetail(BuildContext context, int productId) {
    // First select the product in the view model to store it
    final product = (state as HomeLoadedState).products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );
    selectProduct(product);

    // Then navigate to product detail view
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailView(
          productId: productId,
          arguments: const {'productDetail': true},
          goRoute: (path) {
            if (path.contains('home')) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  // Dispose method
  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return null; // State will be reconstructed from API
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return null; // No need to persist home state
  }

  /// Parses price string to double for cart calculations
  double _parsePrice(Prices? prices) {
    if (prices == null) {
      debugPrint('❌ _parsePrice: Prices is null');
      return 0.0;
    }

    // Prefer sale price if available, otherwise regular price, then main price
    String? priceString;
    if (prices.salePrice != null &&
        prices.salePrice!.isNotEmpty &&
        prices.salePrice != '0') {
      priceString = prices.salePrice;
      debugPrint('💰 _parsePrice: Using sale price: $priceString');
    } else if (prices.regularPrice != null &&
        prices.regularPrice!.isNotEmpty &&
        prices.regularPrice != '0') {
      priceString = prices.regularPrice;
      debugPrint('💰 _parsePrice: Using regular price: $priceString');
    } else if (prices.price != null &&
        prices.price!.isNotEmpty &&
        prices.price != '0') {
      priceString = prices.price;
      debugPrint('💰 _parsePrice: Using main price: $priceString');
    } else {
      priceString = '0.00';
      debugPrint('💰 _parsePrice: No valid price, using default: $priceString');
    }

    // Use PriceInfoCurrencyHelper for parsing
    final parsedPrice =
        PriceInfoCurrencyHelper.parsePriceToDouble(priceString!) ?? 0.0;
    debugPrint('💰 _parsePrice: Parsed price: $parsedPrice');
    return parsedPrice;
  }

  /// Parses price string to formatted string for display - NO .00, COMMA SEPARATOR
  String _formatPriceString(String? priceString) {
    if (priceString == null || priceString.isEmpty) {
      return '0';
    }

    // Clean the price string
    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    final parsedPrice = double.tryParse(cleanPrice) ?? 0.0;

    // Format with comma separator and NO .00
    if (parsedPrice == parsedPrice.truncate()) {
      // Integer price - no decimals
      return parsedPrice.truncate().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    } else {
      // Decimal price - show decimals but format nicely
      return parsedPrice
          .toStringAsFixed(2)
          .replaceAll('.', ',')
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
  }
}
