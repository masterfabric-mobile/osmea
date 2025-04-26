import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/request/update_postal_code_of_customer_address_request.dart';
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
    } else if (method == 'PUT') {
      // 🔄 Handle PUT request to update postal code
      final customerId = params['customerId'] ?? '';
      final addressId = params['addressId'] ?? '';
      final postalCode = params['postalCode'] ?? '';

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

      if (postalCode.isEmpty) {
        return {
          "status": "error",
          "message": "Postal code is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // First, fetch the current address
        final getResponse = await GetIt.I
            .get<CustomerAddressService>()
            .retrieveListOfSingleAddresses(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
              addressId: addressId,
            );

        final customerAddress = getResponse.customerAddress;

        if (customerAddress == null ||
            customerAddress.id.toString() != addressId) {
          return {
            "status": "error",
            "message": "Address not found.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Update the address with new postal code
        final updateResponse = await GetIt.I
            .get<CustomerAddressService>()
            .updatePostalCodeOfCustomerAddress(
                apiVersion: ApiNetwork.apiVersion,
                customerId: customerId,
                addressId: addressId,
                model: UpdatePostalCodeOfCustomerAddressRequest(
                  address: Address(
                    id: int.tryParse(addressId),
                    zip: postalCode,
                  ),
                ));

        // Get the updated address from the response and ensure proper typing
        final updatedAddress = updateResponse.customerAddress;

        if (updatedAddress == null) {
          return {
            "status": "success",
            "message": "Postal code updated successfully",
            "customerAddress": customerAddress.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        return {
          "status": "success",
          "message": "Postal code updated successfully",
          "customerAddress": updatedAddress.toJson(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        return {
          "status": "error",
          "message": "Failed to update postal code: ${e.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    return {
      "error": "Method $method not supported for Single Customer Address API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET', 'PUT'];

  @override
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
        'PUT': [
          const ApiField(
            name: 'customerId',
            label: 'Customer ID',
            hint: 'Enter customer ID',
          ),
          const ApiField(
            name: 'addressId',
            label: 'Address ID',
            hint: 'Enter address ID to update',
          ),
          const ApiField(
            name: 'postalCode',
            label: 'Postal Code',
            hint: 'Enter new postal code',
          ),
        ],
      };
}
