/*
 * ProductDetailState
 * ------------------
 * States for the product detail view model.
 * Simple Dart classes without freezed.
 */

import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart';

/// Base class for all product detail states
abstract class ProductDetailState {}

/// Initial state when the view is first loaded
class ProductDetailInitialState extends ProductDetailState {}

/// Loading state when product detail is being fetched
class ProductDetailLoadingState extends ProductDetailState {}

/// Loaded state when product detail is successfully fetched
class ProductDetailLoadedState extends ProductDetailState {
  final RetrieveProductResponseModel product;
  final int selectedQuantity;
  final List<String> imageUrls;
  final int currentImageIndex;
  final bool isInCart;
  final bool isInWishlist;

  ProductDetailLoadedState({
    required this.product,
    this.selectedQuantity = 1,
    this.imageUrls = const [],
    this.currentImageIndex = 0,
    this.isInCart = false,
    this.isInWishlist = false,
  });

  ProductDetailLoadedState copyWith({
    RetrieveProductResponseModel? product,
    int? selectedQuantity,
    List<String>? imageUrls,
    int? currentImageIndex,
    bool? isInCart,
    bool? isInWishlist,
  }) {
    return ProductDetailLoadedState(
      product: product ?? this.product,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      imageUrls: imageUrls ?? this.imageUrls,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      isInCart: isInCart ?? this.isInCart,
      isInWishlist: isInWishlist ?? this.isInWishlist,
    );
  }
}

/// Error state when product detail fetching fails
class ProductDetailErrorState extends ProductDetailState {
  final String message;

  ProductDetailErrorState({required this.message});
}

/// Success state when an action is completed successfully
class ProductDetailSuccessState extends ProductDetailState {
  final String message;
  final ProductDetailLoadedState previousState;

  ProductDetailSuccessState({
    required this.message,
    required this.previousState,
  });
}
