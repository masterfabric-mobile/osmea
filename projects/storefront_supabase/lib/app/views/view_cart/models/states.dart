import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/coupon.dart';

/// Simple cart item model for states
class CartItem {
  final String id; // This is the id from the 'cart' table in Supabase
  final int quantity;
  final Product product;
  final String? variantId; // Supabase variant ID
  
  CartItem({
    required this.id,
    required this.quantity,
    required this.product,
    this.variantId,
  });

  /// Copy with method for optimistic updates
  CartItem copyWith({
    String? id,
    int? quantity,
    Product? product,
    String? variantId,
  }) {
    return CartItem(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      variantId: variantId ?? this.variantId,
    );
  }
}

/// Base class for all cart states
abstract class CartState {}

/// Initial state when the cart view is first loaded
class CartInitialState extends CartState {}

/// Loading state when cart is being fetched
class CartLoadingState extends CartState {
  final CartLoadedState? previousState; // To show previous data while loading

  CartLoadingState({this.previousState});
}

/// Loaded state when cart is successfully fetched
class CartLoadedState extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;
  final int totalItems;
  final List<Coupon> coupons; // Supabase coupon model
  final String? currencyCode;
  final String? currencySymbol;
  
  // For UI responsiveness
  final int? updatingProductId; // ID of product currently being updated
  
  // For Checkout/Address (WooCommerce specific, but can adapt for Supabase if needed)
  final Map<String, dynamic>? shippingAddress;
  final Map<String, dynamic>? billingAddress;


  CartLoadedState({
    required this.cartItems,
    required this.totalPrice,
    this.totalItems = 0, // Calculated from cartItems in ViewModel
    this.coupons = const [],
    this.currencyCode = 'USD',
    this.currencySymbol = '\$',
    this.updatingProductId,
    this.shippingAddress,
    this.billingAddress,
  });

  CartLoadedState copyWith({
    List<CartItem>? cartItems,
    double? totalPrice,
    int? totalItems,
    List<Coupon>? coupons,
    String? currencyCode,
    String? currencySymbol,
    int? updatingProductId,
    bool clearUpdatingProductId = false,
    Map<String, dynamic>? shippingAddress,
    Map<String, dynamic>? billingAddress,
  }) {
    return CartLoadedState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
      coupons: coupons ?? this.coupons,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      updatingProductId: clearUpdatingProductId ? null : (updatingProductId ?? this.updatingProductId),
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
    );
  }

  /// Get total discount from all coupons (Supabase model)
  double get totalDiscount {
    // Implement discount calculation based on Supabase Coupon model if needed
    // For now, assume a simple discount directly from Coupon model if available
    return coupons.fold(0.0, (sum, coupon) {
      if (coupon.discountType == 'fixed_amount') {
        return sum + coupon.discountValue;
      } else if (coupon.discountType == 'percentage') {
        return sum + (totalPrice * coupon.discountValue / 100);
      }
      return sum;
    });
  }

  double get discountedTotal => totalPrice - totalDiscount;
}

/// Error state when cart fetching fails
class CartErrorState extends CartState {
  final String message;
  final CartLoadedState? previousState;

  CartErrorState({required this.message, this.previousState});
}

/// Auth required state when checkout requires authentication
class CartAuthRequiredState extends CartState {
  final String message;

  CartAuthRequiredState({required this.message});
}

/// Success state when an action is completed successfully
class CartSuccessState extends CartState {
  final String message;
  final CartLoadedState previousState;

  CartSuccessState({required this.message, required this.previousState});
}