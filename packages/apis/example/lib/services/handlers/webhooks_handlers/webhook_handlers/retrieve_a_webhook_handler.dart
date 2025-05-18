import 'package:apis/apis.dart';
import 'package:apis/network/remote/webhooks/webhook/abstract/webhook_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ************* 🔍 RETRIEVE A WEBHOOK HANDLER 🔍 ********
/// ******************************************************************

class RetrieveAWebhookHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    try {
      if (method == 'GET') {
        // Get webhook ID from params and validate
        final idStr = params['id']?.isNotEmpty == true ? params['id'] : null;
        final fieldsParam = params['fields']?.isNotEmpty == true ? params['fields'] : null;
        
        if (idStr == null) {
          return {
            "status": "error",
            "message": "Webhook ID is required",
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
            "message": "Invalid Webhook ID: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // When fields parameter is provided, make a direct API call
        if (fieldsParam != null && fieldsParam.trim().isNotEmpty) {
          return await _handleFieldFiltering(id, fieldsParam);
        }
        
        // Standard path without field filtering
        return await _handleStandardRequest(id, fieldsParam);
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error fetching webhook: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to retrieve webhook: ${e.toString()}",
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
    String url = '$baseUrl/api/$apiVersion/webhooks/$id.json?fields=$fields';
    
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
      
      // Handle Dio errors with response data (Shopify error messages)
      if (e is DioException && e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;
        final statusCode = e.response!.statusCode;
        
        // Try to parse Shopify error messages
        if (responseData is Map && responseData.containsKey('errors')) {
          return {
            "status": "error",
            "statusCode": statusCode,
            "shopifyErrors": responseData['errors'],
            "message": "Shopify API Error: ${_formatShopifyErrors(responseData['errors'])}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Generic response error
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "API Error: ${e.message}",
          "responseData": responseData,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
      
      throw e;
    }
  }
  
  // Standard request using the model
  Future<Map<String, dynamic>> _handleStandardRequest(int id, String? fields) async {
    final service = GetIt.I.get<GetWebhookService>();
    
    // Only include fields if non-empty
    final response = await service.getWebhook(
      apiVersion: ApiNetwork.apiVersion,
      id: id,
      fields: fields?.trim().isNotEmpty == true ? fields : null,
    );
    
    final webhook = response.webhook;
    if (webhook == null) {
      return {
        "status": "error",
        "message": "Webhook not found or no data returned",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
    
    debugPrint('✅ Successfully retrieved webhook');
    
    return {
      "status": "success",
      "data": {
        "webhook": webhook.toJson()
      },
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  // Helper function to format Shopify errors
  String _formatShopifyErrors(dynamic errors) {
    if (errors is Map) {
      return errors.entries
          .map((entry) => "${entry.key}: ${entry.value}")
          .join(", ");
    } else if (errors is String) {
      return errors;
    } else {
      return errors.toString();
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'GET': [
      const ApiField(
        name: 'id',
        label: 'Webhook ID',
        hint: 'ID of the specific webhook',
        isRequired: true,
        type: ApiFieldType.number,
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include (e.g., id,address,topic)',
        isRequired: false,
      ),
    ],
  };
}