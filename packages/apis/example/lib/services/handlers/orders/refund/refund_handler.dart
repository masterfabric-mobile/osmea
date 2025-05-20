import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/refund/abstract/refund.dart';
import 'package:apis/network/remote/orders/refund/freezed_model/response/get_single_refund_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class RefundHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? orderIdStr = params['order_id'];
        final String? refundIdStr = params['refund_id'];

        if (orderIdStr == null ||
            orderIdStr.isEmpty ||
            refundIdStr == null ||
            refundIdStr.isEmpty) {
          return {
            "status": "error",
            "message": "Order ID and Refund ID are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final int? orderId = int.tryParse(orderIdStr);
          final int? refundId = int.tryParse(refundIdStr);

          if (orderId == null || refundId == null) {
            return {
              "status": "error",
              "message": "Invalid number format for Order ID or Refund ID",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final GetSingleRefundResponse response = await GetIt.I
              .get<RefundService>()
              .getSingleRefund(
                  apiVersion: apiVersion,
                  orderId: orderId.toString(),
                  refundId: refundId.toString());

          return response.toJson();
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to get single refund: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Get Single Refund API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(name: 'order_id', label: 'Order ID', hint: 'Order ID'),
          const ApiField(
              name: 'refund_id', label: 'Refund ID', hint: 'Refund ID'),
        ],
      };
}
