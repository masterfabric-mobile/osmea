import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_review.dart';

abstract class ProductDetailState {}

class ProductDetailInitialState extends ProductDetailState {}

class ProductDetailLoadingState extends ProductDetailState {}

class ProductDetailLoadedState extends ProductDetailState {
  final Product product;
  final List<ProductReview> reviews;

  ProductDetailLoadedState({
    required this.product,
    required this.reviews,
  });
}

class ProductDetailErrorState extends ProductDetailState {
  final String message;

  ProductDetailErrorState(this.message);
}
