/*
 * ProductDetailState
 * ------------------
 * States for the product detail view model.
 * Simple Dart classes without freezed.
 */

import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/freezed_model/response/list_product_reviews_response_model.dart';

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
  final bool isDescriptionExpanded;
  final Map<String, String> selectedAttributes;
  final List<ListProductReviewsResponseModel> reviews;
  final Set<String> highlightedAttributes; // Attributes to highlight in red

  ProductDetailLoadedState({
    required this.product,
    this.selectedQuantity = 1,
    this.imageUrls = const [],
    this.currentImageIndex = 0,
    this.isInCart = false,
    this.isInWishlist = false,
    this.isDescriptionExpanded = false,
    this.selectedAttributes = const {},
    this.reviews = const [],
    this.highlightedAttributes = const {},
  });

  ProductDetailLoadedState copyWith({
    RetrieveProductResponseModel? product,
    int? selectedQuantity,
    List<String>? imageUrls,
    int? currentImageIndex,
    bool? isInCart,
    bool? isInWishlist,
    bool? isDescriptionExpanded,
    Map<String, String>? selectedAttributes,
    List<ListProductReviewsResponseModel>? reviews,
    Set<String>? highlightedAttributes,
  }) {
    return ProductDetailLoadedState(
      product: product ?? this.product,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      imageUrls: imageUrls ?? this.imageUrls,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      isInCart: isInCart ?? this.isInCart,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      isDescriptionExpanded:
          isDescriptionExpanded ?? this.isDescriptionExpanded,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      reviews: reviews ?? this.reviews,
      highlightedAttributes: highlightedAttributes ?? this.highlightedAttributes,
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

/// Auth required state when user needs to sign in
class ProductDetailAuthRequiredState extends ProductDetailState {
  final String message;
  final int? productId; // Optional: product to add to cart after auth
  final int? quantity; // Optional: quantity to add after auth
  final ProductDetailLoadedState? previousState;

  ProductDetailAuthRequiredState({
    this.message = 'Please sign in to add items to cart',
    this.productId,
    this.quantity,
    this.previousState,
  });
}
