import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'states.dart';

@injectable
class ProductDetailViewModel extends BaseViewModelCubit<ProductDetailState> {
  final SupabaseClient _supabaseClient;

  late final TextEditingController reviewTitleController;
  late final TextEditingController reviewCommentController;
  double currentRating = 3;

  ProductDetailViewModel(this._supabaseClient)
      : super(ProductDetailInitialState()) {
    reviewTitleController = TextEditingController();
    reviewCommentController = TextEditingController();
  }

  Future<void> initial({String? productId}) async {
    if (productId == null) {
      stateChanger(ProductDetailErrorState('Product ID is missing.'));
      return;
    }

    stateChanger(ProductDetailLoadingState());
    try {
      // Fetch product and reviews
      final productResponse = await _supabaseClient
          .from('products')
          .select('*, product_images(*)')
          .eq('id', productId)
          .single();
      
      final reviewsResponse = await _supabaseClient
          .from('product_reviews')
          .select('*, users(full_name)')
          .eq('product_id', productId);

      final product = Product.fromJson(productResponse);
      final reviews = reviewsResponse
          .map((data) =>
              ProductReview.fromJson(data))
          .toList();

      stateChanger(
          ProductDetailLoadedState(product: product, reviews: reviews));
    } catch (e) {
      stateChanger(
          ProductDetailErrorState('Failed to load product details: $e'));
    }
  }

  Future<void> addToCart(String productId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      return;
    }

    try {
      await _supabaseClient.from('cart').insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': 1,
      });
    } catch (e) {
      // Handle error
    }
  }

  void setRating(double rating) {
    currentRating = rating;
  }

  Future<bool> submitReview(String productId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      return false;
    }
    if (reviewCommentController.text.isEmpty) {
      return false;
    }

    try {
      await _supabaseClient.from('product_reviews').insert({
        'product_id': productId,
        'user_id': userId,
        'rating': currentRating.toInt(),
        'title': reviewTitleController.text,
        'comment': reviewCommentController.text,
      });
      reviewTitleController.clear();
      reviewCommentController.clear();
      currentRating = 3;
      initial(productId: productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    reviewTitleController.dispose();
    reviewCommentController.dispose();
  }
}
