import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
//******************* 🎟️ ADD CART COUPON HANDLER *******************
///*******************************************************************

class AddCartCouponHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported for Add Cart Coupon API",
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

      debugPrint('🔍 Adding cart coupon: $couponCode');

      final response = await GetIt.I<CartCouponsService>().addCartCoupon(
        apiVersion: WooNetwork.apiVersion,
        couponCode: couponCode,
      );

      debugPrint('✅ Cart coupon added successfully');

      return {
        "status": "success",
        "message": "Cart coupon added successfully",
        "data": response.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error adding cart coupon: $e');
      return {
        "status": "error",
        "message": "Failed to add cart coupon: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          ApiField(
            name: 'coupon_code',
            label: 'Coupon Code',
            hint: 'The coupon code to apply to the cart (e.g., SUMMER2024)',
            isRequired: true,
            type: ApiFieldType.text,
          ),
        ],
      };
}
