/*
 * ProductDetailViewModel
 * ----------------------
 * ViewModel for the product detail view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Based on admin_dashboard pattern for consistency.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/get_cart_response.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:get_it/get_it.dart';

@injectable
class ProductDetailViewModel
    extends BaseViewModelHydratedCubit<ProductDetailState> {
  ProductDetailViewModel() : super(ProductDetailInitialState());

  // Dependencies
  final ProductService _productService = GetIt.I<ProductService>();
  final CartService _cartService = GetIt.I<CartService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // State variables
  int _selectedQuantity = 1;
  List<String> _imageUrls = [];
  final int _currentImageIndex = 0;

  // ============================================================================
  // Public API Methods - Structured Pattern: Future first, then Fire (void)
  // ============================================================================

  // ----------------------------------------------------------------------------
  // Product Loading
  // ----------------------------------------------------------------------------

  /// Loads product details from API or cache
  /// Fetches product data, images, and checks cart/wishlist status
  /// Returns Future to allow await in calling code
  Future<void> loadProduct(int productId) async =>
      await _loadProduct(productId);

  /// Convenience: fire-and-forget product load (void)
  /// Calls the Future-based loadProduct under the hood
  void loadProductFire(int productId) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    loadProduct(productId);
  }

  // ----------------------------------------------------------------------------
  // Cart Operations
  // ----------------------------------------------------------------------------

  /// Adds product to cart with specified quantity
  /// Returns Future to allow await in calling code
  Future<void> addProductToCart(int productId, {int quantity = 1}) async =>
      await _addToCart(productId, quantity);

  /// Convenience: fire-and-forget add to cart (void)
  /// Calls the Future-based addProductToCart under the hood
  void addProductToCartFire(int productId, {int quantity = 1}) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    addProductToCart(productId, quantity: quantity);
  }

  // ----------------------------------------------------------------------------
  // Wishlist Operations
  // ----------------------------------------------------------------------------

  /// Adds or removes product from wishlist
  /// Returns Future to allow await in calling code
  Future<void> addProductToWishlist(int productId) async =>
      await _addToWishlist(productId);

  /// Convenience: fire-and-forget wishlist toggle (void)
  /// Calls the Future-based addProductToWishlist under the hood
  void addProductToWishlistFire(int productId) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    addProductToWishlist(productId);
  }

  // ----------------------------------------------------------------------------
  // Quantity Management
  // ----------------------------------------------------------------------------

  /// Updates the selected quantity for the product
  /// Returns Future to allow await in calling code (wrapped sync operation)
  Future<void> updateQuantity(int quantity) async =>
      await Future.microtask(() => _changeQuantity(quantity));

  /// Convenience: fire-and-forget quantity update (void)
  /// Calls the Future-based updateQuantity under the hood
  void updateQuantityFire(int quantity) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    updateQuantity(quantity);
  }

  // ----------------------------------------------------------------------------
  // Image Management
  // ----------------------------------------------------------------------------

  /// Loads and sets product image URLs
  /// Returns Future to allow await in calling code (wrapped sync operation)
  Future<void> loadProductImages(List<String> imageUrls) async =>
      await Future.microtask(() => _loadImages(imageUrls));

  /// Convenience: fire-and-forget image load (void)
  /// Calls the Future-based loadProductImages under the hood
  void loadProductImagesFire(List<String> imageUrls) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    loadProductImages(imageUrls);
  }

  // ----------------------------------------------------------------------------
  // Description Expand/Collapse Management
  // ----------------------------------------------------------------------------

  /// Sets description expanded state
  Future<void> setDescriptionExpanded(bool isExpanded) async =>
      Future.microtask(() {
        final currentState = state;
        if (currentState is ProductDetailLoadedState) {
          emit(currentState.copyWith(isDescriptionExpanded: isExpanded));
        }
      });

  /// Fire-and-forget version
  void setDescriptionExpandedFire(bool isExpanded) {
    // ignore: discarded_futures
    setDescriptionExpanded(isExpanded);
  }

  /// Toggles description expanded state
  Future<void> toggleDescriptionExpanded() async => Future.microtask(() {
    final currentState = state;
    if (currentState is ProductDetailLoadedState) {
      emit(
        currentState.copyWith(
          isDescriptionExpanded: !currentState.isDescriptionExpanded,
        ),
      );
    }
  });

  /// Fire-and-forget version
  void toggleDescriptionExpandedFire() {
    // ignore: discarded_futures
    toggleDescriptionExpanded();
  }

  // ----------------------------------------------------------------------------
  // Attribute Selection (e.g., Color, Size)
  // ----------------------------------------------------------------------------

  /// Sets a selected attribute value, e.g. setSelectedAttribute('Color','Red')
  Future<void> setSelectedAttribute(String name, String value) async =>
      Future.microtask(() {
        final currentState = state;
        if (currentState is ProductDetailLoadedState) {
          final updated = Map<String, String>.from(
            currentState.selectedAttributes,
          )..[name] = value;
          emit(currentState.copyWith(selectedAttributes: updated));
        }
      });

  /// Clears a selected attribute
  Future<void> clearSelectedAttribute(String name) async =>
      Future.microtask(() {
        final currentState = state;
        if (currentState is ProductDetailLoadedState) {
          final updated = Map<String, String>.from(
            currentState.selectedAttributes,
          )..remove(name);
          emit(currentState.copyWith(selectedAttributes: updated));
        }
      });

  // Private methods - HydratedCubit pattern
  Future<void> _loadProduct(int productId) async {
    try {
      emit(ProductDetailLoadingState());

      // First try to get selected product from HomeViewModel if available
      // This provides faster loading with cached data
      final homeViewModel = GetIt.I<HomeViewModel>();
      final homeState = homeViewModel.state;

      if (homeState is HomeLoadedState &&
          homeState.selectedProduct != null &&
          homeState.selectedProduct!.id == productId) {
        // Use cached product data for faster loading
        final cachedProduct = homeState.selectedProduct!;
        debugPrint(
          '✅ Using cached product data for faster loading: ${cachedProduct.name}',
        );

        // Convert ListAllProductsResponseModel to RetrieveProductResponseModel
        // For now, we'll just show loading and fetch fresh data
        debugPrint('🔄 Converting cached data and fetching fresh details');
      }

      // Always fetch fresh data from API for complete details
      debugPrint('🔄 Fetching fresh product details from API');
      final product = await _productService.retrieveProduct(
        apiVersion: 'v1',
        productId: productId,
      );

      // Extract image URLs safely
      final imageUrls = <String>[];
      if (product.images != null) {
        for (final img in product.images!) {
          if (img.src != null && img.src!.isNotEmpty) {
            imageUrls.add(img.src!);
          }
        }
      }
      debugPrint(
        '📸 Extracted ${imageUrls.length} image URLs for product: ${product.name}',
      );

      // Check if product is in cart or wishlist
      bool isInCart = false;
      int cartQuantity = 1;

      // Check cart via API
      try {
        final cartResponse = await _cartService.getCart(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
          jwtToken: await _getJwtToken(),
        );

        // Find product in cart items
        if (cartResponse.items != null && cartResponse.items!.isNotEmpty) {
          final cartItem = cartResponse.items!.firstWhere(
            (item) => item.id == productId,
            orElse: () => GetCartResponseItem(id: null),
          );

          if (cartItem.id != null) {
            isInCart = true;
            cartQuantity = cartItem.quantity ?? 1;
            _selectedQuantity =
                cartQuantity; // Set selected quantity to cart quantity
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to check cart: $e');
        // Continue without cart check - not fatal
      }

      final isInWishlist = false; // TODO: Implement wishlist service

      emit(
        ProductDetailLoadedState(
          product: product,
          selectedQuantity: _selectedQuantity,
          imageUrls: imageUrls,
          currentImageIndex: _currentImageIndex,
          isInCart: isInCart,
          isInWishlist: isInWishlist,
          isDescriptionExpanded: false,
        ),
      );
    } catch (e) {
      emit(ProductDetailErrorState(message: 'Failed to load product: $e'));
    }
  }

  Future<void> _addToCart(int productId, int quantity) async {
    try {
      debugPrint(
        '🛒 ProductDetailViewModel: Adding product $productId to cart via API',
      );

      // Ensure we have a cart token; if missing, initialize cart first
      String? cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('🛒 No cart token found. Initializing cart via getCart...');
        await _cartService.getCart(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
          jwtToken: await _getJwtToken(),
        );
        cartToken = await _getCartToken();
        debugPrint(
          '🛒 Cart token after init: ${cartToken != null && cartToken.isNotEmpty}',
        );
      }

      // Add item to cart via API (first attempt)
      var response = await _cartService.addItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken ?? '',
        jwtToken: await _getJwtToken(), // Optional JWT token
        id: productId,
        quantity: quantity,
      );

      debugPrint(
        '🛒 ProductDetailViewModel: AddItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API add item error: ${response.errors!.first}');
        // If unauthorized or token-related, try to refresh cart and retry once
        final errorText = response.errors!.first.toString().toLowerCase();
        if (errorText.contains('401') ||
            errorText.contains('unauthorized') ||
            errorText.contains('token')) {
          debugPrint('🛒 Retrying addItem after refreshing cart token...');
          await _cartService.getCart(
            apiVersion: _configHelper.getString(
              'woocommerce_configuration.version',
            ),
            jwtToken: await _getJwtToken(),
          );
          final refreshedToken = await _getCartToken();
          response = await _cartService.addItem(
            apiVersion: _configHelper.getString(
              'woocommerce_configuration.version',
            ),
            cartToken: refreshedToken ?? '',
            jwtToken: await _getJwtToken(),
            id: productId,
            quantity: quantity,
          );

          if (response.errors != null && response.errors!.isNotEmpty) {
            emit(
              ProductDetailErrorState(
                message: 'Failed to add item: ${response.errors!.first}',
              ),
            );
            return;
          }
        } else {
          emit(
            ProductDetailErrorState(
              message: 'Failed to add item: ${response.errors!.first}',
            ),
          );
          return;
        }
      }

      // Cart token is automatically handled by WooCartTokenInterceptor
      // No need to manually save token - interceptor extracts from response headers

      debugPrint('✅ Successfully added product $productId to cart via API');

      // Check actual cart quantity after add (API may have merged quantities if item already exists)
      int finalQuantity = quantity;
      try {
        final cartResponse = await _cartService.getCart(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
          jwtToken: await _getJwtToken(),
        );

        // Find actual quantity in cart after add
        if (cartResponse.items != null && cartResponse.items!.isNotEmpty) {
          final cartItem = cartResponse.items!.firstWhere(
            (item) => item.id == productId,
            orElse: () => GetCartResponseItem(id: null),
          );

          if (cartItem.id != null) {
            finalQuantity = cartItem.quantity ?? quantity;
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to check final cart quantity: $e');
        // Use original quantity if check fails
      }

      // Update state to show product is in cart and update quantity
      final currentState = state;
      if (currentState is ProductDetailLoadedState) {
        emit(
          currentState.copyWith(
            isInCart: true,
            selectedQuantity: finalQuantity, // Update to actual cart quantity
          ),
        );
        _selectedQuantity = finalQuantity;
      }
    } catch (e) {
      debugPrint('❌ Failed to add to cart: $e');
      emit(ProductDetailErrorState(message: 'Failed to add to cart: $e'));
    }
  }

  Future<void> _addToWishlist(int productId) async {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      // TODO: Implement wishlist service
      debugPrint('✅ Added product $productId to wishlist');

      // Update state
      emit(currentState.copyWith(isInWishlist: true));

      // Show success message
      emit(
        ProductDetailSuccessState(
          message: 'Product added to wishlist successfully!',
          previousState: currentState.copyWith(isInWishlist: true),
        ),
      );
    } catch (e) {
      debugPrint('❌ Failed to add to wishlist: $e');
      emit(ProductDetailErrorState(message: 'Failed to add to wishlist: $e'));
    }
  }

  void _changeQuantity(int quantity) {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      _selectedQuantity = quantity;
      emit(currentState.copyWith(selectedQuantity: _selectedQuantity));

      // If product is in cart, update quantity via API immediately
      // This ensures cart quantity is synced with counter in real-time
      if (currentState.isInCart) {
        _updateCartQuantity(currentState.product.id ?? 0, quantity);
      }
      // If not in cart, just update local quantity (will be used when Add to Cart is clicked)
    } catch (e) {
      debugPrint('❌ Failed to change quantity: $e');
      emit(ProductDetailErrorState(message: 'Failed to change quantity: $e'));
    }
  }

  /// Updates cart item quantity via API
  Future<void> _updateCartQuantity(int productId, int quantity) async {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      // Get cart token and JWT token
      String? cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('⚠️ No cart token available for quantity update');
        return;
      }

      // Get cart to find item key
      final cartResponse = await _cartService.getCart(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        jwtToken: await _getJwtToken(),
      );

      // Find item key for this product
      String? itemKey;
      if (cartResponse.items != null) {
        final cartItem = cartResponse.items!.firstWhere(
          (item) => item.id == productId,
          orElse: () => GetCartResponseItem(id: null),
        );
        if (cartItem.id != null) {
          itemKey = cartItem.key;
        }
      }

      if (itemKey == null) {
        debugPrint('⚠️ Item key not found for product $productId');
        return;
      }

      // Update item quantity via API
      final response = await _cartService.updateItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: await _getJwtToken(),
        key: itemKey,
        quantity: quantity,
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API update item error: ${response.errors!.first}');
        return;
      }

      debugPrint('✅ Successfully updated cart quantity to $quantity');
    } catch (e) {
      debugPrint('❌ Failed to update cart quantity: $e');
      // Don't emit error state - just log it
    }
  }

  void _loadImages(List<String> imageUrls) {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      _imageUrls = imageUrls;
      emit(currentState.copyWith(imageUrls: _imageUrls));
    } catch (e) {
      debugPrint('❌ Failed to load images: $e');
      emit(ProductDetailErrorState(message: 'Failed to load images: $e'));
    }
  }

  @override
  ProductDetailState? fromJson(Map<String, dynamic> json) {
    return null; // State will be reconstructed from API
  }

  @override
  Map<String, dynamic>? toJson(ProductDetailState state) {
    return null; // No need to persist product detail state
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
        debugPrint('🛒 ProductDetailViewModel: Cart token from arguments');
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
          '🛒 ProductDetailViewModel: Cart token from storage: ${wooCartToken.cartToken.length > 20 ? "${wooCartToken.cartToken.substring(0, 20)}..." : wooCartToken.cartToken}',
        );
        return wooCartToken.cartToken;
      }

      debugPrint('⚠️ ProductDetailViewModel: No cart token found');
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get cart token: $e');
      return null;
    }
  }

  /// Gets cart token for navigation - public method
  /// Returns token from arguments or storage
  Future<String?> getCartTokenForNavigation() async {
    return await _getCartToken();
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
