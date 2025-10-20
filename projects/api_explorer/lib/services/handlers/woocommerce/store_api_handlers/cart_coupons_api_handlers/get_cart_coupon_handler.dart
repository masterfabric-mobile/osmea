import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
//******************* 🎟️ GET CART COUPON HANDLER *******************
///*******************************************************************

class GetCartCouponHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get Cart Coupon API",
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

      debugPrint('🔍 Fetching cart coupon: $couponCode');

      final response = await GetIt.I<CartCouponsService>().getCartCoupon(
        apiVersion: WooNetwork.apiVersion,
        couponCode: couponCode,
      );

      debugPrint('✅ Cart coupon retrieved successfully');

      return {
        "status": "success",
        "message": "Cart coupon retrieved successfully",
        "data": response.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error fetching cart coupon: $e');
      return {
        "status": "error",
        "message": "Failed to fetch cart coupon: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          ApiField(
            name: 'coupon_code',
            label: 'Coupon Code',
            hint: 'The coupon code to retrieve (e.g., SUMMER2024)',
            isRequired: true,
            type: ApiFieldType.text,
          ),
        ],
      };
}
