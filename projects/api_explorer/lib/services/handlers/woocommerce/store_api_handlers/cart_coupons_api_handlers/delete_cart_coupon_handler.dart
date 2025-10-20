import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
//******************* 🎟️ DELETE CART COUPON HANDLER *******************
///*******************************************************************

class DeleteCartCouponHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported for Delete Cart Coupon API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Get coupon code from params
      final couponCode = params['coupon_code'];
      if (couponCode == null || couponCode.isEmpty) {
        return {
          "status": "error",
          "message": "Coupon code is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      debugPrint('🔍 Deleting cart coupon: $couponCode');

      await GetIt.I<CartCouponsService>().deleteCartCoupon(
        apiVersion: WooNetwork.apiVersion,
        couponCode: couponCode,
      );

      debugPrint('✅ Cart coupon deleted successfully');

      return {
        "status": "success",
        "message": "Cart coupon deleted successfully",
        "data": {"deleted_coupon": couponCode},
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error deleting cart coupon: $e');
      return {
        "status": "error",
        "message": "Failed to delete cart coupon: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'DELETE': [
          ApiField(
            name: 'coupon_code',
            label: 'Coupon Code',
            hint: 'The coupon code to remove from the cart (e.g., SUMMER2024)',
            isRequired: true,
            type: ApiFieldType.text,
          ),
        ],
      };
}
