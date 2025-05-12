import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';

import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_request.dart'
    as create_request;
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_response.dart'
    as create_response;
import 'package:apis/network/remote/orders/order/freezed_model/response/get_single_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/update_order_request.dart'
    as update_request;
import 'package:apis/network/remote/orders/order/freezed_model/response/update_order_response.dart'
    as update_response;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class OrderHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? orderId = params['order_id'];

        if (orderId == null || orderId.isEmpty) {
          return {
            "status": "error",
            "message": "Order ID is required to get a single order.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final GetSingleOrderResponse response =
              await GetIt.I.get<OrderService>().getSingleOrder(
                    apiVersion: apiVersion,
                    orderId: orderId,
                  );

          return {
            "status": "success",
            "message": "Order fetched successfully",
            "order": response.order?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          debugPrint("Error fetching single order: $e");
          return {
            "status": "error",
            "message": "Failed to fetch order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? variantIdsStr = params['variant_ids'];
        final String? quantitiesStr = params['quantities'];
        final String? customerFirstName = params['customer_first_name'];
        final String? customerLastName = params['customer_last_name'];
        final String? customerEmail = params['customer_email'];
        final String? billingFirstName = params['billing_first_name'];
        final String? billingLastName = params['billing_last_name'];
        final String? billingAddress1 = params['billing_address1'];
        final String? billingPhone = params['billing_phone'];
        final String? billingCity = params['billing_city'];
        final String? billingProvince = params['billing_province'];
        final String? billingCountry = params['billing_country'];
        final String? billingZip = params['billing_zip'];
        final String? shippingFirstName = params['shipping_first_name'];
        final String? shippingLastName = params['shipping_last_name'];
        final String? shippingAddress1 = params['shipping_address1'];
        final String? shippingPhone = params['shipping_phone'];
        final String? shippingCity = params['shipping_city'];
        final String? shippingProvince = params['shipping_province'];
        final String? shippingCountry = params['shipping_country'];
        final String? shippingZip = params['shipping_zip'];
        final String? financialStatus = params['financial_status'];
        final String? verifiedEmail = params['verified_email'];
        final bool sendReceipt =
            params['send_receipt']?.toLowerCase() == 'true';
        final bool sendFulfillmentReceipt =
            params['send_fulfillment_receipt']?.toLowerCase() == 'true';
        final String? tags = params['tags'];
        final String? note = params['note'];
        final bool test = params['test']?.toLowerCase() == 'true';

        if (variantIdsStr == null ||
            variantIdsStr.isEmpty ||
            quantitiesStr == null ||
            quantitiesStr.isEmpty ||
            customerFirstName == null ||
            customerFirstName.isEmpty ||
            customerLastName == null ||
            customerLastName.isEmpty ||
            customerEmail == null ||
            customerEmail.isEmpty) {
          return {
            "status": "error",
            "message":
                "Variant IDs, Quantities, Customer First Name, Last Name, and Email are required.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final List<String> variantIds = variantIdsStr.split(',');
          final List<String> quantities = quantitiesStr.split(',');

          if (variantIds.length != quantities.length) {
            return {
              "status": "error",
              "message": "Number of Variant IDs and Quantities must match.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final List<create_request.LineItem> lineItems = [];
          for (int i = 0; i < variantIds.length; i++) {
            final int? variantId = int.tryParse(variantIds[i].trim());
            final int? quantity = int.tryParse(quantities[i].trim());

            if (variantId != null && quantity != null) {
              lineItems.add(
                create_request.LineItem(
                  variantId: variantId,
                  quantity: quantity,
                ),
              );
            } else {
              return {
                "status": "error",
                "message": "Invalid Variant ID or Quantity at index ${i + 1}.",
                "timestamp": DateTime.now().toIso8601String(),
              };
            }
          }

          final create_request.Customer customer = create_request.Customer(
            firstName: customerFirstName,
            lastName: customerLastName,
            email: verifiedEmail,
          );

          final create_request.IngAddress billingAddress =
              create_request.IngAddress(
            firstName: billingFirstName,
            lastName: billingLastName,
            address1: billingAddress1,
            phone: billingPhone,
            city: billingCity,
            province: billingProvince,
            country: billingCountry,
            zip: billingZip,
          );

          final create_request.IngAddress shippingAddress =
              create_request.IngAddress(
            firstName: shippingFirstName,
            lastName: shippingLastName,
            address1: shippingAddress1,
            phone: shippingPhone,
            city: shippingCity,
            province: shippingProvince,
            country: shippingCountry,
            zip: shippingZip,
          );

          final create_request.Order order = create_request.Order(
            lineItems: lineItems,
            customer: customer,
            billingAddress: billingAddress,
            shippingAddress: shippingAddress,
            financialStatus: financialStatus,
            email: verifiedEmail,
            sendReceipt: sendReceipt,
            sendFulfillmentReceipt: sendFulfillmentReceipt,
            tags: tags,
            note: note,
            test: test,
          );

          final create_request.CreateOrderRequest model =
              create_request.CreateOrderRequest(order: order);

          final create_response.CreateOrderResponse responseData =
              await GetIt.I.get<OrderService>().createOrder(
                    apiVersion: apiVersion,
                    model: model,
                  );

          return {
            "status": "success",
            "message": "Order created successfully",
            "order": responseData.order?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          debugPrint("Error creating order: $e");
          return {
            "status": "error",
            "message": "Failed to create order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'PUT':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? orderId = params['order_id'];
        final String? processedAt = params['processed_at'];
        final String? shippingProvince = params['shipping_province'];
        final String? shippingCountry = params['shipping_country'];
        final String? shippingProvinceCode = params['shipping_province_code'];
        final String? shippingCountryCode = params['shipping_country_code'];
        final String? sourceName = params['source_name'];

        if (orderId == null || orderId.isEmpty) {
          return {
            "status": "error",
            "message": "Order ID is required to update an order.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Check for required fields for PUT based on API errors
        if (processedAt == null || processedAt.isEmpty) {
          return {
            "status": "error",
            "message": "Processed At timestamp is required to update an order.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        // Assuming shipping address fields are required based on the error
        if (shippingProvince == null ||
            shippingProvince.isEmpty ||
            shippingCountry == null ||
            shippingCountry.isEmpty ||
            shippingProvinceCode == null ||
            shippingProvinceCode.isEmpty ||
            shippingCountryCode == null ||
            shippingCountryCode.isEmpty) {
          return {
            "status": "error",
            "message":
                "Shipping address fields (province, country, province_code, country_code) are required to update an order.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final int? parsedOrderId = int.tryParse(orderId);
          if (parsedOrderId == null) {
            return {
              "status": "error",
              "message": "Invalid Order ID provided.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // Always create shipping address object with required fields
          final update_request.ShippingAddress shippingAddress =
              update_request.ShippingAddress(
            province: shippingProvince,
            country: shippingCountry,
            provinceCode: shippingProvinceCode,
            countryCode: shippingCountryCode,
          );

          // Construct the Order object with available update fields
          final update_request.Order orderToUpdate = update_request.Order(
            id: parsedOrderId,
            note: params['note'],
            tags: params['tags'],
            financialStatus: params['financial_status'],
            processedAt: processedAt,
            shippingAddress: shippingAddress,
            sourceName: sourceName,
          );

          final update_request.UpdateOrderRequest model =
              update_request.UpdateOrderRequest(order: orderToUpdate);

          final update_response.UpdateOrderResponse responseData =
              await GetIt.I.get<OrderService>().updateOrder(
                    apiVersion: apiVersion,
                    orderId: orderId,
                    model: model,
                  );

          return {
            "status": "success",
            "message": "Order updated successfully",
            "order": responseData.order?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          debugPrint("Error updating order: $e");
          return {
            "status": "error",
            "message": "Failed to update order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'DELETE': // Added DELETE case
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? orderId = params['order_id'];

        if (orderId == null || orderId.isEmpty) {
          return {
            "status": "error",
            "message": "Order ID is required to delete an order.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          await GetIt.I.get<OrderService>().deleteOrder(
                apiVersion: apiVersion,
                orderId: orderId,
              );

          return {
            "status": "success",
            "message": "Order deleted successfully",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          debugPrint("Error deleting order: $e");
          return {
            "status": "error",
            "message": "Failed to delete order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Order API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET', 'POST', 'PUT', 'DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'order_id',
            label: 'Order ID',
            hint: 'Enter the ID of the order to retrieve',
          ),
        ],
        'POST': [
          const ApiField(
            name: 'variant_ids',
            label: 'Variant IDs',
            hint: 'Enter variant IDs separated by commas (e.g., 123,456,789)',
          ),
          const ApiField(
            name: 'quantities',
            label: 'Quantities',
            hint: 'Enter quantities separated by commas (e.g., 1,2,3)',
          ),
          const ApiField(
            name: 'customer_first_name',
            label: 'Customer First Name',
            hint: 'Enter the first name of the customer',
          ),
          const ApiField(
            name: 'customer_last_name',
            label: 'Customer Last Name',
            hint: 'Enter the last name of the customer',
          ),
          const ApiField(
            name: 'customer_email',
            label: 'Customer Email',
            hint: 'Enter the email of the customer',
          ),
        ],
        'PUT': [
          const ApiField(
            name: 'order_id',
            label: 'Order ID',
            hint: 'Enter the ID of the order to update',
          ),
          const ApiField(
            name: 'processed_at',
            label: 'Processed At',
            hint:
                'Update the processed timestamp for the order (e.g., 2024-01-01T10:00:00Z)',
          ),
          const ApiField(
            name: 'shipping_province',
            label: 'Shipping Province',
            hint: 'Update the shipping province',
          ),
          const ApiField(
            name: 'shipping_country',
            label: 'Shipping Country',
            hint: 'Update the shipping country',
          ),
          const ApiField(
            name: 'shipping_province_code',
            label: 'Shipping Province Code',
            hint: 'Update the shipping province code (e.g., ON for Ontario)',
          ),
          const ApiField(
            name: 'shipping_country_code',
            label: 'Shipping Country Code',
            hint: 'Update the shipping country code (e.g., CA for Canada)',
          ),
          const ApiField(
            name: 'source_name',
            label: 'Source Name',
            hint: 'Enter the source name for the order',
          ),
        ],
        'DELETE': [
          const ApiField(
            name: 'order_id',
            label: 'Order ID',
            hint: 'Enter the ID of the order to delete',
          ),
        ],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'POST': [
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'Enter the Shopify API version (e.g., 2024-04)',
          ),
          const ApiField(
            name: 'variant_ids',
            label: 'Variant IDs (Comma Separated)',
            hint: 'Enter variant IDs separated by commas (e.g., 123,456,789)',
          ),
          const ApiField(
            name: 'quantities',
            label: 'Quantities (Comma Separated)',
            hint: 'Enter quantities separated by commas (e.g., 1,2,3)',
          ),
          const ApiField(
            name: 'customer_first_name',
            label: 'Customer First Name',
            hint: 'Enter the first name of the customer',
          ),
          const ApiField(
            name: 'customer_last_name',
            label: 'Customer Last Name',
            hint: 'Enter the last name of the customer',
          ),
          const ApiField(
            name: 'customer_email',
            label: 'Customer Email',
            hint: 'Enter the email of the customer',
          ),
          const ApiField(
            name: 'billing_first_name',
            label: 'Billing First Name',
            hint: 'Enter the billing first name',
          ),
          const ApiField(
            name: 'billing_last_name',
            label: 'Billing Last Name',
            hint: 'Enter the billing last name',
          ),
          const ApiField(
            name: 'billing_address1',
            label: 'Billing Address',
            hint: 'Enter the billing address',
          ),
          const ApiField(
            name: 'billing_phone',
            label: 'Billing Phone',
            hint: 'Enter the billing phone number',
          ),
          const ApiField(
            name: 'billing_city',
            label: 'Billing City',
            hint: 'Enter the billing city',
          ),
          const ApiField(
            name: 'billing_province',
            label: 'Billing Province',
            hint: 'Enter the billing province',
          ),
          const ApiField(
            name: 'billing_country',
            label: 'Billing Country',
            hint: 'Enter the billing country',
          ),
          const ApiField(
            name: 'billing_zip',
            label: 'Billing ZIP Code',
            hint: 'Enter the billing ZIP code',
          ),
          const ApiField(
            name: 'shipping_first_name',
            label: 'Shipping First Name',
            hint: 'Enter the shipping first name',
          ),
          const ApiField(
            name: 'shipping_last_name',
            label: 'Shipping Last Name',
            hint: 'Enter the shipping last name',
          ),
          const ApiField(
            name: 'shipping_address1',
            label: 'Shipping Address',
            hint: 'Enter the shipping address',
          ),
          const ApiField(
            name: 'shipping_phone',
            label: 'Shipping Phone',
            hint: 'Enter the shipping phone number',
          ),
          const ApiField(
            name: 'shipping_city',
            label: 'Shipping City',
            hint: 'Enter the shipping city',
          ),
          const ApiField(
            name: 'shipping_province',
            label: 'Shipping Province',
            hint: 'Enter the shipping province',
          ),
          const ApiField(
            name: 'shipping_country',
            label: 'Shipping Country',
            hint: 'Enter the shipping country',
          ),
          const ApiField(
            name: 'shipping_zip',
            label: 'Shipping ZIP Code',
            hint: 'Enter the shipping ZIP code',
          ),
          const ApiField(
            name: 'financial_status',
            label: 'Financial Status',
            hint: 'Enter the financial status of the order',
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'Enter the email address for the order',
          ),
          const ApiField(
            name: 'send_receipt',
            label: 'Send Receipt',
            type: ApiFieldType.boolean,
            hint: 'Indicate if a receipt should be sent',
          ),
          const ApiField(
            name: 'send_fulfillment_receipt',
            label: 'Send Fulfillment Receipt',
            type: ApiFieldType.boolean,
            hint: 'Indicate if a fulfillment receipt should be sent',
          ),
          const ApiField(
            name: 'tags',
            label: 'Tags',
            hint: 'Enter comma-separated tags for the order',
          ),
          const ApiField(
            name: 'note',
            label: 'Note',
            hint: 'Enter a note for the order',
          ),
          const ApiField(
            name: 'test',
            label: 'Test Order',
            type: ApiFieldType.boolean,
            hint: 'Indicate if this is a test order',
          ),
        ],
      };
}
