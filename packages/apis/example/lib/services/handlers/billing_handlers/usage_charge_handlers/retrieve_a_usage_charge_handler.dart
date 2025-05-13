import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/usage_charge/abstract/usage_charge_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ************* 🔍 RETRIEVE A USAGE CHARGE HANDLER 🔍 ********
/// ******************************************************************

class RetrieveAUsageChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Add debug logging at the start
        debugPrint('🔍 Processing request: method=$method, params=$params');
        
        // Get charge IDs from params and validate
        final recurringApplicationChargeIdStr = params['recurring_application_charge_id'] as String?;
        final idStr = params['id'] as String?;
        final fieldsParam = params['fields'] as String?;
        
        if (recurringApplicationChargeIdStr == null || recurringApplicationChargeIdStr.isEmpty) {
          return {
            "status": "error",
            "message": "Recurring Application Charge ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (idStr == null || idStr.isEmpty) {
          return {
            "status": "error",
            "message": "Usage Charge ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse the IDs from string to int
        int recurringApplicationChargeId;
        int id;
        try {
          recurringApplicationChargeId = int.parse(recurringApplicationChargeIdStr);
          id = int.parse(idStr);
        } catch (e) {
          return {
            "status": "error",
            "message": "Invalid ID format: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Make the field filtering check more explicit for clarity
        final hasFieldFilter = fieldsParam != null && fieldsParam.trim().isNotEmpty;
        debugPrint('🔧 Parameters: fields=$fieldsParam (hasFilter=$hasFieldFilter), id=$id, recurring_application_charge_id=$recurringApplicationChargeId');
        
        if (hasFieldFilter) {
          return await _handleFieldFiltering(recurringApplicationChargeId, id, fieldsParam.trim());
        }
        
        // Standard path without field filtering
        return await _handleStandardRequest(recurringApplicationChargeId, id);
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error fetching usage charge: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to retrieve usage charge: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  // Handle field filtering by making a direct API call
  Future<Map<String, dynamic>> _handleFieldFiltering(int recurringApplicationChargeId, int id, String fields) async {
    debugPrint('📌 Using direct API call for field filtering: fields=$fields');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // Build URL with query parameters
    String url = '$baseUrl/api/$apiVersion/recurring_application_charges/$recurringApplicationChargeId/usage_charges/$id.json?fields=$fields';
    
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
        
        return {
          "status": "success",
          "appliedFilters": {
            "fields": fields,
          },
          "data": data,
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
  Future<Map<String, dynamic>> _handleStandardRequest(int recurringApplicationChargeId, int id) async {
    final service = GetIt.I.get<GetUsageChargeService>();
    final response = await service.getUsageCharge(
      apiVersion: ApiNetwork.apiVersion,
      recurringApplicationChargeId: recurringApplicationChargeId,
      id: id,
    );
    
    final charge = response.usageCharge;
    if (charge == null) {
      return {
        "status": "error",
        "message": "Usage charge not found or no data returned",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
    
    debugPrint('✅ Successfully retrieved usage charge');
    
    // REMOVE appliedFilters - match the pattern in application_credit handler
    return {
      "status": "success",
      "data": {
        "usage_charge": charge.toJson()
      },
      "timestamp": DateTime.now().toIso8601String(),
    };
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
        name: 'id',
        label: 'Usage Charge ID',
        hint: 'ID of the specific usage charge',
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