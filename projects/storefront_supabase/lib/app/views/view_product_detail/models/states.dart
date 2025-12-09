import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_review.dart';

abstract class ProductDetailState {}

class ProductDetailInitialState extends ProductDetailState {}

class ProductDetailLoadingState extends ProductDetailState {}

class ProductDetailLoadedState extends ProductDetailState {
  final Product product;
  final List<ProductReview> reviews;
  final bool isInWishlist; // Added for wishlist feature
  final int detailPageQuantity;

  ProductDetailLoadedState({
    required this.product,
    required this.reviews,
    this.isInWishlist = false, // Default to false
    this.detailPageQuantity = 1,
  });

  ProductDetailLoadedState copyWith({
    Product? product,
    List<ProductReview>? reviews,
    bool? isInWishlist,
    int? detailPageQuantity,
  }) {
    return ProductDetailLoadedState(
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      detailPageQuantity: detailPageQuantity ?? this.detailPageQuantity,
    );
  }
}

class ProductDetailErrorState extends ProductDetailState {
  final String message;

  ProductDetailErrorState(this.message);
}
