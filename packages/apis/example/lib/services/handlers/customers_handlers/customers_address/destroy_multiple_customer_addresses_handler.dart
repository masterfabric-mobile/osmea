import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///*************** 🗑️ DESTROY MULTIPLE ADDRESSES API HANDLER 🗑️ *****
///*******************************************************************

class DestroyMultipleCustomerAddressesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only support PUT method with operation=destroy parameter
    if (method == 'PUT') {
      // 🔍 Check if customer ID is provided
      final customerId = params['customerId'] ?? '';
      final addressIdsParam = params['addressIds'] ?? '';

      if (customerId.isEmpty) {
        return {
          "status": "error",
          "message": "Customer ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (addressIdsParam.isEmpty) {
        return {
          "status": "error",
          "message": "Address IDs are required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Parse comma-separated addressIds
      final addressIds =
          addressIdsParam.split(',').map((e) => e.trim()).toList();

      if (addressIds.isEmpty) {
        return {
          "status": "error",
          "message": "At least one address ID must be provided",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // 🗑️ Delete the addresses
      // Define this variable outside the try block to make it accessible in the catch block
      List<int> validAddressIdsAsIntegers = [];

      try {
        // First check if the addresses exist before trying to delete
        final checkResponse =
            await GetIt.I.get<CustomerAddressService>().retrieveListOfAddresses(
                  apiVersion: ApiNetwork.apiVersion,
                  customerId: customerId,
                );

        // Verify address IDs are valid before proceeding
        final existingAddressIds = checkResponse.addresses
                ?.map((addr) => addr.id.toString())
                .toList() ??
            [];

        final validAddressIds =
            addressIds.where((id) => existingAddressIds.contains(id)).toList();

        if (validAddressIds.isEmpty) {
          return {
            "status": "error",
            "message":
                "None of the provided address IDs exist for this customer",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Convert string IDs to integers as required by the request model
        validAddressIdsAsIntegers = validAddressIds
            .map((id) => int.tryParse(id))
            .where((id) => id != null)
            .cast<int>()
            .toList();

        if (validAddressIdsAsIntegers.isEmpty) {
          return {
            "status": "error",
            "message": "Failed to parse address IDs as integers",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Proceed with deletion using only valid IDs
        final response = await GetIt.I
            .get<CustomerAddressService>()
            .destroyMultipleCustomerAddresses(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
              addressIds: validAddressIdsAsIntegers,
              operation: 'destroy',
            );

        // Check for errors in the response using the freezed model field
        final responseJson = response.toJson();
        if (response.errors != null && response.errors!.isNotEmpty) {
          String errorDetails = response.errors!;
          String troubleshootingTip = "";

          // Provide specific guidance for default address error
          if (errorDetails.contains("default address")) {
            troubleshootingTip =
                "You cannot delete a customer's default address. "
                "First set another address as the default, then try again.";
          }

          return {
            "status": "error",
            "message": "Failed to delete addresses: $errorDetails",
            "shopifyError": errorDetails,
            "troubleshooting": troubleshootingTip,
            "requestDetails": {
              "method": "PUT",
              "customerId": customerId,
              "addressIds": validAddressIds,
              "operation": "destroy",
              "apiVersion": ApiNetwork.apiVersion,
            },
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Check response (Shopify may return empty {})
        return {
          "status": "success",
          "message": "Addresses deleted successfully",
          "deletedAddressIds": validAddressIds,
          "responseData": responseJson,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // More extensive error handling
        String errorMessage = e.toString();
        int statusCode = 500;
        String shopifyErrorMessage = "";

        // Extract Shopify error message using regex
        // Pattern to match: {"errors":"error message"} or similar JSON structure
        final errorRegex = RegExp(r'"errors":\s*"(.*?)"');
        final match = errorRegex.firstMatch(errorMessage);
        if (match != null && match.groupCount >= 1) {
          shopifyErrorMessage = match.group(1) ?? "";
        }

        // Extract status code if available
        if (errorMessage.contains("status code of")) {
          final regex = RegExp(r"status code of (\d+)");
          final match = regex.firstMatch(errorMessage);
          if (match != null) {
            statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
          }
        }

        // Provide troubleshooting info based on error message
        String troubleshootingTip = "";

        // Check for default address error in the Shopify error message
        if (shopifyErrorMessage.contains("default address") ||
            errorMessage.contains("default address")) {
          troubleshootingTip =
              "You cannot delete a customer's default address. "
              "First set another address as the default, then try again.";
        } else if (statusCode == 422) {
          troubleshootingTip =
              "This may be due to trying to delete a default address or "
              "another validation error. Check the error details.";
        } else if (statusCode == 406) {
          troubleshootingTip =
              "This may be due to incorrect address IDs format or API version mismatch. "
              "Ensure the address IDs are correct and try with a single address first.";
        }

        return {
          "status": "error",
          "message": shopifyErrorMessage.isNotEmpty
              ? "Failed to delete addresses: $shopifyErrorMessage"
              : "Failed to delete addresses: $errorMessage",
          "statusCode": statusCode,
          "shopifyError": shopifyErrorMessage,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "PUT",
            "customerId": customerId,
            "addressIds": addressIds,
            "operation": "destroy",
            "apiVersion": ApiNetwork.apiVersion,
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⚠️ Return error for unsupported methods
    return {
      "error":
          "Method $method not supported for Destroy Multiple Addresses API. Use PUT instead.",
    };
  }

  @override
  // Support only PUT method as that's what Shopify expects
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
            name: 'addressIds',
            label: 'Address IDs',
            hint: 'Enter comma-separated address IDs to delete',
          ),
        ],
      };
}
