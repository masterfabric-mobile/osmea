/*
 * HomeViewModel
 * -------------
 * ViewModel for the home view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Based on admin_dashboard pattern for consistency.
 */

import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/apis.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';

@injectable
class HomeViewModel extends BaseViewModelHydratedCubit<HomeState> {
  HomeViewModel() : super(HomeInitialState());

  // Dependencies
  final ProductService _productService = GetIt.I<ProductService>();
  final CartService _cartService = GetIt.I<CartService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

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

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Public trigger functions - HydratedCubit pattern
  void initial() {
    loadProducts();
  }

  // Public trigger functions - Business logic handled directly
  Future<void> loadProducts() async {
    try {
      emit(HomeLoadingState());

      _currentPage = 1;
      _products = [];
      _hasMore = true;
      _searchQuery = null;
      _selectedCategoryId = null;

      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      debugPrint('🛍️ Making API call to WooCommerce Store API...');
      debugPrint('🛍️ Store URL: ${WooNetwork.storeUrl}');
      debugPrint('🛍️ API Version: $apiVersion');
      debugPrint('🛍️ Page: $_currentPage, Per Page: $_productsPerPage');

      final products = await _productService.listAllProducts(
        apiVersion: apiVersion,
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

  Future<void> loadMoreProducts() async {
    if (!_hasMore) return;

    try {
      _currentPage++;
      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );
      final products = await _productService.listAllProducts(
        apiVersion: apiVersion,
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

  Future<void> refreshProducts() async {
    try {
      emit(HomeLoadingState());
      _currentPage = 1;
      await loadProducts();
    } catch (e) {
      emit(HomeErrorState(message: 'Failed to refresh products: $e'));
    }
  }

  void searchProducts(String query) {
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

  void clearSearch() {
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

  void restart() {
    searchController.clear();
    _searchQuery = null;
    _selectedCategoryId = null;
    _currentPage = 1;
    _products = [];
    _allProducts = [];
    _hasMore = true;
    loadProducts();
  }

  void filterByCategory(int? categoryId) {
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

  Future<void> addProductToCart(int productId) async {
    try {
      debugPrint('🛒 HomeViewModel: Adding product $productId to cart via API');

      // Add item to cart via API
      final response = await _cartService.addItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: await _getCartToken() ?? '',
        jwtToken: await _getJwtToken(), // Optional JWT token
        id: productId,
        quantity: 1,
      );

      debugPrint(
        '🛒 HomeViewModel: AddItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API add item error: ${response.errors!.first}');
        emit(
          HomeErrorState(
            message: 'Failed to add item: ${response.errors!.first}',
          ),
        );
        return;
      }

      // Cart token is automatically handled by WooCartTokenInterceptor
      // No need to manually save token - interceptor extracts from response headers

      debugPrint('✅ Successfully added product $productId to cart via API');

      // Just emit loaded state - UI will handle popup
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

  Future<void> addProductToWishlist(int productId) async {
    try {
      debugPrint('💖 HomeViewModel: Toggling wishlist for product $productId');
      
      final product = _allProducts.firstWhere(
        (p) => (p.id ?? 0) == productId,
        orElse: () => ListAllProductsResponseModel(),
      );

      final wishlistVm = GetIt.I<WishlistViewModel>();
      final item = WishlistItem(
        id: productId,
        name: product.name,
        imageUrl: (product.images?.isNotEmpty ?? false)
            ? product.images!.first.src
            : null,
        regularPrice: product.prices?.regularPrice,
        salePrice: product.prices?.salePrice,
        currencyCode: product.prices?.currencyCode,
        onSale: product.onSale == true,
      );
      
      // Toggle wishlist - this will update WishlistViewModel state
      await wishlistVm.toggle(item);
      
      debugPrint('✅ HomeViewModel: Wishlist toggle completed for product $productId');
      debugPrint('💖 HomeViewModel: Product is now saved: ${wishlistVm.isSaved(productId)}');

      // Emit current state to trigger UI rebuild
      // The BlocBuilder in the UI will automatically update based on WishlistViewModel state
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
      debugPrint('❌ Failed to toggle wishlist: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      // Don't emit error state - just log it
      // The UI will show error via snackbar if needed
    }
  }

  // Expose saved status for widgets without BlocBuilder
  bool isProductSaved(int productId) {
    try {
      final wishlistVm = GetIt.I<WishlistViewModel>();
      return wishlistVm.isSaved(productId);
    } catch (_) {
      return false;
    }
  }

  void selectProduct(ListAllProductsResponseModel product) {
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

  // Helper methods - Private utilities

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

  /// Gets cart token from arguments (route params) or storage
  /// Priority: arguments > storage
  /// Interceptor automatically adds token to request headers,
  /// but ViewModel needs token for direct API calls
  Future<String?> _getCartToken() async {
    try {
      // First try to get from arguments (route params)
      final argsToken = _arguments['cartToken'] as String?;
      if (argsToken != null && argsToken.isNotEmpty) {
        debugPrint('🛒 HomeViewModel: Cart token from arguments');
        return argsToken;
      }

      // Fallback to storage
      final wooCartToken = await WooCartTokenStorage.loadCartToken();

      if (wooCartToken != null && wooCartToken.cartToken.isNotEmpty) {
        // Check if token has expired
        if (wooCartToken.expiresAt != null &&
            DateTime.now().isAfter(wooCartToken.expiresAt!)) {
          debugPrint('⚠️ Cart token has expired');
          await WooCartTokenStorage.clearCartToken();
          return null;
        }

        debugPrint(
          '🛒 HomeViewModel: Cart token from storage: ${wooCartToken.cartToken.length > 20 ? wooCartToken.cartToken.substring(0, 20) + "..." : wooCartToken.cartToken}',
        );
        return wooCartToken.cartToken;
      }

      debugPrint('⚠️ HomeViewModel: No cart token found');
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get cart token: $e');
      return null;
    }
  }

  /// Gets JWT token from storage
  Future<String?> _getJwtToken() async {
    try {
      final authStorage = AuthStorageHelper();
      return await authStorage.getToken();
    } catch (e) {
      debugPrint('❌ Failed to get JWT token: $e');
      return null;
    }
  }
}
