import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/abstract/recurring_application_charge_service.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/create_trial_recurring_application_charge_request.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';

/// ******************************************************************
/// ************* 🆕 CREATE TRIAL RECURRING APPLICATION CHARGE HANDLER 🆕 ********
/// ******************************************************************

class CreateTrialRecurringApplicationChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'POST') {
        // Parse and validate required parameters
        final name = params['name'] as String?;
        final priceStr = params['price'] as String?;
        final returnUrl = params['return_url'] as String?;
        final trialDaysStr = params['trial_days'] as String?;
        
        // Validate required parameters
        if (name == null || name.isEmpty) {
          return {
            "status": "error",
            "message": "Name is required for recurring application charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (priceStr == null || priceStr.isEmpty) {
          return {
            "status": "error",
            "message": "Price is required for recurring application charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (returnUrl == null || returnUrl.isEmpty) {
          return {
            "status": "error",
            "message": "Return URL is required for recurring application charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (trialDaysStr == null || trialDaysStr.isEmpty) {
          return {
            "status": "error",
            "message": "Trial days is required for trial recurring application charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse price
        double price;
        try {
          price = double.parse(priceStr);
        } catch (e) {
          return {
            "status": "error",
            "message": "Invalid price format: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse trial days
        int trialDays;
        try {
          trialDays = int.parse(trialDaysStr);
        } catch (e) {
          return {
            "status": "error",
            "message": "Invalid trial_days format: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse optional parameters
        final testStr = params['test'] as String?;
        bool? test = testStr != null ? testStr.toLowerCase() == 'true' : null;
        
        debugPrint('🆕 Creating recurring application charge with trial period: $trialDays days');
        
        // Create request object
        final request = CreateTrialRecurringApplicationChargeRequest(
          recurringApplicationCharge: TrialRecurringApplicationChargeData(
            name: name,
            price: price,
            returnUrl: returnUrl,
            trialDays: trialDays,
            test: test,
          ),
        );
        
        // Call the API service
        final service = GetIt.I.get<CreateTrialRecurringApplicationChargeService>();
        final response = await service.createTrialRecurringApplicationCharge(
          apiVersion: ApiNetwork.apiVersion,
          request: request,
        );
        
        // Extract the created charge
        final charge = response.recurringApplicationCharge;
        if (charge == null) {
          return {
            "status": "error",
            "message": "Failed to create trial recurring application charge - no data in response",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        debugPrint('✅ Successfully created trial recurring application charge with ID: ${charge.id}');
        
        // Format the success response
        return {
          "status": "success",
          "message": "Trial recurring application charge created successfully",
          "data": {
            "recurring_application_charge": charge.toJson(),
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
      debugPrint('❌ Error creating trial recurring application charge: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to create trial recurring application charge: ${e.toString()}",
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
        name: 'name',
        label: 'Name',
        hint: 'Name of the recurring charge',
        isRequired: true,
      ),
      const ApiField(
        name: 'price',
        label: 'Price',
        hint: 'Price of the recurring charge (e.g., "10.00")',
        isRequired: true,
      ),
      const ApiField(
        name: 'return_url',
        label: 'Return URL',
        hint: 'URL where the merchant will be redirected after accepting/declining the charge',
        isRequired: true,
      ),
      const ApiField(
        name: 'trial_days',
        label: 'Trial Days',
        hint: 'Number of days for the trial period',
        isRequired: true,
      ),
      const ApiField(
        name: 'test',
        label: 'Test Mode',
        hint: 'Set to "true" for a test charge (no real billing)',
        type: ApiFieldType.boolean,
        isRequired: false,
      ),
    ],
  };
}