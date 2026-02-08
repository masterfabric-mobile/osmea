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
  final bool isInWishlist; // Added for wishlist feature
  final int detailPageQuantity;
  final ProductVariant? selectedVariant; // Added
  final ReviewFilterType activeFilter;

  ProductDetailLoadedState({
    required this.product,
    required this.reviews,
    List<ProductReview>? allReviews,
    this.isInWishlist = false, // Default to false
    this.detailPageQuantity = 1,
    this.selectedVariant, // Added
    this.activeFilter = ReviewFilterType.all,
  }) : allReviews = allReviews ?? reviews;

  ProductDetailLoadedState copyWith({
    Product? product,
    List<ProductReview>? reviews,
    List<ProductReview>? allReviews,
    bool? isInWishlist,
    int? detailPageQuantity,
    ProductVariant? selectedVariant, // Added
    ReviewFilterType? activeFilter,
  }) {
    return ProductDetailLoadedState(
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      allReviews: allReviews ?? this.allReviews,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      detailPageQuantity: detailPageQuantity ?? this.detailPageQuantity,
      selectedVariant: selectedVariant ?? this.selectedVariant, // Added
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class ProductDetailErrorState extends ProductDetailState {
  final String message;

  ProductDetailErrorState(this.message);
}
