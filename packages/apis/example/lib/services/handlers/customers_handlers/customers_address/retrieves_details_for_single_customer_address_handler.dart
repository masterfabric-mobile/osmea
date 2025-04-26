import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///*************** 📍 SINGLE CUSTOMER ADDRESS API HANDLER 📍 **********
///*******************************************************************

class RetrievesDetailsForSingleCustomerAddressHandler
    implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'GET') {
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

      try {
        final response = await GetIt.I
            .get<CustomerAddressService>()
            .retrieveListOfSingleAddresses(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
              addressId: addressId,
            );

        final customerAddress = response.customerAddress;

        if (customerAddress == null ||
            customerAddress.id.toString() != addressId) {
          return {
            "status": "error",
            "message": "Address not found.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        return {
          "status": "success",
          "customerAddress": customerAddress.toJson(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        return {
          "status": "error",
          "message": "Failed to fetch customer address: ${e.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    return {
      "error": "Method $method not supported for Single Customer Address API",
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
            name: 'customerId',
            label: 'Customer ID',
            hint: 'Enter customer ID',
          ),
          const ApiField(
            name: 'addressId',
            label: 'Address ID',
            hint: 'Enter address ID to fetch',
          ),
        ],
      };
}
