import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_count_order_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class GetOrderCountHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final String? status = params['status'];
        final String? financialStatus = params['financial_status'];
        final String? fulfillmentStatus = params['fulfillment_status'];
        final String? createdAtMin = params['created_at_min'];
        final String? createdAtMax = params['created_at_max'];
        final String? updatedAtMin = params['updated_at_min'];
        final String? updatedAtMax = params['updated_at_max'];

        try {
          final GetCountOrderResponse responseData =
              await GetIt.I.get<OrderService>().getCountOrders(
                    apiVersion: apiVersion,
                    status: status,
                    financial_status: financialStatus,
                    fulfillment_status: fulfillmentStatus,
                    created_at_min: createdAtMin,
                    created_at_max: createdAtMax,
                    updated_at_min: updatedAtMin,
                    updated_at_max: updatedAtMax,
                  );

          // Process the response: access the 'count' field from the response object
          final int? orderCount = responseData.count;

          return {
            "status": "success",
            "message": "Order count fetched successfully",
            "count": orderCount, // Return the count
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          debugPrint("Error fetching order count: $e");
          return {
            "status": "error",
            "message": "Failed to fetch order count: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported by CountOrderHandler",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [],
      };

  Map<String, List<ApiField>> get optionalFields => {
        // Changed key from 'GET_COUNT' to 'GET'
        'GET': [
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'Enter the Shopify API version (e.g., 2024-04)',
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
        ],
      };
}
