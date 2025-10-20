import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
//******************* 🎟️ GET CART COUPONS HANDLER *******************
///*******************************************************************

class GetCartCouponsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get Cart Coupons API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      debugPrint('🔍 Fetching cart coupons');

      final response = await GetIt.I<CartCouponsService>().getCartCoupons(
        apiVersion: WooNetwork.apiVersion,
      );

      debugPrint('✅ Cart coupons retrieved successfully');

      return {
        "status": "success",
        "message": "Cart coupons retrieved successfully",
        "data": response.map((e) => e.toJson()).toList(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error fetching cart coupons: $e');
      return {
        "status": "error",
        "message": "Failed to fetch cart coupons: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [], // No parameters required
      };
}
