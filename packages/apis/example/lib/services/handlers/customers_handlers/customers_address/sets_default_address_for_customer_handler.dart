import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///*************** 🏠 SET DEFAULT ADDRESS API HANDLER 🏠 *************
///*******************************************************************

class SetsDefaultAddressForCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle PUT requests for setting default address
    if (method == 'PUT') {
      // 🔍 Check if required parameters are provided
      final customerId = params['customerId'] ?? '';
      final addressId = params['addressId'] ?? '';

      if (customerId.isEmpty) {
        return {
          "status": "error",
          "message": "Customer ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (addressId.isEmpty) {
        return {
          "status": "error",
          "message": "Address ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // 🏠 Set address as default
      try {
        final response = await GetIt.I
            .get<CustomerAddressService>()
            .setsDefaultAddressForCustomer(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
              addressId: addressId,
            );

        // Use the correct property from the response
        // Check if the operation was successful based on response structure
        if (response.customerAddress != null) {
          return {
            "status": "success",
            "message": "Address set as default successfully",
            "customerAddress": response.customerAddress?.toJson(),
            "customerId": customerId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else {
          // The operation might have succeeded but returned incomplete data
          return {
            "status": "success",
            "warning":
                "Address set as default but no confirmation data returned",
            "addressId": addressId,
            "customerId": customerId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      } catch (e) {
        // ❌ Handle errors with more detail
        return {
          "status": "error",
          "message": "Failed to set default address: ${e.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⚠️ Return error for unsupported methods
    return {
      "error": "Method $method not supported for Set Default Address API",
    };
  }

  @override
  // 🔍 Only support PUT method for this operation
  List<String> get supportedMethods => ['PUT'];

  @override
  // 📝 Required fields for the PUT method
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'customerId',
            label: 'Customer ID',
            hint: 'Enter customer ID',
          ),
          const ApiField(
            name: 'addressId',
            label: 'Address ID',
            hint: 'Enter address ID to set as default',
          ),
        ],
      };
}
