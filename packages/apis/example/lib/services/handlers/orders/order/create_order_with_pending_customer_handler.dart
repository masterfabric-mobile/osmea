import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_with_pending_customer_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderWithPendingCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final String? financialStatus = params['financial_status'];

        // Customer Fields
        final String? customerIdStr = params['customer_id'];
        final String? customerFirstName = params['customer_first_name'];
        final String? customerLastName = params['customer_last_name'];
        final String? customerPhone = params['customer_phone'];
        final String? customerEmail = params['customer_email'];

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

        if (lineItems.isEmpty ||
            customerFirstName == null ||
            customerFirstName.isEmpty ||
            customerLastName == null ||
            customerLastName.isEmpty) {
          return {
            "status": "error",
            "message":
                "At least one line item and customer first/last name are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final int? customerId = int.tryParse(customerIdStr ?? "");

          final customer = Customer(
            id: customerId,
            firstName: customerFirstName,
            lastName: customerLastName,
            phone: customerPhone,
            email: customerEmail,
          );

          final model = CreateOrderWithPendingCustomerRequest(
            order: Order(
              lineItems: lineItems,
              customer: customer,
              financialStatus: financialStatus,
            ),
          );

          final response = await GetIt.I
              .get<OrderService>()
              .createOrderWithPendingCustomer(
                  apiVersion: apiVersion, model: model);

          return {
            "status": "success",
            "message": "Order created successfully with pending customer",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to create order with pending customer: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Create Order With Pending Customer API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
              name: 'customer_first_name',
              label: 'Customer First Name',
              hint: 'Customer First Name'),
          const ApiField(
              name: 'customer_last_name',
              label: 'Customer Last Name',
              hint: 'Customer Last Name'),
          const ApiField(
              name: 'customer_id',
              label: 'Customer ID',
              hint: '(Optional) Customer ID'),
          const ApiField(
              name: 'customer_phone',
              label: 'Customer Phone',
              hint: '(Optional) Customer Phone'),
          const ApiField(
              name: 'customer_email',
              label: 'Customer Email',
              hint: '(Optional) Customer Email'),
          const ApiField(
              name: 'line_item_0_variant_id',
              label: 'Line Item 1 Variant ID',
              hint: 'Line Item 1 Variant ID'),
          const ApiField(
              name: 'line_item_0_quantity',
              label: 'Line Item 1 Quantity',
              hint: 'Line Item 1 Quantity'),
          const ApiField(
              name: 'financial_status',
              label: 'Financial Status',
              hint: '(Optional) Financial Status'),
        ],
      };
}
