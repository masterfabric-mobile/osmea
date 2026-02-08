import 'package:storefront_supabase/app/models/cart_item.dart';
import 'package:storefront_supabase/app/models/coupon.dart'; // Import Coupon model

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;
  final Coupon? appliedCoupon; // New field
  final double? discountAmount; // New field
  final double discountedTotal; // New field
  final String? couponMessage; // New field

  CartLoadedState({
    required this.cartItems,
    required this.totalPrice,
    this.appliedCoupon,
    this.discountAmount,
    double? discountedTotal, // Make nullable in constructor for calculation
    this.couponMessage,
  }) : discountedTotal = discountedTotal ?? (totalPrice - (discountAmount ?? 0.0)); // Calculate if not provided

  CartLoadedState copyWith({
    List<CartItem>? cartItems,
    double? totalPrice,
    Coupon? appliedCoupon,
    double? discountAmount,
    double? discountedTotal,
    String? couponMessage,
  }) {
    return CartLoadedState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      discountAmount: discountAmount ?? this.discountAmount,
      discountedTotal: discountedTotal ?? this.discountedTotal,
      couponMessage: couponMessage,
    );
  }
}

class CartErrorState extends CartState {
  final String message;
  CartErrorState(this.message);
}
