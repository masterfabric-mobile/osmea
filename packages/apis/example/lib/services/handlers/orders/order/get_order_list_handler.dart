import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_list_order_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class GetOrderListHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        // Extract optional query parameters for getListOrders
        final String? ids = params['ids'];
        final String? name = params['name'];
        final int? limit = int.tryParse(params['limit'] ??
            ''); // Parse int, handle potential null or invalid format
        final String? sinceId =
            params['since_id']; // Use snake_case for parameter name
        final String? createdAtMin = params['created_at_min']; // Use snake_case
        final String? createdAtMax = params['created_at_max']; // Use snake_case
        final String? updatedAtMin = params['updated_at_min']; // Use snake_case
        final String? updatedAtMax = params['updated_at_max']; // Use snake_case
        final String? processedAtMin =
            params['processed_at_min']; // Use snake_case
        final String? processedAtMax =
            params['processed_at_max']; // Use snake_case
        final String? attributionAppId =
            params['attribution_app_id']; // Use snake_case
        final String? status = params['status'];
        final String? financialStatus =
            params['financial_status']; // Use snake_case
        final String? fulfillmentStatus =
            params['fulfillment_status']; // Use snake_case
        final String? fields = params['fields'];

        try {
          // Call the getListOrders method from OrderService
          // Based on the error, the actual response received here seems to be a single GetListOrderResponse object,
          // even if the service method might be declared differently.
          final GetListOrderResponse
              responseData = // Expecting a single response object
              await GetIt.I.get<OrderService>().getListOrders(
                    apiVersion: apiVersion,
                    ids: ids,
                    name: name,
                    limit: limit,
                    since_id: sinceId, // Pass snake_case parameter
                    created_at_min: createdAtMin, // Pass snake_case parameter
                    created_at_max: createdAtMax, // Pass snake_case parameter
                    updated_at_min: updatedAtMin, // Pass snake_case parameter
                    updated_at_max: updatedAtMax, // Pass snake_case parameter
                    processed_at_min:
                        processedAtMin, // Pass snake_case parameter
                    processed_at_max:
                        processedAtMax, // Pass snake_case parameter
                    attribution_app_id:
                        attributionAppId, // Pass snake_case parameter
                    status: status,
                    financial_status:
                        financialStatus, // Pass snake_case parameter
                    fulfillment_status:
                        fulfillmentStatus, // Pass snake_case parameter
                    fields: fields,
                  );

          // Process the response: access the 'orders' list from the single response object
          final List<Map<String, dynamic>> orderListJson = responseData
                  .orders // Access orders directly from the single object
                  ?.map<Map<String, dynamic>>(
                      (order) => order.toJson()) // Map each Order to JSON
                  .toList() ??
              []; // Handle case where orders list might be null

          return {
            "status": "success",
            "message": "Order list fetched successfully",
            "orders": orderListJson,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          debugPrint("Error fetching order list: $e");
          return {
            "status": "error",
            "message": "Failed to fetch order list: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
          // Consider more specific error handling based on DioException types if needed
        }

      default:
        // This handler only supports GET_LIST, so other methods are not supported here.
        return {
          "error": "Method $method not supported by ListOrderHandler",
        };
    }
  }

  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'GET': [
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'Enter the Shopify API version (e.g., 2024-04)',
          ),
          const ApiField(
            name: 'ids',
            label: 'Order IDs (Comma Separated)',
            hint: 'Comma-separated list of order IDs',
          ),
          const ApiField(
            name: 'name',
            label: 'Order Name',
            hint: 'Filter by order name',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Maximum number of results to retrieve',
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Show orders after the specified ID',
          ),
          const ApiField(
            name: 'created_at_min',
            label: 'Created At Min',
            hint: 'Show orders created after or at this date (ISO 8601)',
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created At Max',
            hint: 'Show orders created before or at this date (ISO 8601)',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated At Min',
            hint: 'Show orders updated after or at this date (ISO 8601)',
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated At Max',
            hint: 'Show orders updated before or at this date (ISO 8601)',
          ),
          const ApiField(
            name: 'processed_at_min',
            label: 'Processed At Min',
            hint: 'Show orders processed after or at this date (ISO 8601)',
          ),
          const ApiField(
            name: 'processed_at_max',
            label: 'Processed At Max',
            hint: 'Show orders processed before or at this date (ISO 8601)',
          ),
          const ApiField(
            name: 'attribution_app_id',
            label: 'Attribution App ID',
            hint: 'Filter by attribution app ID',
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint: 'Filter by order status',
          ),
          const ApiField(
            name: 'financial_status',
            label: 'Financial Status',
            hint: 'Filter by financial status',
          ),
          const ApiField(
            name: 'fulfillment_status',
            label: 'Fulfillment Status',
            hint: 'Filter by fulfillment status',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include',
          ),
        ],
      };
}
