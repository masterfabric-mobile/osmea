import 'package:flutter/material.dart';
import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/product_variant.dart';
import 'states.dart';

@injectable
class ProductDetailViewModel extends BaseViewModelCubit<ProductDetailState> {
  final SupabaseClient _supabaseClient;

  late final TextEditingController reviewTitleController;
  late final TextEditingController reviewCommentController;
  late final TextEditingController deliveryReviewCommentController;
  double currentRating = 3;
  double currentDeliveryRating = 3;

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  ProductDetailViewModel(this._supabaseClient)
    : super(ProductDetailInitialState()) {
    reviewTitleController = TextEditingController();
    reviewCommentController = TextEditingController();
    deliveryReviewCommentController = TextEditingController();
  }

  Future<void> initializeWithProduct(String productId) async {
    await initial(productId: productId);
  }

  Future<void> loadProduct(String productId) async {
    await initial(productId: productId);
  }

  Future<void> initial({String? productId, Product? product}) async {
    if (productId == null) {
      stateChanger(ProductDetailErrorState('Product ID is missing.'));
      return;
    }

    stateChanger(ProductDetailLoadingState());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;

      // 1. Fetch Product
      final productFuture = _supabaseClient
          .from('products')
          .select('*, product_images(*), product_variants(*)')
          .eq('id', productId)
          .single();

      // 2. Fetch Reviews
      final reviewsFuture = _fetchReviewsSafely(productId);

      // 3. Fetch Favorite Status
      final favoriteFuture = (userId != null)
          ? _supabaseClient
                .from('favorites')
                .select('id')
                .eq('user_id', userId)
                .eq('product_id', productId)
                .limit(1)
                .maybeSingle()
          : Future<Map<String, dynamic>?>.value(null);

      // 4. Check Cart Status
      final cartFuture = (userId != null)
          ? _supabaseClient
                .from('cart')
                .select('quantity')
                .eq('user_id', userId)
                .eq('product_id', productId)
                .maybeSingle()
          : Future.value(null);

      final responses = await Future.wait(<Future<dynamic>>[
        productFuture as Future<dynamic>,
        reviewsFuture as Future<dynamic>,
        favoriteFuture as Future<dynamic>,
        cartFuture as Future<dynamic>,
      ]);

      final productResponse = responses[0] as Map<String, dynamic>;
      final reviewsResponse = responses[1] as List<dynamic>;
      final favoriteResponse = responses[2] as Map<String, dynamic>?;
      final cartResponse = responses[3] as Map<String, dynamic>?;

      final loadedProduct = Product.fromJson(productResponse);
      final reviews = reviewsResponse
          .map((data) => ProductReview.fromJson(data))
          .toList();

      final isInWishlist = favoriteResponse != null;
      final isInCart = cartResponse != null;
      final cartQuantity = cartResponse != null
          ? (cartResponse['quantity'] as int)
          : 1;

      stateChanger(
        ProductDetailLoadedState(
          product: loadedProduct,
          reviews: reviews,
          isInWishlist: isInWishlist,
          isInCart: isInCart,
          detailPageQuantity: isInCart ? cartQuantity : 1,
        ),
      );
    } catch (e) {
      stateChanger(
        ProductDetailErrorState('Failed to load product details: $e'),
      );
    }
  }

  Future<List<dynamic>> _fetchReviewsSafely(String productId) async {
    try {
      final response = await _supabaseClient
          .from('product_reviews')
          .select('*, users(full_name)')
          .eq('product_id', productId)
          .order('created_at', ascending: false);
      return response as List<dynamic>;
    } catch (e) {
      try {
        final response = await _supabaseClient
            .from('product_reviews')
            .select('*')
            .eq('product_id', productId)
            .order('created_at', ascending: false);
        return response as List<dynamic>;
      } catch (e2) {
        rethrow;
      }
    }
  }

  void filterReviews(ReviewFilterType filter) {
    if (state is! ProductDetailLoadedState) return;
    final currentState = state as ProductDetailLoadedState;

    List<ProductReview> filtered = currentState.allReviews;

    switch (filter) {
      case ReviewFilterType.verified:
        filtered = filtered.where((r) => r.isVerifiedPurchase).toList();
        break;
      case ReviewFilterType.productRatingHigh:
        filtered = filtered.where((r) => r.rating >= 4).toList();
        break;
      case ReviewFilterType.deliveryRatingHigh:
        filtered = filtered
            .where((r) => r.deliveryRating != null && r.deliveryRating! >= 4)
            .toList();
        break;
      case ReviewFilterType.withComment:
        filtered = filtered
            .where((r) => r.comment != null && r.comment!.isNotEmpty)
            .toList();
        break;
      case ReviewFilterType.all:
        break;
    }

    stateChanger(
      currentState.copyWith(reviews: filtered, activeFilter: filter),
    );
  }

  // --- Attribute Logic ---

  Future<void> setSelectedAttribute(String name, String value) async {
    if (state is! ProductDetailLoadedState) return;
    final currentState = state as ProductDetailLoadedState;

    final newAttributes = Map<String, String>.from(
      currentState.selectedAttributes,
    );
    newAttributes[name] = value;

    ProductVariant? matchingVariant;

    if (currentState.product.variants.isNotEmpty) {
      try {
        matchingVariant = currentState.product.variants.firstWhere(
          (v) => v.name == name && v.value == value,
        );
      } catch (_) {}
    }

    stateChanger(
      currentState.copyWith(
        selectedAttributes: newAttributes,
        selectedVariant: matchingVariant,
        highlightedAttributes: {},
      ),
    );
  }

  Future<void> clearSelectedAttribute(String name) async {
    if (state is! ProductDetailLoadedState) return;
    final currentState = state as ProductDetailLoadedState;
    final newAttributes = Map<String, String>.from(
      currentState.selectedAttributes,
    );
    newAttributes.remove(name);
    stateChanger(
      currentState.copyWith(
        selectedAttributes: newAttributes,
        selectedVariant: null,
      ),
    );
  }

  // --- Actions ---

  Future<void> addProductToWishlistFire(String productId) async {
    final currentState = state;
    if (currentState is! ProductDetailLoadedState) return;

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      stateChanger(
        ProductDetailAuthRequiredState(
          message: 'Please sign in to manage favorites',
          previousState: currentState,
        ),
      );
      return;
    }

    final wasInWishlist = currentState.isInWishlist;
    stateChanger(currentState.copyWith(isInWishlist: !wasInWishlist));

    try {
      if (wasInWishlist) {
        await _supabaseClient.from('favorites').delete().match({
          'user_id': userId,
          'product_id': productId,
        });
      } else {
        await _supabaseClient.from('favorites').insert({
          'user_id': userId,
          'product_id': productId,
        });
      }

      stateChanger(
        ProductDetailSuccessState(
          message: wasInWishlist
              ? 'Removed from favorites'
              : 'Added to favorites',
          previousState: currentState.copyWith(isInWishlist: !wasInWishlist),
        ),
      );
    } catch (e) {
      stateChanger(currentState.copyWith(isInWishlist: wasInWishlist));
      stateChanger(
        ProductDetailErrorState(
          'Failed to update favorites: $e',
          previousState: currentState,
        ),
      );
    }
  }

  Future<void> addProductToCart(String productId, {int quantity = 1}) async {
    final currentState = state;
    if (currentState is! ProductDetailLoadedState) return;

    if (currentState.product.variants.isNotEmpty) {
      final attributeNames = currentState.product.variants
          .map((v) => v.name)
          .toSet();
      final missing = attributeNames
          .where((name) => !currentState.selectedAttributes.containsKey(name))
          .toSet();

      if (missing.isNotEmpty) {
        stateChanger(currentState.copyWith(highlightedAttributes: missing));
        Future.delayed(const Duration(seconds: 2), () {
          if (state is ProductDetailLoadedState) {
            stateChanger(
              (state as ProductDetailLoadedState).copyWith(
                highlightedAttributes: {},
              ),
            );
          }
        });
        return;
      }
    }

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      stateChanger(
        ProductDetailAuthRequiredState(
          message: 'Please sign in to add to cart',
          previousState: currentState,
        ),
      );
      return;
    }

    try {
      final variantId = currentState.selectedVariant?.id;

      var query = _supabaseClient
          .from('cart')
          .select('id, quantity')
          .eq('user_id', userId)
          .eq('product_id', productId);

      if (variantId != null) {
        query = query.eq('variant_id', variantId);
      } else {
        query = query.isFilter('variant_id', null);
      }

      final existing = await query.maybeSingle();

      if (existing != null) {
        final newQty = (existing['quantity'] as int) + quantity;
        await _supabaseClient
            .from('cart')
            .update({'quantity': newQty})
            .eq('id', existing['id']);
      } else {
        await _supabaseClient.from('cart').insert({
          'user_id': userId,
          'product_id': productId,
          'variant_id': variantId,
          'quantity': quantity,
        });
      }

      stateChanger(
        currentState.copyWith(isInCart: true, shouldShowAddToCartPopup: true),
      );
    } catch (e) {
      stateChanger(
        ProductDetailErrorState(
          'Failed to add to cart: $e',
          previousState: currentState,
        ),
      );
    }
  }

  void updateQuantityFire(int quantity) {
    if (state is ProductDetailLoadedState) {
      final s = state as ProductDetailLoadedState;
      if (quantity > 0) {
        stateChanger(s.copyWith(detailPageQuantity: quantity));
      }
    }
  }

  void increaseQuantity() {
    if (state is ProductDetailLoadedState) {
      final s = state as ProductDetailLoadedState;
      stateChanger(s.copyWith(detailPageQuantity: s.detailPageQuantity + 1));
    }
  }

  void decreaseQuantity() {
    if (state is ProductDetailLoadedState) {
      final s = state as ProductDetailLoadedState;
      if (s.detailPageQuantity > 1) {
        stateChanger(s.copyWith(detailPageQuantity: s.detailPageQuantity - 1));
      }
    }
  }

  Future<bool> submitReview(String productId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;
    if (reviewCommentController.text.isEmpty) return false;

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
      await initial(productId: productId);
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

  void setRating(double rating) {
    currentRating = rating;
  }

  void setDeliveryRating(double rating) {
    currentDeliveryRating = rating;
  }
}
