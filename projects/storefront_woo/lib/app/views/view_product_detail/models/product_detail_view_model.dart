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
import 'package:storefront_woo/app/services/cart_token_storage.dart';
import 'package:get_it/get_it.dart';

@injectable
class ProductDetailViewModel
    extends BaseViewModelHydratedCubit<ProductDetailState> {
  ProductDetailViewModel() : super(ProductDetailInitialState());

  // Dependencies
  final ProductService _productService = GetIt.I<ProductService>();
  final CartService _cartService = GetIt.I<CartService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

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
          final updated = Map<String, String>.from(currentState.selectedAttributes)
            ..[name] = value;
          emit(currentState.copyWith(selectedAttributes: updated));
        }
      });

  /// Clears a selected attribute
  Future<void> clearSelectedAttribute(String name) async => Future.microtask(() {
        final currentState = state;
        if (currentState is ProductDetailLoadedState) {
          final updated = Map<String, String>.from(currentState.selectedAttributes)
            ..remove(name);
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
      final isInCart = false; // TODO: Implement cart check via API
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

      // Add item to cart via API
      final response = await _cartService.addItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: await _getCartToken() ?? '',
        jwtToken: await _getJwtToken(), // Optional JWT token
        id: productId,
        quantity: quantity,
      );

      debugPrint(
        '🛒 ProductDetailViewModel: AddItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API add item error: ${response.errors!.first}');
        emit(
          ProductDetailErrorState(
            message: 'Failed to add item: ${response.errors!.first}',
          ),
        );
        return;
      }

      // Persist cart token if provided in response (fallback in case interceptor misses)
      try {
        final dynamic tokenCandidate =
            (response as dynamic).cartToken ??
            (response as dynamic).cartKey ??
            (response as dynamic).cart_key ??
            (response as dynamic).token;
        if (tokenCandidate is String && tokenCandidate.isNotEmpty) {
          await CartTokenStorage.saveCartToken(
            tokenCandidate,
            expiry: const Duration(days: 30),
          );
          debugPrint(
            '🛒 ProductDetailViewModel: Saved cart token from addItem',
          );
        }
      } catch (e) {
        debugPrint(
          '⚠️ ProductDetailViewModel: Could not extract cart token: $e',
        );
      }

      debugPrint('✅ Successfully added product $productId to cart via API');

      // Update state to show product is in cart
      final currentState = state;
      if (currentState is ProductDetailLoadedState) {
        emit(currentState.copyWith(isInCart: true));
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
    } catch (e) {
      debugPrint('❌ Failed to change quantity: $e');
      emit(ProductDetailErrorState(message: 'Failed to change quantity: $e'));
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

  /// Gets cart token from storage
  Future<String?> _getCartToken() async {
    try {
      // Use local CartTokenStorage for consistency
      final token = await CartTokenStorage.loadCartToken();
      debugPrint(
        '🛒 ProductDetailViewModel: Cart token from CartTokenStorage: ${token != null ? "Found (${token.length} chars)" : "Not found"}',
      );
      return token;
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
