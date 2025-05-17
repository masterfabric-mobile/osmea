import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_fulfill_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderFulfillHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final String? email = params['email'];
        final String? fulfillmentStatus = params['status'];

        final String? locationIdStr = params['location_id'];
        int? locationId;
        if (locationIdStr != null) {
          locationId = int.tryParse(locationIdStr);
        }
        List<Fulfillment> fulfillments = [];
        if (locationId != null) {
          fulfillments.add(Fulfillment(locationId: locationId));
        }

        List<LineItem> lineItems = [];
        final String? variantId0Str = params['variant_id'];
        final String? quantity0Str = params['quantity'];
        if (variantId0Str != null && quantity0Str != null) {
          final int? variantId0 = int.tryParse(variantId0Str);
          final int? quantity0 = int.tryParse(quantity0Str);
          if (variantId0 != null && quantity0 != null) {
            lineItems.add(LineItem(variantId: variantId0, quantity: quantity0));
          }
        }

        if (email == null ||
            email.isEmpty ||
            fulfillments.isEmpty ||
            lineItems.isEmpty) {
          return {
            "status": "error",
            "message":
                "Email, at least one fulfillment and one line item are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = CreateOrderFulfillRequest(
            order: Order(
              email: email,
              fulfillmentStatus: fulfillmentStatus,
              fulfillments: fulfillments,
              lineItems: lineItems,
            ),
          );

          final response = await GetIt.I
              .get<OrderService>()
              .createOrderFulfill(apiVersion: apiVersion, model: model);

          return {
            "status": "success",
            "message": "Order fulfillment initiated successfully",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to initiate order fulfillment: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Create Order Fulfillment API",
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
              name: 'location_id',
              label: 'Fulfillment 1 Location ID',
              hint: 'Fulfillment 1 Location ID'),
          const ApiField(
              name: 'variant_id',
              label: 'Line Item 1 Variant ID',
              hint: 'Line Item 1 Variant ID'),
          const ApiField(
              name: 'quantity',
              label: 'Line Item 1 Quantity',
              hint: 'Line Item 1 Quantity'),
          const ApiField(
              name: 'status',
              label: 'Fulfillment Status',
              hint: '(Optional) Fulfillment Status'),
        ],
      };
}
