import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
//******************* 🎟️ DELETE ALL CART COUPONS HANDLER *******************
///*******************************************************************

class DeleteAllCartCouponsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message":
            "Method $method not supported for Delete All Cart Coupons API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      debugPrint('🔍 Deleting all cart coupons');

      await GetIt.I<CartCouponsService>().deleteAllCartCoupons(
        apiVersion: WooNetwork.apiVersion,
      );

      debugPrint('✅ All cart coupons deleted successfully');

      return {
        "status": "success",
        "message": "All cart coupons deleted successfully",
        "data": {"deleted_coupons": "all"},
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error deleting all cart coupons: $e');
      return {
        "status": "error",
        "message": "Failed to delete all cart coupons: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'DELETE': [], // No parameters required
      };
}
