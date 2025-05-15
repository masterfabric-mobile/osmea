import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/application_credit/abstract/application_credit_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ************* 🔍 RETRIEVE AN APPLICATION CREDIT HANDLER 🔍 ********
/// ******************************************************************

class RetrieveAnApplicationCreditHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Get credit ID from params and validate
        final idStr = params['id'] as String?;
        final fieldsParam = params['fields'] as String?;
        
        if (idStr == null || idStr.isEmpty) {
          return {
            "status": "error",
            "message": "Application Credit ID is required",
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
            "message": "Invalid Application Credit ID: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (fieldsParam != null && fieldsParam.trim().isNotEmpty) {
          debugPrint('📌 Using direct API call for field filtering: fields=$fieldsParam, id=$id');
          return await _handleFieldFiltering(id, fieldsParam);
        } else {
          debugPrint('📌 Using standard model-based approach for ID=$id (no fields filtering)');
          return await _handleStandardRequest(id);
        }
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error fetching application credit: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to retrieve application credit: ${e.toString()}",
        "requestDetails": {
          "apiVersion": ApiNetwork.apiVersion,
          "id": params['id'],
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
        label: 'Application Credit ID',
        hint: 'ID of the specific application credit',
        isRequired: true,
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include (e.g., id,amount,description)',
        isRequired: false,
      ),
    ],
  };

  Future<Map<String, dynamic>> _handleFieldFiltering(int id, String fieldsParam) async {
    debugPrint('📌 Using direct API call for field filtering: fields=$fieldsParam');
  
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
  
    // Build URL with query parameters
    String url = '$baseUrl/api/$apiVersion/application_credits/$id.json?fields=$fieldsParam';
  
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
            "fields": fieldsParam,
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

  Future<Map<String, dynamic>> _handleStandardRequest(int id) async {
    final service = GetIt.I.get<GetApplicationCreditService>();
    final response = await service.getApplicationCredit(
      apiVersion: ApiNetwork.apiVersion,
      id: id,
    );
    
    final credit = response.applicationCredit;
    if (credit == null) {
      return {
        "status": "error",
        "message": "Application credit not found or no data returned",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
    
    return {
      "status": "success",
      "data": {
        "application_credit": credit.toJson()
      },
      "timestamp": DateTime.now().toIso8601String(),
    };
  }
}