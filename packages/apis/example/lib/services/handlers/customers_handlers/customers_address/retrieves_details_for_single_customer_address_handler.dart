import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/request/update_postal_code_of_customer_address_request.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/retrieves_list_of_addresses_for_customer_response.dart'
    as response;
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
        // Keep it simple - ApiInterceptorDefault already handles error formatting
        return {
          "status": "error",
          "message": "Failed to update postal code: ${e.toString()}",
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
        // Keep it simple - ApiInterceptorDefault already handles error formatting
        return {
          "status": "error",
          "message": "Failed to update postal code: ${e.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } else if (method == 'DELETE') {
      // 🗑️ Handle DELETE request to remove a single address
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
        // Check if this is a default address before attempting deletion
        final allAddressesResponse =
            await GetIt.I.get<CustomerAddressService>().retrieveListOfAddresses(
                  apiVersion: ApiNetwork.apiVersion,
                  customerId: customerId,
                );

        // Find the target address in the list
        final addresses = allAddressesResponse.addresses ?? [];

        // Look for the address but without using orElse to avoid type conflicts
        response.Address? targetAddress;
        for (var addr in addresses) {
          if (addr.id.toString() == addressId) {
            targetAddress = addr;
            break;
          }
        }

        // Check if it exists
        if (targetAddress == null || targetAddress.id == null) {
          return {
            "status": "error",
            "message": "Address not found",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Check if it's the default address using the correct property
        // Different Shopify response models might use different property names
        bool isDefaultAddress = false;

        // Try different property names that might indicate default status
        if (targetAddress.toJson().containsKey('default')) {
          isDefaultAddress = targetAddress.toJson()['default'] == true;
        } else if (targetAddress.toJson().containsKey('default_address')) {
          isDefaultAddress = targetAddress.toJson()['default_address'] == true;
        } else if (targetAddress.toJson().containsKey('is_default')) {
          isDefaultAddress = targetAddress.toJson()['is_default'] == true;
        }

        if (isDefaultAddress) {
          return {
            "status": "error",
            "message": "Cannot delete the default address",
            "shopifyError":
                "Cannot remove address ids because the default address id ($addressId) was included",
            "troubleshooting":
                "You must set another address as default before deleting this one",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        final addressIdInt = int.tryParse(addressId);
        if (addressIdInt == null) {
          return {
            "status": "error",
            "message": "Invalid address ID format",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // The API call will be processed through ApiInterceptorDefault which handles most error cases
        await GetIt.I
            .get<CustomerAddressService>()
            .destroyMultipleCustomerAddresses(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
              addressIds: [addressIdInt],
              operation: 'destroy',
            );

        return {
          "status": "success",
          "message": "Address deleted successfully",
          "deletedAddressId": addressId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // Simple error handling - let ApiInterceptorDefault do the work
        String troubleshootingTip = "";
        if (e.toString().contains("default address")) {
          troubleshootingTip =
              "You cannot delete a customer's default address. "
              "First set another address as the default, then try again.";
        }

        return {
          "status": "error",
          "message": "Failed to delete address: ${e.toString()}",
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "DELETE",
            "customerId": customerId,
            "addressId": addressId,
            "apiVersion": ApiNetwork.apiVersion,
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    return {
      "status": "error",
      "message":
          "Method $method not supported for Single Customer Address API. Use GET, PUT, or DELETE.",
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  @override
  List<String> get supportedMethods => ['GET', 'PUT', 'DELETE'];

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
        'DELETE': [
          const ApiField(
            name: 'customerId',
            label: 'Customer ID',
            hint: 'Enter customer ID',
          ),
          const ApiField(
            name: 'addressId',
            label: 'Address ID',
            hint: 'Enter address ID to delete',
          ),
        ],
      };
}
