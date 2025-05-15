import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/abstract/recurring_application_charge_service.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/customize_recurring_application_charge_request.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';

/// ******************************************************************
/// ************* 🔧 CUSTOMIZE RECURRING APPLICATION CHARGE HANDLER 🔧 ********
/// ******************************************************************

class CustomizeRecurringApplicationChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'PUT') {
        // Get charge ID and capped_amount from params and validate
        final idStr = params['id'] as String?;
        final cappedAmountStr = params['capped_amount'] as String?;
        
        // Validate ID
        if (idStr == null || idStr.isEmpty) {
          return {
            "status": "error",
            "message": "Recurring Application Charge ID is required",
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
            "message": "Invalid Recurring Application Charge ID: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Validate capped_amount
        if (cappedAmountStr == null || cappedAmountStr.isEmpty) {
          return {
            "status": "error",
            "message": "Capped Amount is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        debugPrint('🔧 Customizing recurring application charge ID $id with capped_amount=$cappedAmountStr');
        
        // Create the request object
        final request = CustomizeRecurringApplicationChargeRequest(
          recurringApplicationCharge: {
            "capped_amount": cappedAmountStr,
          },
        );
        
        // Call the API service
        final service = GetIt.I.get<CustomizeRecurringApplicationChargeService>();
        final response = await service.customizeRecurringApplicationCharge(
          apiVersion: ApiNetwork.apiVersion,
          id: id,
          request: request,
        );
        
        // Extract the updated charge data
        final charge = response.recurringApplicationCharge;
        if (charge == null) {
          return {
            "status": "error",
            "message": "Failed to customize recurring application charge - no data in response",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        debugPrint('✅ Successfully customized recurring application charge');
        
        // Format the success response
        return {
          "status": "success",
          "message": "Recurring application charge customized successfully",
          "data": {
            "recurring_application_charge": charge.toJson(),
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use PUT instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error customizing recurring application charge: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to customize recurring application charge: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'PUT': [
      const ApiField(
        name: 'id',
        label: 'Recurring Application Charge ID',
        hint: 'ID of the specific recurring application charge',
        isRequired: true,
      ),
      const ApiField(
        name: 'capped_amount',
        label: 'Capped Amount',
        hint: 'The new capped amount for the charge (e.g., "100.00")',
        isRequired: true,
      ),
    ],
  };
}