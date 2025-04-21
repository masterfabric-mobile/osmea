import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';

///*******************************************************************
///******************* 👤 SINGLE CUSTOMER API HANDLER 👤 ************
///*******************************************************************

class SingleCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for single customer
    if (method == 'GET') {
      // 🔍 Check if customer ID is provided
      final customerId = params['id'] ?? '';
      if (customerId.isEmpty) {
        return {
          "status": "error",
          "message": "Customer ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // 👤 Get specific customer by ID
      try {
        final response = await GetIt.I.get<CustomerService>().singleCustomer(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
            );

        // 📋 Return the customer data
        return {
          "status": "success",
          "customer": response.customer?.toJson(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Handle errors
        return {
          "status": "error",
          "message": "Failed to fetch customer: ${e.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⚠️ Return error for unsupported methods
    return {
      "error": "Method $method not supported for Single Customer API",
    };
  }

  @override
  // 🔍 Only support GET method for now
  List<String> get supportedMethods => ['GET'];

  @override
  // 📝 Required fields for the GET method
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'id',
            label: 'Customer ID',
            hint: 'Enter customer ID to fetch',
          ),
        ],
      };
}
