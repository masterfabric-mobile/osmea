import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/updates_customer_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';

///*******************************************************************
///************** ✏️ UPDATE CUSTOMER API HANDLER ✏️ ***************
///*******************************************************************

class UpdateCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle PUT requests for customer updates
    if (method == 'PUT') {
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
        // Extract metadata parameters
        final metafieldKey = params['metafield_key'];
        final metafieldValue = params['metafield_value'];

        if (metafieldKey == null || metafieldValue == null || metafieldValue.trim().isEmpty) {
          return {
            "status": "error",
            "message": "Metafield key and non-empty value are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // 🔄 Create request model for customer update focusing on metadata
        final request = UpdatesCustomerRequest(
          customer: Customer(
            id: int.tryParse(customerId),
            metafields: [
              Metafield(
                key: metafieldKey,
                value: metafieldValue,
                type: params['metafield_type'] ?? 'single_line_text_field',
                namespace: params['namespace'] ?? 'global',
              ),
            ],
          ),
        );

        // 📞 Call the customer service API to update customer
        final updatedCustomer =
            await GetIt.I.get<CustomerService>().updatesCustomer(
                apiVersion: ApiNetwork.apiVersion,
                customerId: customerId,
                model: request,
            );

        // 📋 Return the updated customer data
        return {
          "status": "success",
          "message": "Customer updated successfully",
          "customerId": customerId,
          "customer": updatedCustomer.toJson(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Generic error handling
        return {
          "status": "error",
          "message": "Failed to update customer: ${e.toString()}",
          "customerId": customerId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Update Customer API",
    };
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'Enter customer ID to update',
          ),
          const ApiField(
            name: 'metafield_key',
            label: 'Metafield Key',
            hint: 'Key for the metafield',
          ),
          const ApiField(
            name: 'metafield_value',
            label: 'Metafield Value',
            hint: 'Value for the metafield',
          ),
          const ApiField(
            name: 'metafield_type',
            label: 'Metafield Type',
            hint: 'Type for the metafield (default: single_line_text_field)',
          ),
          const ApiField(
            name: 'namespace',
            label: 'Namespace',
            hint: 'Namespace for the metafield (default: global)',
          ),
        ],
      };
}
