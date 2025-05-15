import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/abstract/recurring_application_charge_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ********** 📋 RETRIEVE LIST OF RECURRING APPLICATION CHARGES HANDLER 📋 ****
/// ******************************************************************

class RetrieveListOfRecurringApplicationChargesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Parse parameters
        final fieldsParam = params['fields'] as String?;
        final sinceId = params['since_id'] as String?;
        
        debugPrint('🔧 Parameters: fields=$fieldsParam, since_id=$sinceId');
        
        // When fields parameter is provided, make a direct API call
        if (fieldsParam != null && fieldsParam.trim().isNotEmpty) {
          return await _handleFieldFiltering(fieldsParam, sinceId);
        }
        
        // Normal path without field filtering
        return await _handleStandardRequest(sinceId);
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to fetch recurring application charges: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }
  
  // Handle field filtering by making a direct API call
  Future<Map<String, dynamic>> _handleFieldFiltering(String fields, String? sinceId) async {
    debugPrint('📌 Using direct API call for field filtering: fields=$fields');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // BUILD URL PROPERLY - only include parameters with actual values
    String url = '$baseUrl/api/$apiVersion/recurring_application_charges.json?fields=$fields';
  
    // Only add since_id if it has a valid value
    if (sinceId != null && sinceId.trim().isNotEmpty) {
      url += '&since_id=$sinceId';
    }
    
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
            "since_id": sinceId,
          },
          "data": data,
          "count": (data['recurring_application_charges'] as List?)?.length ?? 0,
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
  Future<Map<String, dynamic>> _handleStandardRequest(String? sinceId) async {
    debugPrint('📌 Using standard model-based approach');
    
    final service = GetIt.I.get<GetRecurringApplicationChargesService>();
    
    // Only pass sinceId if it has a real value
    final response = await service.getRecurringApplicationCharges(
      apiVersion: ApiNetwork.apiVersion,
      sinceId: (sinceId != null && sinceId.trim().isNotEmpty) ? sinceId : null,
    );
    
    debugPrint('📊 Received ${response.recurringApplicationCharges?.length ?? 0} charges');
    
    return {
      "status": "success",
      "appliedFilters": {
        "fields": null,
        "since_id": sinceId,
      },
      "data": {
        "recurring_application_charges": response.recurringApplicationCharges?.map((c) => c.toJson()).toList() ?? []
      },
      "count": response.recurringApplicationCharges?.length ?? 0,
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'GET': [
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include (e.g., id,name,price)',
        isRequired: false,
      ),
      const ApiField(
        name: 'since_id',
        label: 'Since ID',
        hint: 'Show charges after this ID (for pagination)',
        isRequired: false,
      ),
    ],
  };
}