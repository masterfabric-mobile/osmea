import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/application_charge/abstract/application_charge_service.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/request/create_application_charge_request.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';

/// ******************************************************************
/// *************** 💵 CREATE AN APPLICATION CHARGE HANDLER 💵 ********
/// ******************************************************************

class CreateAnApplicationChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'POST') {
        // Parse input parameters
        debugPrint('🔍 Raw parameters received: $params');
        
        // Validate required parameters
        final name = params['name'] as String?;
        final priceStr = params['price'] as String?;
        final returnUrl = params['return_url'] as String?;
        
        if (name == null || name.isEmpty) {
          return {
            "status": "error",
            "message": "Name is required for creating an application charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (priceStr == null || priceStr.isEmpty) {
          return {
            "status": "error",
            "message": "Price is required for creating an application charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (returnUrl == null || returnUrl.isEmpty) {
          return {
            "status": "error",
            "message": "Return URL is required for creating an application charge",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Format price as string if it's a number
        String price = priceStr;
        if (priceStr.contains('.') == false) {
          price = "$priceStr.00"; // Ensure it has decimal places
        }
        
        // Parse optional parameters
        final testStr = params['test'] as String?;
        bool? test = testStr == null ? true : testStr.toLowerCase() == 'true'; // Default to true for test
        String? currency = params['currency'] as String? ?? 'USD'; // Default to USD
        
        debugPrint('🔧 Processed parameters - name: $name, price: $price, returnUrl: $returnUrl, test: $test, currency: $currency');
        debugPrint('🌐 API Version: ${ApiNetwork.apiVersion}');
        
        // Create the request object with only the necessary fields
        final request = CreateApplicationChargeRequest(
          applicationCharge: ApplicationCharge(
            name: name,
            price: price,
            returnUrl: returnUrl,
            test: test,
            currency: currency,
          ),
        );

        
        // Convert request to JSON for API call
        final requestJson = createApplicationChargeRequestToJson(request);
        debugPrint('📤 Request JSON: $requestJson');
        
        // Call the API service
        final service = GetIt.I.get<CreateApplicationChargeService>();
        final response = await service.createApplicationCharge(
          apiVersion: ApiNetwork.apiVersion,
          request: request,
        );
        
        // Access the applicationCharge property correctly and handle nullability
        final charge = response.applicationCharge;
        if (charge == null) {
          return {
            "status": "error",
            "message": "Failed to create application charge - no charge data in response",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Handle nullable confirmation URL
        final confirmationUrl = charge.confirmationUrl ?? "No confirmation URL provided";
        
        // Format the success response
        return {
          "status": "success",
          "message": "Application charge created successfully",
          "data": {
            "application_charge": charge.toJson(),
          },
          "next_steps": [
            "Redirect customer to: $confirmationUrl to approve the charge",
            "Customer will be redirected back to your return_url after approval/decline"
          ],
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      return {
        "status": "error",
        "message": "Method $method not supported. Use POST instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error creating application charge: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to create application charge: ${e.toString()}",
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
        hint: 'The name of the application charge (e.g., "Super Duper Expensive action")',
        isRequired: true,
      ),
      const ApiField(
        name: 'price',
        label: 'Price',
        hint: 'The price of the application charge (e.g., "100.00")',
        isRequired: true,
      ),
      const ApiField(
        name: 'return_url',
        label: 'Return URL',
        hint: 'The URL to redirect to after the charge is accepted/declined',
        isRequired: true,
      ),
      const ApiField(
        name: 'test',
        label: 'Test Mode',
        hint: 'Set to true for a test charge that won\'t be billed (default: true)',
        type: ApiFieldType.boolean,
        isRequired: false,
      ),
      const ApiField(
        name: 'currency',
        label: 'Currency',
        hint: 'The 3-letter currency code (e.g., USD, EUR, GBP) (default: USD)',
        isRequired: false,
      ),
    ],
  };
}