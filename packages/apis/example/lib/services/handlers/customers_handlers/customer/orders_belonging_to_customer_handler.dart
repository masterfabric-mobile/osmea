import 'package:apis/apis.dart';
// Change the import to get the correct service
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///************** 🛒 CUSTOMER ORDERS API HANDLER 🛒 *****************
///*******************************************************************

class OrdersBelongingToCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for customer orders
    if (method == 'GET') {
      // 🔍 Check if customer ID is provided - required parameter
      final customerId = params['customer_id'] ?? '';
      if (customerId.isEmpty) {
        return {
          "status": "error",
          "message": "Customer ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // Fix: Get the CustomerService, not the response type
        final response = await GetIt.I
            .get<CustomerService>() // Get the service, not the response type
            .customerOrders(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
            );

        // 📊 Process response based on the actual API structure
        try {
          // 🔄 Extract orders from the response - adjust property access as needed
          final orders = response.orders;

          if (orders.isNotEmpty) {
            // 📋 Categorize orders by status
            final Map<String, List<Map<String, dynamic>>> ordersByStatus = {};

            for (final order in orders) {
              // 🏷️ Determine category (adjust properties as needed)
              String category = "Other";
              final status = order.status ??
                  order.financialStatus ??
                  order.fulfillmentStatus;
              if (status != null && status.isNotEmpty) {
                category = _capitalizeFirst(status);
              }

              // ➕ Add order to category
              if (!ordersByStatus.containsKey(category)) {
                ordersByStatus[category] = [];
              }
              ordersByStatus[category]!.add(order.toJson());
            }

            // 🔄 Convert categories to list format for response
            final List<Map<String, dynamic>> categories =
                ordersByStatus.entries.map((entry) {
              return {
                "category": entry.key,
                "orders": entry.value,
              };
            }).toList();

            // 📤 Return categorized response
            return {
              "status": "success",
              "customerId": customerId,
              "categories": categories,
              "count": orders.length,
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // 📭 Empty result response
          return {
            "status": "success",
            "customerId": customerId,
            "message": "No orders found for this customer",
            "orders": [],
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // ⚠️ Fallback to simpler format if parsing fails
          return {
            "status": "success",
            "customerId": customerId,
            "orders": response.orders.map((o) => o.toJson()).toList(),
            "rawResponse": response.toString(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      } catch (e) {
        // ❌ Handle API errors
        return {
          "status": "error",
          "message": "Failed to fetch customer orders: ${e.toString()}",
          "customerId": customerId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Customer Orders API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'Enter customer ID to fetch their orders',
          ),
        ],
      };

  // 🔤 Helper to capitalize first letter of a string
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
