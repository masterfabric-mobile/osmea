import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:storefront_supabase/app/models/product_variant.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/favorite_action_status.dart'; // Import the new enum

import 'states.dart';

@injectable
class ProductDetailViewModel extends BaseViewModelCubit<ProductDetailState> {
  final SupabaseClient _supabaseClient;

  late final TextEditingController reviewTitleController;
  late final TextEditingController reviewCommentController;
  late final TextEditingController deliveryReviewCommentController;
  double currentRating = 3;
  double currentDeliveryRating = 3;

  ProductDetailViewModel(this._supabaseClient)
      : super(ProductDetailInitialState()) {
    reviewTitleController = TextEditingController();
    reviewCommentController = TextEditingController();
    deliveryReviewCommentController = TextEditingController();
  }

  Future<void> initial({String? productId, Product? product}) async {
    if (product != null) {
      stateChanger(ProductDetailLoadedState(product: product, reviews: []));
      // Even if we have the product object, we should probably fetch fresh data (variants, reviews)
      // falling through to fetch if productId is available is safer for full data.
      if (productId == null) return;
    }

    if (productId == null) {
      stateChanger(ProductDetailErrorState('Product ID is missing.'));
      return;
    }

    stateChanger(ProductDetailLoadingState());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;

      // Fetch product (with variants), reviews, and favorite status in parallel
      final responses = await Future.wait<dynamic>([
        _supabaseClient
            .from('products')
            .select('*, product_images(*), product_variants(*)') // Included product_variants
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

  void selectVariant(ProductVariant variant) {
    if (state is ProductDetailLoadedState) {
      final currentState = state as ProductDetailLoadedState;
      stateChanger(currentState.copyWith(selectedVariant: variant));
    }
  }

  Future<FavoriteActionStatus> toggleFavorite(String productId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      return FavoriteActionStatus.errorLogin;
    }

    if (state is! ProductDetailLoadedState) {
      return FavoriteActionStatus.unknownError;
    }

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
      return isCurrentlyInWishlist
          ? FavoriteActionStatus.removed
          : FavoriteActionStatus.added;
    } catch (e) {
      debugPrint("Error updating favorite status: $e");
      return FavoriteActionStatus.errorFailed;
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
    if (state is! ProductDetailLoadedState) return false;
    final currentState = state as ProductDetailLoadedState;

    // Check for variants
    if (currentState.product.variants.isNotEmpty && currentState.selectedVariant == null) {
      // Logic for enforcing variant selection will be handled in View (showing a message)
      // Returning false here so view can show snackbar "Please select a variant"
      return false;
    }

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint("User not logged in, can't add to cart.");
      return false;
    }

    try {
      final variantId = currentState.selectedVariant?.id;

      // Check if the item is already in the cart (match product AND variant)
      final query = _supabaseClient
          .from('cart')
          .select('id, quantity')
          .eq('user_id', userId)
          .eq('product_id', productId);
      
      if (variantId != null) {
        query.eq('variant_id', variantId);
      } else {
        query.isFilter('variant_id', null);
      }

      final existingCartItem = await query.maybeSingle();

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
          'variant_id': variantId,
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

  void setDeliveryRating(double rating) {
    currentDeliveryRating = rating;
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
        'delivery_rating': currentDeliveryRating.toInt(),
        'delivery_comment': deliveryReviewCommentController.text,
      });
      reviewTitleController.clear();
      reviewCommentController.clear();
      deliveryReviewCommentController.clear();
      currentRating = 3;
      currentDeliveryRating = 3;
      initial(productId: productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    reviewTitleController.dispose();
    reviewCommentController.dispose();
    deliveryReviewCommentController.dispose();
  }
}

