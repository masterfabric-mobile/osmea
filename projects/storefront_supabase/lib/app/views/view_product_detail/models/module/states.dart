import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:storefront_supabase/app/models/product_variant.dart';

enum ReviewFilterType { all, verified, productRatingHigh, deliveryRatingHigh, withComment }

abstract class ProductDetailState {}

class ProductDetailInitialState extends ProductDetailState {}

class ProductDetailLoadingState extends ProductDetailState {}

class ProductDetailLoadedState extends ProductDetailState {
  final Product product;
  final List<ProductReview> allReviews;
  final List<ProductReview> reviews;
  final bool isInWishlist;
  final bool isInCart; // Added
  final int detailPageQuantity;
  final ProductVariant? selectedVariant;
  final ReviewFilterType activeFilter;
  
  // Attribute selection support
  final Map<String, String> selectedAttributes;
  final Set<String> highlightedAttributes;
  final bool shouldShowAddToCartPopup;
  final bool isDescriptionExpanded;

  ProductDetailLoadedState({
    required this.product,
    required this.reviews,
    List<ProductReview>? allReviews,
    this.isInWishlist = false,
    this.isInCart = false, // Default false
    this.detailPageQuantity = 1,
    this.selectedVariant,
    this.activeFilter = ReviewFilterType.all,
    this.selectedAttributes = const {},
    this.highlightedAttributes = const {},
    this.shouldShowAddToCartPopup = false,
    this.isDescriptionExpanded = false,
  }) : allReviews = allReviews ?? reviews;

  ProductDetailLoadedState copyWith({
    Product? product,
    List<ProductReview>? reviews,
    List<ProductReview>? allReviews,
    bool? isInWishlist,
    bool? isInCart,
    int? detailPageQuantity,
    ProductVariant? selectedVariant,
    ReviewFilterType? activeFilter,
    Map<String, String>? selectedAttributes,
    Set<String>? highlightedAttributes,
    bool? shouldShowAddToCartPopup,
    bool? isDescriptionExpanded,
  }) {
    return ProductDetailLoadedState(
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      allReviews: allReviews ?? this.allReviews,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      isInCart: isInCart ?? this.isInCart,
      detailPageQuantity: detailPageQuantity ?? this.detailPageQuantity,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      activeFilter: activeFilter ?? this.activeFilter,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      highlightedAttributes: highlightedAttributes ?? this.highlightedAttributes,
      shouldShowAddToCartPopup: shouldShowAddToCartPopup ?? this.shouldShowAddToCartPopup,
      isDescriptionExpanded: isDescriptionExpanded ?? this.isDescriptionExpanded,
    );
  }
}

class ProductDetailErrorState extends ProductDetailState {
  final String message;
  final ProductDetailLoadedState? previousState; // For recovery

  ProductDetailErrorState(this.message, {this.previousState});
}

class ProductDetailSuccessState extends ProductDetailState {
  final String message;
  final ProductDetailLoadedState previousState;

  ProductDetailSuccessState({required this.message, required this.previousState});
}

class ProductDetailAuthRequiredState extends ProductDetailState {
  final String message;
  final ProductDetailLoadedState? previousState;

  ProductDetailAuthRequiredState({required this.message, this.previousState});
}