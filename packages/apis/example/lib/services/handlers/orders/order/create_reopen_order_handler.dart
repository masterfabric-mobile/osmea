import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_reopen_order_request.dart'
    as reopen_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateReopenOrderHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? orderIdStr = params['order_id'];

        if (orderIdStr == null || orderIdStr.isEmpty) {
          return {
            "status": "error",
            "message": "Order ID is a required field",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        final int? orderId = int.tryParse(orderIdStr);
        if (orderId == null) {
          return {
            "status": "error",
            "message": "Invalid Order ID format",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = reopen_request.CreateReopenOrderRequest(
            order: reopen_request.Order(
              id: orderId,
            ),
          );

          final response = await GetIt.I.get<OrderService>().createReopenOrder(
                apiVersion: apiVersion,
                orderId: orderId.toString(),
                model: model,
              );

          return {
            "status": "success",
            "message": "Order reopened successfully",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to reopen order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Reopen Order API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'order_id',
            label: 'Order ID',
            hint: 'Enter the ID of the order to reopen', // Updated hint
          ),
        ],
      };
}
