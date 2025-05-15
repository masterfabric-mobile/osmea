import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/usage_charge/abstract/usage_charge_service.dart';
import 'package:apis/network/remote/billing/usage_charge/freezed_model/request/create_usage_charge_request.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';

/// ******************************************************************
/// ************* 🆕 CREATE USAGE CHARGE HANDLER 🆕 ********
/// ******************************************************************

class CreateUsageChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'POST') {
        // Add debug logging at the start
        debugPrint('🔍 Processing create request: method=$method, params=$params');
        
        // Parse and validate required parameters
        final recurringApplicationChargeIdStr = params['recurring_application_charge_id'] as String?;
        final description = params['description'] as String?;
        final priceStr = params['price'] as String?;
        
        // Validate required parameters
        if (recurringApplicationChargeIdStr == null || recurringApplicationChargeIdStr.isEmpty) {
          return {
            "status": "error",
            "message": "Recurring Application Charge ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (description == null || description.isEmpty) {
          return {
            "status": "error",
            "message": "Description is required for usage charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (priceStr == null || priceStr.isEmpty) {
          return {
            "status": "error",
            "message": "Price is required for usage charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse IDs and numeric values
        int recurringApplicationChargeId;
        try {
          recurringApplicationChargeId = int.parse(recurringApplicationChargeIdStr);
        } catch (e) {
          return {
            "status": "error",
            "message": "Invalid Recurring Application Charge ID: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // We keep price as a string since the API expects a string price
        
        debugPrint('🆕 Creating usage charge for recurring application charge ID: $recurringApplicationChargeId');
        
        // Create request object
        final request = CreateUsageChargeRequest(
          usageCharge: UsageChargeData(
            description: description,
            price: priceStr,
          ),
        );
        
        // Call the API service
        final service = GetIt.I.get<CreateUsageChargeService>();
        final response = await service.createUsageCharge(
          apiVersion: ApiNetwork.apiVersion,
          recurringApplicationChargeId: recurringApplicationChargeId,
          request: request,
        );
        
        // Extract the created charge
        final charge = response.usageCharge;
        if (charge == null) {
          return {
            "status": "error",
            "message": "Failed to create usage charge - no data in response",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        debugPrint('✅ Successfully created usage charge with ID: ${charge.id}');
        
        // Format the success response
        return {
          "status": "success",
          "message": "Usage charge created successfully",
          "appliedFilters": {},  // Empty object for consistency with GET handlers
          "data": {
            "usage_charge": charge.toJson(),
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use POST instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error creating usage charge: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to create usage charge: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'POST': [
      const ApiField(
        name: 'recurring_application_charge_id',
        label: 'Recurring Application Charge ID',
        hint: 'ID of the recurring application charge',
        isRequired: true,
      ),
      const ApiField(
        name: 'description',
        label: 'Description',
        hint: 'Description of the usage charge (e.g., "Super Mega Plan 5000 emails")',
        isRequired: true,
      ),
      const ApiField(
        name: 'price',
        label: 'Price',
        hint: 'Price of the usage charge (e.g., "5.00")',
        isRequired: true,
      ),
    ],
  };
}