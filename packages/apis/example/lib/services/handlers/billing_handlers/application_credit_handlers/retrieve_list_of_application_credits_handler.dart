import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/application_credit/abstract/application_credit_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ********** 📋 RETRIEVE LIST OF APPLICATION CREDITS HANDLER 📋 ****
/// ******************************************************************

class RetrieveListOfApplicationCreditsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Parse parameters
        final fieldsParam = params['fields'] as String?;
        
        // CRITICAL FIX: Check explicitly both for null AND empty string
        if (fieldsParam != null && fieldsParam.trim().isNotEmpty) {
          debugPrint('📌 Using direct API call for field filtering: fields=$fieldsParam');
          return await _handleFieldFiltering(fieldsParam);
        } else {
          debugPrint('📌 Using standard model-based approach (no fields filtering)');
          return await _handleStandardRequest();
        }
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
        "message": "Failed to fetch application credits: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }
  
  // APPROACH 1: Handle field filtering by making a direct API call
  Future<Map<String, dynamic>> _handleFieldFiltering(String fields) async {
    debugPrint('📌 Using direct API call for field filtering: fields=$fields');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // Build URL with query parameters - removed since_id
    String url = '$baseUrl/api/$apiVersion/application_credits.json?fields=$fields';
    
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
          "count": (data['application_credits'] as List?)?.length ?? 0,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } catch (e) {
      debugPrint('❌ Direct API error: $e');
      throw e;  // Re-throw to be caught by the outer handler
    }
  }
  
  // APPROACH 2: Standard request using the model
  Future<Map<String, dynamic>> _handleStandardRequest() async {
    debugPrint('📌 Using standard model-based approach');
    
    final service = GetIt.I.get<GetApplicationCreditsService>();
    final response = await service.getApplicationCredits(
      apiVersion: ApiNetwork.apiVersion,
    );
    
    return {
      "status": "success",
      "data": {
        "application_credits": response.applicationCredits?.map((c) => c.toJson()).toList() ?? []
      },
      "count": response.applicationCredits?.length ?? 0,
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
        hint: 'Comma-separated list of fields to include (e.g., id,amount,description)',
        isRequired: false,
      ),
    ],
  };
}