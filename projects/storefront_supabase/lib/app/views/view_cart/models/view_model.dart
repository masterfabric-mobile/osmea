import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/cart_item.dart';
import 'package:storefront_supabase/app/models/coupon.dart'; // Import Coupon model
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class CartViewModel extends BaseViewModelCubit<CartState> {
  final SupabaseClient _supabaseClient;
  final TextEditingController couponCodeController = TextEditingController(); // New

  CartViewModel(this._supabaseClient) : super(CartInitialState());

  Future<void> initial() async {
    stateChanger(CartLoadingState());
    final userId = _supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      stateChanger(CartErrorState('Please log in to view your cart.'));
      return;
    }

    try {
      final response = await _supabaseClient
          .from('cart')
          .select('id, quantity, products:product_id(*, product_images(*))')
          .eq('user_id', userId);

      final cartItems =
          response.map((data) => CartItem.fromJson(data)).toList();

      double totalPrice = 0.0;
      for (var item in cartItems) {
        totalPrice += item.product.price * item.quantity;
      }

      // If there's an existing coupon in the state, try to re-apply it.
      // This is important if the cart is refreshed but a coupon was active.
      Coupon? currentAppliedCoupon;
      String? currentCouponMessage;
      if (state is CartLoadedState) {
        final loadedState = state as CartLoadedState;
        if (loadedState.appliedCoupon != null) {
          final result = await _validateAndCalculateDiscount(
              loadedState.appliedCoupon!.code, totalPrice);
          if (result['coupon'] != null) {
            currentAppliedCoupon = result['coupon'];
          }
          currentCouponMessage = result['message'];
        }
      }

      final discountAmount = _calculateDiscountAmount(totalPrice, currentAppliedCoupon);
      final discountedTotal = totalPrice - discountAmount;

      stateChanger(
        CartLoadedState(
          cartItems: cartItems,
          totalPrice: totalPrice,
          appliedCoupon: currentAppliedCoupon,
          discountAmount: discountAmount,
          discountedTotal: discountedTotal,
          couponMessage: currentCouponMessage,
        ),
      );
    } catch (e) {
      stateChanger(CartErrorState('Failed to load cart: $e'));
    }
  }

  Future<void> applyCoupon(String couponCode) async {
    if (state is! CartLoadedState) return;
    final currentState = state as CartLoadedState;

    if (couponCode.trim().isEmpty) {
      stateChanger(currentState.copyWith(couponMessage: 'Please enter a coupon code.'));
      return;
    }

    // Clear previous message
    stateChanger(currentState.copyWith(couponMessage: null));

    final result = await _validateAndCalculateDiscount(couponCode, currentState.totalPrice);
    final appliedCoupon = result['coupon'];
    final couponMessage = result['message'];
    
    double discountAmount = 0.0;
    if (appliedCoupon != null) {
      discountAmount = _calculateDiscountAmount(currentState.totalPrice, appliedCoupon);
    }
    final discountedTotal = currentState.totalPrice - discountAmount;

    stateChanger(
      currentState.copyWith(
        appliedCoupon: appliedCoupon,
        discountAmount: discountAmount,
        discountedTotal: discountedTotal,
        couponMessage: couponMessage,
      ),
    );
  }

  Future<Map<String, dynamic>> _validateAndCalculateDiscount(String couponCode, double currentCartTotal) async {
    try {
      final response = await _supabaseClient
          .from('coupons')
          .select()
          .eq('code', couponCode)
          .single();

      final coupon = Coupon.fromJson(response);

      if (!coupon.isActive) {
        return {'coupon': null, 'message': 'Coupon is not active.'};
      }
      if (coupon.expiryDate != null && coupon.expiryDate!.isBefore(DateTime.now())) {
        return {'coupon': null, 'message': 'Coupon has expired.'};
      }
      if (coupon.usageLimit != null && coupon.usageCount >= coupon.usageLimit!) {
        return {'coupon': null, 'message': 'Coupon usage limit reached.'};
      }
      if (coupon.minimumPurchase != null && currentCartTotal < coupon.minimumPurchase!) {
        return {
          'coupon': null,
          'message': 'Minimum purchase of ${coupon.minimumPurchase} required.'
        };
      }

      return {'coupon': coupon, 'message': 'Coupon applied successfully!'};
    } catch (e) {
      return {'coupon': null, 'message': 'Invalid coupon code.'};
    }
  }

  double _calculateDiscountAmount(double total, Coupon? coupon) {
    if (coupon == null) return 0.0;

    if (coupon.discountType == 'percentage') {
      return (total * coupon.discountValue / 100).clamp(0.0, total);
    } else if (coupon.discountType == 'fixed_amount') {
      return coupon.discountValue.clamp(0.0, total);
    }
    return 0.0;
  }

  void removeCoupon() {
    if (state is! CartLoadedState) return;
    final currentState = state as CartLoadedState;

    stateChanger(
      currentState.copyWith(
        appliedCoupon: null,
        discountAmount: 0.0,
        discountedTotal: currentState.totalPrice, // Reset to original total
        couponMessage: 'Coupon removed.',
      ),
    );
  }

  Future<void> removeItem(String cartItemId) async {
    try {
      await _supabaseClient.from('cart').delete().eq('id', cartItemId);
      await initial(); // Refresh the cart
    } catch (e) {
      stateChanger(CartErrorState('Failed to remove item: $e'));
    }
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(cartItemId);
      return;
    }

    try {
      await _supabaseClient
          .from('cart')
          .update({'quantity': newQuantity}).eq('id', cartItemId);
      await initial(); // Refresh the cart
    } catch (e) {
      stateChanger(CartErrorState('Failed to update quantity: $e'));
    }
  }

  @override
  Future<void> close() {
    couponCodeController.dispose();
    return super.close();
  }
}
