import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///*************** 🏠 CUSTOMER ADDRESS LIST HANDLER 🏠 ***************
///*******************************************************************

class RetrievesListOfAddressesForCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        // 📋 Retrieve a list of addresses for a customer
        try {
          // 🔍 Validate required parameters
          final customerId = params['customer_id'] ?? '';
          if (customerId.isEmpty) {
            return {
              "status": "error",
              "message": "Customer ID is required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // Parse optional limit parameter
          int? limit;
          if (params.containsKey('limit') && params['limit']!.isNotEmpty) {
            try {
              limit = int.parse(params['limit']!);
              if (limit <= 0) limit = null;
            } catch (e) {
              return {
                "status": "error",
                "message":
                    "Invalid limit parameter. Must be a positive integer.",
                "timestamp": DateTime.now().toIso8601String(),
              };
            }
          }

          // 📞 Call the API to retrieve addresses
          final response = await GetIt.I
              .get<CustomerAddressService>()
              .retrieveListOfAddresses(
                apiVersion: ApiNetwork.apiVersion,
                customerId: customerId,
              );

          // 🔢 Process the addresses and organize them
          var addresses = response.addresses ?? [];

          // Apply limit if specified
          final totalAddresses = addresses.length;
          if (limit != null && addresses.length > limit) {
            addresses = addresses.take(limit).toList();
          }

          // 🏠 Organize addresses by country
          final Map<String, List<dynamic>> addressesByCountry = {};
          for (final address in addresses) {
            final countryName = address.country ?? "Unknown";
            if (!addressesByCountry.containsKey(countryName)) {
              addressesByCountry[countryName] = [];
            }
            addressesByCountry[countryName]!.add(address.toJson());
          }

          // 🎉 Return successful response with limit information if applicable
          return {
            "status": "success",
            "message": "Addresses retrieved successfully",
            "totalAddresses": totalAddresses,
            "returnedAddresses": addresses.length,
            "limited": limit != null && totalAddresses > limit,
            "addressesByCountry": addressesByCountry,
            "customerId": customerId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // ❌ Handle authentication errors specially
          if (e.toString().contains('session has expired') ||
              e.toString().contains('login?errorHint=no_identity_session')) {
            return {
              "status": "auth_error",
              "message":
                  "Your authentication session has expired. Please log in again to continue.",
              "details":
                  "This occurs when your admin authentication token is no longer valid.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // ❌ Handle other errors
          return {
            "status": "error",
            "message": "Failed to retrieve addresses: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "error":
              "Method $method not supported for retrieving Customer Addresses. Only GET is allowed.",
        };
    }
  }

  @override
  // 🔍 Only GET method is supported for retrieving addresses
  List<String> get supportedMethods => ['GET'];

  @override
  // 📝 Define required fields for retrieving addresses with optional limit
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'ID of the customer to retrieve addresses for',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit (Optional)',
            hint: 'Maximum number of addresses to retrieve',
          ),
        ],
      };
}
