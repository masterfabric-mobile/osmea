import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/usage_charge/abstract/usage_charge_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ************* 📋 RETRIEVE LIST OF USAGE CHARGES HANDLER 📋 ********
/// ******************************************************************

class RetrieveListOfUsageChargesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Add debug logging at the start
        debugPrint('🔍 Processing request: method=$method, params=$params');
        
        // Parse parameters
        final recurringApplicationChargeIdStr = params['recurring_application_charge_id'] as String?;
        final fieldsParam = params['fields'] as String?;
        
        if (recurringApplicationChargeIdStr == null || recurringApplicationChargeIdStr.isEmpty) {
          return {
            "status": "error",
            "message": "Recurring Application Charge ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse the ID from string to int
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
        
        // Explicitly check for both null AND empty/whitespace-only strings
        final hasFieldFilter = fieldsParam != null && fieldsParam.trim().isNotEmpty;
        
        debugPrint('🔧 Parameters: fields=$fieldsParam (hasFilter=$hasFieldFilter), recurring_application_charge_id=$recurringApplicationChargeId');
        
        // When fields parameter has an actual value, make a direct API call
        if (hasFieldFilter) {
          return await _handleFieldFiltering(recurringApplicationChargeId, fieldsParam.trim());
        }
        
        // Standard path without field filtering
        return await _handleStandardRequest(recurringApplicationChargeId);
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error fetching usage charges: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to retrieve usage charges: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  // Handle field filtering by making a direct API call
  Future<Map<String, dynamic>> _handleFieldFiltering(int recurringApplicationChargeId, String fields) async {
    debugPrint('📌 Using direct API call for field filtering: fields=$fields');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // Build URL with query parameters
    String url = '$baseUrl/api/$apiVersion/recurring_application_charges/$recurringApplicationChargeId/usage_charges.json?fields=$fields';
    
    debugPrint('🔗 Making request to: $url');
    
    // Make direct API call
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Shopify-Access-Token': shopifyToken,
          },
        ),
      );
      
      debugPrint('✅ Response status: ${response.statusCode}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        
        // Safely handle possibly null usage_charges
        final chargesList = data['usage_charges'] as List? ?? [];
        
        return {
          "status": "success",
          "appliedFilters": {
            "fields": fields,
          },
          "data": data,
          "count": chargesList.length,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } catch (e) {
      debugPrint('❌ Direct API error: $e');
      throw e;
    }
  }
  
  // Standard request using the model
  Future<Map<String, dynamic>> _handleStandardRequest(int recurringApplicationChargeId) async {
    debugPrint('📌 Using standard model-based approach');
    
    final service = GetIt.I.get<GetUsageChargesService>();
    
    try {
      final response = await service.getUsageCharges(
        apiVersion: ApiNetwork.apiVersion,
        recurringApplicationChargeId: recurringApplicationChargeId,
      );
      
      // Check if usageCharges is null - this is likely happening when there are no charges
      final charges = response.usageCharges ?? [];
      debugPrint('📊 Received ${charges.length} usage charges');
      
      return {
        "status": "success",
        "data": {
          "usage_charges": charges.map((c) => c.toJson()).toList()
        },
        "count": charges.length,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Provide more detailed error info for debugging
      debugPrint('❌ Model error: ${e.toString()}');
      
      // Handle the case where the model throws an error due to null response
      return {
        "status": "success",
        "data": {
          "usage_charges": []  // Return empty list instead of null
        },
        "count": 0,
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
        name: 'recurring_application_charge_id',
        label: 'Recurring Application Charge ID',
        hint: 'ID of the recurring application charge',
        isRequired: true,
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include (e.g., id,description,price)',
        isRequired: false,
      ),
    ],
  };
}