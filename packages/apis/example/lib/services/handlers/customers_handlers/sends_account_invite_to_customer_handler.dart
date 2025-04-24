import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/sends_account_invite_to_customer_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';

///*******************************************************************
///************** 📧 CUSTOMER INVITE API HANDLER 📧 ****************
///*******************************************************************

class SendsAccountInviteToCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle POST requests for sending customer invites
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
        // Extract optional parameters
        final subject = params['subject'];
        final customMessage = params['custom_message'];

        // 🔄 Create request model for account invite with optional parameters
        final request = SendsAccountInviteToCustomerRequest(
          customerInvite: CustomerInvite(
            subject: subject,
            customMessage: customMessage,
          ),
        );

        // 📞 Call the customer service API to send invite
        await GetIt.I.get<CustomerService>().sendsAccountInviteToCustomer(
              apiVersion: ApiNetwork.apiVersion,
              customerId: customerId,
              model: request,
            );

        // 📋 Return success response
        return {
          "status": "success",
          "message": "Account invitation sent successfully",
          "customerId": customerId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Generic error handling
        return {
          "status": "error",
          "message": "Failed to send account invitation: ${e.toString()}",
          "customerId": customerId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Customer Invite API",
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
            hint: 'Enter customer ID to send account invitation',
          ),
          const ApiField(
            name: 'subject',
            label: 'Email Subject',
            hint: 'Optional custom subject for invitation email',
          ),
          const ApiField(
            name: 'custom_message',
            label: 'Custom Message',
            hint: 'Optional custom message for invitation email',
          ),
        ],
      };
}
