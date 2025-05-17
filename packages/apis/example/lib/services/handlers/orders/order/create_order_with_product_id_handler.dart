import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_with_product_id_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderWithProductIdHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        // Line Item Fields (Assuming one for simplicity)
        final String? lineItemVariantIdStr = params['line_item_variant_id'];
        final String? lineItemQuantityStr = params['line_item_quantity'];

        if (lineItemVariantIdStr == null ||
            lineItemVariantIdStr.isEmpty ||
            lineItemQuantityStr == null ||
            lineItemQuantityStr.isEmpty) {
          return {
            "status": "error",
            "message": "Variant ID and quantity are required fields",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final int? lineItemVariantId = int.tryParse(lineItemVariantIdStr);
          final int? lineItemQuantity = int.tryParse(lineItemQuantityStr);

          if (lineItemVariantId == null || lineItemQuantity == null) {
            return {
              "status": "error",
              "message": "Invalid number format for variant ID or quantity",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final model = CreateOrderWithProductIdRequest(
            order: Order(
              lineItems: [
                LineItem(
                  variantId: lineItemVariantId,
                  quantity: lineItemQuantity,
                ),
              ],
            ),
          );

          final response = await GetIt.I
              .get<OrderService>()
              .createOrderWithProductId(apiVersion: apiVersion, model: model);

          return {
            "status": "success",
            "message": "Order created successfully with product ID",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to create order with product ID: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Create Order API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
              name: 'line_item_variant_id',
              label: 'Variant ID',
              hint: 'Variant ID'),
          const ApiField(
              name: 'line_item_quantity', label: 'Quantity', hint: 'Quantity'),
        ],
      };
}
