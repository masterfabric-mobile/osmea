import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/list_cart_coupons_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/retrieve_cart_coupon_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/add_cart_coupon_response_model.dart';

/// 🔑 Abstract contract for WooCommerce Store API Cart Coupons Service
/// Implement this to fetch and manage cart coupons from WooCommerce Store API! 🌐
abstract class CartCouponsService {
  /// 🚀 Fetches the list of coupons applied to the cart from WooCommerce Store API.
  /// This endpoint provides information about discount codes applied to the current cart.
  Future<List<ListCartCouponsResponseModel>> getCartCoupons({
    required String apiVersion,
  });

  /// 🚀 Retrieves a single coupon by code from the cart.
  /// This endpoint provides detailed information about a specific coupon applied to the cart.
  Future<RetrieveCartCouponResponseModel> getCartCoupon({
    required String apiVersion,
    required String couponCode,
  });

  /// 🚀 Adds a coupon to the cart.
  /// This endpoint applies a discount code to the current cart.
  Future<AddCartCouponResponseModel> addCartCoupon({
    required String apiVersion,
    required String couponCode,
  });

  /// 🚀 Deletes a single coupon from the cart.
  /// This endpoint removes a specific discount code from the current cart.
  Future<void> deleteCartCoupon({
    required String apiVersion,
    required String couponCode,
  });

  /// 🚀 Deletes all coupons from the cart.
  /// This endpoint removes all discount codes from the current cart.
  Future<void> deleteAllCartCoupons({
    required String apiVersion,
  });
}
