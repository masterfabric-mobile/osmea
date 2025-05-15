import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/abstract/recurring_application_charge_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ************* 🔍 RETRIEVE A RECURRING APPLICATION CHARGE HANDLER 🔍 ********
/// ******************************************************************

class RetrieveARecurringApplicationChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Get charge ID from params and validate
        final idStr = params['id'] as String?;
        final fieldsParam = params['fields'] as String?;
        
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
        
        // When fields parameter is provided, make a direct API call
        if (fieldsParam != null && fieldsParam.trim().isNotEmpty) {
          return await _handleFieldFiltering(id, fieldsParam);
        }
        
        // Standard path without field filtering
        return await _handleStandardRequest(id);
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error fetching recurring application charge: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to retrieve recurring application charge: ${e.toString()}",
        "requestDetails": {
          "apiVersion": ApiNetwork.apiVersion,
          "id": params['id'],
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  // Handle field filtering by making a direct API call
  Future<Map<String, dynamic>> _handleFieldFiltering(int id, String fields) async {
    debugPrint('📌 Using direct API call for field filtering: fields=$fields');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // Build URL with query parameters
    String url = '$baseUrl/api/$apiVersion/recurring_application_charges/$id.json?fields=$fields';
    
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
  Future<Map<String, dynamic>> _handleStandardRequest(int id) async {
    final service = GetIt.I.get<GetRecurringApplicationChargeService>();
    final response = await service.getRecurringApplicationCharge(
      apiVersion: ApiNetwork.apiVersion,
      id: id,
    );
    
    final charge = response.recurringApplicationCharge;
    if (charge == null) {
      return {
        "status": "error",
        "message": "Recurring application charge not found or no data returned",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
    
    debugPrint('✅ Successfully retrieved recurring application charge');
    
    return {
      "status": "success",
      "data": {
        "recurring_application_charge": charge.toJson()
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
        name: 'id',
        label: 'Recurring Application Charge ID',
        hint: 'ID of the specific recurring application charge',
        isRequired: true,
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include (e.g., id,name,price)',
        isRequired: false,
      ),
    ],
  };
}