import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';

///*******************************************************************
///******************* 👥 CUSTOMER API HANDLER 👥 *******************
///*******************************************************************

class CustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for now
    if (method == 'GET') {
      // 📌 Simple GET request without parameters
      try {
        // 📞 Call the customer service API - no parameters needed
        final response = await GetIt.I.get<CustomerService>().customer(
              apiVersion: ApiNetwork.apiVersion,
            );

        // 📊 Organize customers by creation date
        try {
          final Map<String, List<dynamic>> customersByDate = {};
          final customers = response.customers;

          // 🧮 Process each customer in the response
          for (final customer in customers) {
            // 🗓️ Use creation date as category, default to "Other" if not available
            String category = "Other";
            final date = DateTime.tryParse(customer.createdAt as String);
            if (date != null) {
              category = "${_getMonthName(date.month)} ${date.year}";
            }

            // ➕ Add customer to category
            if (!customersByDate.containsKey(category)) {
              customersByDate[category] = [];
            }
            customersByDate[category]!.add(customer.toJson());
          }

          // 🔄 Convert to categories list
          final List<Map<String, dynamic>> categories =
              customersByDate.entries.map((entry) {
            return {
              "category": entry.key,
              "customers": entry.value,
            };
          }).toList();

          return {
            "status": "success",
            "categories": categories,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // 🚨 Fall back to simpler format if categorization fails
          return {
            "status": "success",
            "customers": response.customers.map((c) => c.toJson()).toList(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      } catch (e) {
        // ❌ Error handling
        return {
          "status": "error",
          "message": "Failed to fetch customers: ${e.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⚠️ Return error for unsupported methods
    return {
      "error": "Method $method not supported for Customer API",
    };
  }

  @override
  // 🔍 Only support GET method for now
  List<String> get supportedMethods => ['GET'];

  @override
  // 📝 No required fields since GET doesn't need parameters
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [], // Empty list as no fields are required
      };

  // 📅 Helper method to convert month number to name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
