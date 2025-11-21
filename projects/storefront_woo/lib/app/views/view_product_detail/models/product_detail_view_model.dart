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
  int _currentImageIndex = 0;

  // Public trigger functions - HydratedCubit pattern
  void loadProduct(int productId) => _loadProduct(productId);
  Future<void> addProductToCart(int productId, {int quantity = 1}) async =>
      await _addToCart(productId, quantity);
  void addProductToWishlist(int productId) => _addToWishlist(productId);
  void updateQuantity(int quantity) => _changeQuantity(quantity);
  void loadProductImages(List<String> imageUrls) => _loadImages(imageUrls);

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
        ),
      );
    } catch (e) {
      emit(ProductDetailErrorState(message: 'Failed to load product: $e'));
    }
  }

  Future<void> _addToCart(int productId, int quantity) async {
    final currentState = state;
    if (currentState is! ProductDetailLoadedState) return;

    try {
      // Set loading state
      emit(currentState.copyWith(isAddingToCart: true));

      debugPrint(
        '🛒 ProductDetailViewModel: Adding product $productId to cart via API',
      );

      // Wait 0.3 seconds for animation
      await Future.delayed(const Duration(milliseconds: 300));

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
          currentState.copyWith(
            isAddingToCart: false,
          ),
        );
        emit(
          ProductDetailErrorState(
            message: 'Failed to add item: ${response.errors!.first}',
          ),
        );
        return;
      }

      debugPrint('✅ Successfully added product $productId to cart via API');

      // Update state to show product is in cart and stop loading
      emit(currentState.copyWith(
        isInCart: true,
        isAddingToCart: false,
      ));
    } catch (e) {
      debugPrint('❌ Failed to add to cart: $e');
      emit(currentState.copyWith(isAddingToCart: false));
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
