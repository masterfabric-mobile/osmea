/*
 * CartState
 * ---------
 * States for the cart view model.
 * Simple Dart classes without freezed.
 */

import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/list_cart_coupons_response_model.dart';

/// Simple cart item model for states
class CartItem {
  final int productId;
  final String productName;
  final double price;
  int quantity;
  final String? imageUrl;
  final String key;
  final List<Map<String, String>>? variations; // Variation attributes (e.g., [{"attribute": "pa_color", "value": "bronz"}])

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.variations,
    String? key,
  }) : key = key ?? 'cart_item_${productId}_${DateTime.now().millisecondsSinceEpoch}';

  double get totalPrice => price * quantity;
  
  /// Get formatted variation string for display (e.g., "Color: Bronz, Size: 42")
  String get formattedVariations {
    if (variations == null || variations!.isEmpty) {
      return '';
    }
    
    return variations!.map((variation) {
      final attribute = variation['attribute'] ?? '';
      final value = variation['value'] ?? '';
      
      // Remove 'pa_' prefix and format attribute name
      String attributeName = attribute;
      if (attributeName.startsWith('pa_')) {
        attributeName = attributeName.substring(3);
      }
      attributeName = attributeName.replaceAll('_', ' ');
      attributeName = attributeName.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1);
      }).join(' ');
      
      return '$attributeName: $value';
    }).join(', ');
  }
}

/// Base class for all cart states
abstract class CartState {}

/// Initial state when the cart view is first loaded
class CartInitialState extends CartState {}

/// Loading state when cart is being fetched
class CartLoadingState extends CartState {}

/// Loaded state when cart is successfully fetched
class CartLoadedState extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;
  final int totalItems;
  final List<ListCartCouponsResponseModel> coupons;
  final dynamic shippingAddress;
  final dynamic billingAddress;
  final String? currencyCode;
  final String? currencySymbol;

  CartLoadedState({
    required this.cartItems,
    required this.totalPrice,
    required this.totalItems,
    required this.coupons,
    required this.shippingAddress,
    required this.billingAddress,
    this.currencyCode,
    this.currencySymbol,
  });

  CartLoadedState copyWith({
    List<CartItem>? cartItems,
    double? totalPrice,
    int? totalItems,
    List<ListCartCouponsResponseModel>? coupons,
    dynamic shippingAddress,
    dynamic billingAddress,
    String? currencyCode,
    String? currencySymbol,
  }) {
    return CartLoadedState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
      coupons: coupons ?? this.coupons,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  /// Get total discount from all coupons
  double get totalDiscount {
    double discount = 0.0;
    for (final coupon in coupons) {
      if (coupon.totals?.totalDiscount != null) {
        discount += double.tryParse(coupon.totals!.totalDiscount!) ?? 0.0;
      }
    }
    return discount;
  }
}

/// Error state when cart fetching fails
class CartErrorState extends CartState {
  final String message;

  CartErrorState({required this.message});
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
