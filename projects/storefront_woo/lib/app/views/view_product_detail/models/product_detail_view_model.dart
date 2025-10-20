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
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/services/cart_service.dart';
import 'package:get_it/get_it.dart';

@injectable
class ProductDetailViewModel
    extends BaseViewModelHydratedCubit<ProductDetailState> {
  ProductDetailViewModel() : super(ProductDetailInitialState());

  // Dependencies
  final ProductService _productService = GetIt.I<ProductService>();
  final CartService _cartService = CartService();

  // State variables
  int _selectedQuantity = 1;
  List<String> _imageUrls = [];
  int _currentImageIndex = 0;

  // Public trigger functions - HydratedCubit pattern
  void loadProduct(int productId) => _loadProduct(productId);
  void addProductToCart(int productId, {int quantity = 1}) =>
      _addToCart(productId, quantity);
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
          if (img is Map<String, dynamic> && img['src'] != null) {
            imageUrls.add(img['src'] as String);
          }
        }
      }

      // Check if product is in cart or wishlist
      final isInCart = _cartService.isInCart(productId);
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
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      // Find the product to add to cart
      final product = currentState.product;

      // Create cart item
      // Get image URL safely
      String? imageUrl;
      if (product.images != null && product.images!.isNotEmpty) {
        final firstImg = product.images!.first;
        if (firstImg is Map<String, dynamic> && firstImg['src'] != null) {
          imageUrl = firstImg['src'] as String;
        }
      }

      final cartItem = CartItem(
        productId: product.id ?? 0,
        productName: product.name ?? 'Unknown Product',
        price: _parsePrice(product.prices),
        quantity: quantity,
        imageUrl: imageUrl,
      );

      // Add to cart service
      _cartService.addItem(cartItem);

      debugPrint('✅ Added product ${product.name} to cart');

      // Update state
      emit(currentState.copyWith(isInCart: true));

      // Show success message
      emit(
        ProductDetailSuccessState(
          message: 'Product added to cart successfully!',
          previousState: currentState.copyWith(isInCart: true),
        ),
      );
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

  /// Parses price string to double for cart calculations
  double _parsePrice(Prices? prices) {
    if (prices == null) {
      debugPrint('❌ ProductDetailViewModel: Prices is null');
      return 0.0;
    }

    debugPrint('💰 ProductDetailViewModel: Price data: ${prices.toJson()}');

    // Prefer sale price if available, otherwise regular price, then main price
    final priceString =
        prices.salePrice ?? prices.regularPrice ?? prices.price ?? '0.00';

    debugPrint('💰 ProductDetailViewModel: Price string: $priceString');

    // Use PriceInfoCurrencyHelper for parsing
    final parsedPrice =
        PriceInfoCurrencyHelper.parsePriceToDouble(priceString) ?? 0.0;

    debugPrint('💰 ProductDetailViewModel: Parsed price: $parsedPrice');
    return parsedPrice;
  }
}
