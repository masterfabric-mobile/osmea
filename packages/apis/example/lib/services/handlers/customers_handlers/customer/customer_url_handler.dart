import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/creates_account_activation_url_for_customer_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///************** 🔗 CUSTOMER URL API HANDLER 🔗 *******************
///*******************************************************************

class CustomerUrlHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle POST requests for customer URL generation
    if (method == 'POST') {
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
        // 📞 Call the customer service API to generate URL
        final response = await GetIt.I
            .get<CustomerService>()
            .createsAccountActivationUrlForCustomer(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
              model: CreatesAccountActivationUrlForCustomerRequest(),
            );

        // 📋 Return the activation URL data
        return {
          "status": "success",
          "customerId": customerId,
          "accountActivationUrl": response.accountActivationUrl,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Generic error handling
        return {
          "status": "error",
          "message": "Failed to generate customer URL: ${e.toString()}",
          "customerId": customerId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Customer URL API",
    };
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'Enter customer ID to generate account activation URL',
          ),
        ],
      };
}
