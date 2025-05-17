import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_sending_order_confirmation_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderSendingOrderConfirmationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final String? email = params['email'];
        final String? fulfillmentStatus = params['fulfillment_status'];
        final String? sendReceiptStr = params['send_receipt'];
        final String? sendFulfillmentReceiptStr =
            params['send_fulfillment_receipt'];

        List<LineItem> lineItems = [];
        int index = 0;
        while (params.containsKey('line_item_${index}_variant_id') &&
            params.containsKey('line_item_${index}_quantity')) {
          final String? variantIdStr = params['line_item_${index}_variant_id'];
          final String? quantityStr = params['line_item_${index}_quantity'];

          if (variantIdStr != null && quantityStr != null) {
            final int? variantId = int.tryParse(variantIdStr);
            final int? quantity = int.tryParse(quantityStr);

            if (variantId != null && quantity != null) {
              lineItems.add(LineItem(variantId: variantId, quantity: quantity));
            }
          }
          index++;
        }

        if (email == null || email.isEmpty || lineItems.isEmpty) {
          return {
            "status": "error",
            "message": "Email and at least one line item are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final bool? sendReceipt = sendReceiptStr?.toLowerCase() == 'true';
          final bool? sendFulfillmentReceipt =
              sendFulfillmentReceiptStr?.toLowerCase() == 'true';

          final model = CreateOrderSendingOrderConfirmationRequest(
            order: Order(
              email: email,
              fulfillmentStatus: fulfillmentStatus,
              sendReceipt: sendReceipt,
              sendFulfillmentReceipt: sendFulfillmentReceipt,
              lineItems: lineItems,
            ),
          );

          final response = await GetIt.I
              .get<OrderService>()
              .createOrderSendingOrderConfirmation(
                  apiVersion: apiVersion, model: model);

          return {
            "status": "success",
            "message": "Order created and confirmation sent successfully",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to create order and send confirmation: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Create Order With Confirmation API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(name: 'email', label: 'Email', hint: 'Email'),
          const ApiField(
              name: 'line_item_0_variant_id',
              label: 'Line Item 1 Variant ID',
              hint: 'Line Item 1 Variant ID'),
          const ApiField(
              name: 'line_item_0_quantity',
              label: 'Line Item 1 Quantity',
              hint: 'Line Item 1 Quantity'),
          const ApiField(
              name: 'fulfillment_status',
              label: 'Fulfillment Status',
              hint: '(Optional) Fulfillment Status'),
          const ApiField(
              name: 'send_receipt',
              label: 'Send Receipt',
              hint: '(Optional) true or false'),
          const ApiField(
              name: 'send_fulfillment_receipt',
              label: 'Send Fulfillment Receipt',
              hint: '(Optional) true or false'),
        ],
      };
}
