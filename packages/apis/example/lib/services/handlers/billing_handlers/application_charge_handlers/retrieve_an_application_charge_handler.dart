import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/application_charge/abstract/application_charge_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';

/// ******************************************************************
/// ************* 🔍 RETRIEVE AN APPLICATION CHARGE HANDLER 🔍 ********
/// ******************************************************************

class RetrieveAnApplicationChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Get charge ID from params and validate
        final apiVersion = ApiNetwork.apiVersion;
        final idStr = params['id'] as String?;
        
        if (idStr == null || idStr.isEmpty) {
          return {
            "status": "error",
            "message": "Application Charge ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse the ID from string to int, with error handling
        int id;
        try {
          id = int.parse(idStr);
        } catch (e) {
          return {
            "status": "error",
            "message": "Invalid Application Charge ID: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Retrieve the application charge by ID
        final service = GetIt.I.get<GetApplicationChargeService>();
        final response = await service.getApplicationCharge(
          apiVersion: apiVersion,
          id: id, // Now properly parsed
        );
        
        final charge = response.applicationCharge;
        
        if (charge == null) {
          return {
            "status": "error",
            "message": "Application charge not found",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Format charge details for better readability
        final Map<String, dynamic> chargeDetails = {
          "id": charge.id,
          "name": charge.name,
          "price": charge.price,
          "status": charge.status,
          "returnUrl": charge.returnUrl,
          "confirmationUrl": charge.confirmationUrl,
          "test": charge.test,
          "createdAt": charge.createdAt,
          "updatedAt": charge.updatedAt,
          "currency": charge.currency,
        };
        
        return {
          "status": "success",
          "chargeDetails": chargeDetails,
          "responseData": response.toJson(),
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      String errorMessage = e.toString();
      int statusCode = 500;

      if (errorMessage.contains("status code of")) {
        final regex = RegExp(r"status code of (\d+)");
        final match = regex.firstMatch(errorMessage);
        if (match != null) {
          statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
        }
      }

      String troubleshootingTip = "";
      if (statusCode == 404) {
        troubleshootingTip = "Application charge not found. Verify the charge ID exists.";
      } else if (statusCode == 403) {
        troubleshootingTip = "This may be due to insufficient permissions. "
            "Ensure your API credentials have proper access to billing features.";
      } else if (statusCode == 401) {
        troubleshootingTip = 
            "Authentication failed. Check your API credentials and make sure they're valid.";
      } else {
        troubleshootingTip = 
            "An unexpected error occurred. Check connection and retry.";
      }

      return {
        "status": "error",
        "message": "Failed to fetch application charge: $errorMessage",
        "statusCode": statusCode,
        "troubleshooting": troubleshootingTip,
        "requestDetails": {
          "method": method,
          "chargeId": params['id'],
          "apiVersion": ApiNetwork.apiVersion,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'GET': [
      const ApiField(
        name: 'id',
        label: 'Application Charge ID',
        hint: 'ID of the specific application charge',
        isRequired: true,
      ),
    ],
  };
}