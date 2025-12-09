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

  Future<void> initial({String? productId, Product? product}) async {
    if (product != null) {
      stateChanger(ProductDetailLoadedState(product: product, reviews: []));
      return;
    }

    if (productId == null) {
      stateChanger(ProductDetailErrorState('Product ID is missing.'));
      return;
    }

    stateChanger(ProductDetailLoadingState());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;

      // Fetch product, reviews, and favorite status in parallel
      final responses = await Future.wait<dynamic>([
        _supabaseClient
            .from('products')
            .select('*, product_images(*)')
            .eq('id', productId)
            .single(),
        _supabaseClient
            .from('product_reviews')
            .select('*, users(full_name)')
            .eq('product_id', productId),
        if (userId != null)
          _supabaseClient
              .from('favorites')
              .select('id')
              .eq('user_id', userId)
              .eq('product_id', productId)
              .limit(1)
        else
          Future.value([]),
      ]);

      final productResponse = responses[0] as PostgrestMap;
      final reviewsResponse = responses[1] as List<dynamic>;
      final favoriteResponse = responses[2] as List<dynamic>;

      final loadedProduct = Product.fromJson(productResponse);
      final reviews = reviewsResponse
          .map((data) => ProductReview.fromJson(data))
          .toList();

      final isInWishlist = favoriteResponse.isNotEmpty;

      stateChanger(ProductDetailLoadedState(
          product: loadedProduct,
          reviews: reviews,
          isInWishlist: isInWishlist));
    } catch (e) {
      stateChanger(
          ProductDetailErrorState('Failed to load product details: $e'));
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      // Maybe show a message to log in
      debugPrint("User not logged in, can't add to favorites.");
      return;
    }

    if (state is! ProductDetailLoadedState) return;

    final currentLoadedState = state as ProductDetailLoadedState;
    final bool isCurrentlyInWishlist = currentLoadedState.isInWishlist;

    try {
      if (isCurrentlyInWishlist) {
        // Remove from favorites
        await _supabaseClient
            .from('favorites')
            .delete()
            .match({'user_id': userId, 'product_id': productId});
        debugPrint('Product $productId removed from favorites.');
      } else {
        // Add to favorites
        await _supabaseClient
            .from('favorites')
            .insert({'user_id': userId, 'product_id': productId});
        debugPrint('Product $productId added to favorites.');
      }

      // Update the UI
      stateChanger(
        currentLoadedState.copyWith(isInWishlist: !isCurrentlyInWishlist),
      );
    } catch (e) {
      debugPrint("Error updating favorite status: $e");
      // Optionally, show an error message to the user
    }
  }

  void increaseQuantity() {
    if (state is ProductDetailLoadedState) {
      final currentLoadedState = state as ProductDetailLoadedState;
      stateChanger(currentLoadedState.copyWith(
          detailPageQuantity: currentLoadedState.detailPageQuantity + 1));
    }
  }

  void decreaseQuantity() {
    if (state is ProductDetailLoadedState) {
      final currentLoadedState = state as ProductDetailLoadedState;
      if (currentLoadedState.detailPageQuantity > 1) {
        stateChanger(currentLoadedState.copyWith(
            detailPageQuantity: currentLoadedState.detailPageQuantity - 1));
      }
    }
  }

  Future<bool> addToCart(String productId, int quantity) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint("User not logged in, can't add to cart.");
      return false;
    }

    try {
      // Check if the item is already in the cart
      final existingCartItem = await _supabaseClient
          .from('cart')
          .select('id, quantity')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existingCartItem != null) {
        // If it exists, update the quantity
        final newQuantity = (existingCartItem['quantity'] as int) + quantity;
        await _supabaseClient
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('id', existingCartItem['id'] as String);
        debugPrint('Product $productId quantity updated to $newQuantity.');
      } else {
        // If it doesn't exist, insert a new row
        await _supabaseClient.from('cart').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        });
        debugPrint('Product $productId added to cart with quantity $quantity.');
      }
      return true;
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      return false;
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
