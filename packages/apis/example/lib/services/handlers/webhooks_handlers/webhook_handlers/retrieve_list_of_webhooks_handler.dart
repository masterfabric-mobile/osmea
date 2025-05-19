import 'package:apis/apis.dart';
import 'package:apis/network/remote/webhooks/webhook/abstract/webhook_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ********** 📋 RETRIEVE LIST OF WEBHOOKS HANDLER 📋 ****
/// ******************************************************************

class RetrieveListOfWebhooksHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    try {
      if (method == 'GET') {
        // Parse parameters
        final fieldsParam = params['fields']?.isNotEmpty == true ? params['fields'] : null;
        final address = params['address']?.isNotEmpty == true ? params['address'] : null;
        final topic = params['topic']?.isNotEmpty == true ? params['topic'] : null;
        final sinceId = params['since_id']?.isNotEmpty == true ? params['since_id'] : null;
        final createdAtMin = params['created_at_min']?.isNotEmpty == true ? params['created_at_min'] : null;
        final createdAtMax = params['created_at_max']?.isNotEmpty == true ? params['created_at_max'] : null;
        final updatedAtMin = params['updated_at_min']?.isNotEmpty == true ? params['updated_at_min'] : null;
        final updatedAtMax = params['updated_at_max']?.isNotEmpty == true ? params['updated_at_max'] : null;
        final limitStr = params['limit']?.isNotEmpty == true ? params['limit'] : null;
        
        // Parse limit to integer if provided
        int? limit;
        if (limitStr != null) {
          limit = int.tryParse(limitStr);
        }
        
        debugPrint('🔧 Parameters: fields=$fieldsParam, address=$address, topic=$topic, since_id=$sinceId');
        
        // When fields parameter is provided, make a direct API call
        if (fieldsParam != null && fieldsParam.trim().isNotEmpty) {
          return await _handleFieldFiltering(fieldsParam, address, topic, sinceId, 
            createdAtMin, createdAtMax, updatedAtMin, updatedAtMax, limit);  // Add limit here
        }
        
        // Normal path without field filtering
        return await _handleStandardRequest(address, topic, sinceId, 
          createdAtMin, createdAtMax, updatedAtMin, updatedAtMax, limit, fieldsParam);  // Add limit here
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
        "message": "Failed to fetch webhooks: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }
  
  // Handle field filtering by making a direct API call
  Future<Map<String, dynamic>> _handleFieldFiltering(
      String fields, String? address, String? topic, String? sinceId,
      String? createdAtMin, String? createdAtMax, String? updatedAtMin, String? updatedAtMax,
      int? limit) async {  // Added limit parameter
    debugPrint('📌 Using direct API call for field filtering: fields=$fields');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // Start building URL with no query parameters
    String url = '$baseUrl/api/$apiVersion/webhooks.json';
    
    // Create a map of query parameters, only including non-null values
    final Map<String, dynamic> queryParams = {};
    if (fields.trim().isNotEmpty) queryParams['fields'] = fields;
    if (address != null && address.trim().isNotEmpty) queryParams['address'] = address;
    if (topic != null && topic.trim().isNotEmpty) queryParams['topic'] = topic;
    if (sinceId != null && sinceId.trim().isNotEmpty) queryParams['since_id'] = sinceId;
    if (createdAtMin != null && createdAtMin.trim().isNotEmpty) queryParams['created_at_min'] = createdAtMin;
    if (createdAtMax != null && createdAtMax.trim().isNotEmpty) queryParams['created_at_max'] = createdAtMax;
    if (updatedAtMin != null && updatedAtMin.trim().isNotEmpty) queryParams['updated_at_min'] = updatedAtMin;
    if (updatedAtMax != null && updatedAtMax.trim().isNotEmpty) queryParams['updated_at_max'] = updatedAtMax;
    if (limit != null) queryParams['limit'] = limit.toString();  // Add this line
    
    // Only add the query string if we have parameters
    if (queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');
      url = '$url?$queryString';
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
          "appliedFilters": queryParams,
          "data": data,
          "count": (data['webhooks'] as List?)?.length ?? 0,
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
  Future<Map<String, dynamic>> _handleStandardRequest(
      String? address, String? topic, String? sinceId,
      String? createdAtMin, String? createdAtMax, String? updatedAtMin, String? updatedAtMax,
      int? limit, String? fields) async {  // Added limit parameter
    debugPrint('📌 Using standard model-based approach');
    
    final service = GetIt.I.get<GetWebhooksService>();
    
    // Only pass non-empty parameters
    final response = await service.getWebhooks(
      apiVersion: ApiNetwork.apiVersion,
      address: address?.trim().isNotEmpty == true ? address : null,
      topic: topic?.trim().isNotEmpty == true ? topic : null,
      since_id: sinceId?.trim().isNotEmpty == true ? sinceId : null,
      created_at_min: createdAtMin?.trim().isNotEmpty == true ? createdAtMin : null,
      created_at_max: createdAtMax?.trim().isNotEmpty == true ? createdAtMax : null,
      updated_at_min: updatedAtMin?.trim().isNotEmpty == true ? updatedAtMin : null,
      updated_at_max: updatedAtMax?.trim().isNotEmpty == true ? updatedAtMax : null,
      limit: limit,
      fields: fields?.trim().isNotEmpty == true ? fields : null,
    );
    
    debugPrint('📊 Received ${response.webhooks?.length ?? 0} webhooks');
    
    return {
      "status": "success",
      "appliedFilters": {
        if (address != null) "address": address,
        if (topic != null) "topic": topic,
        if (sinceId != null) "since_id": sinceId,
        if (createdAtMin != null) "created_at_min": createdAtMin,
        if (createdAtMax != null) "created_at_max": createdAtMax,
        if (updatedAtMin != null) "updated_at_min": updatedAtMin,
        if (updatedAtMax != null) "updated_at_max": updatedAtMax,
        if (limit != null) "limit": limit.toString(),  // Add this line
      },
      "data": {
        "webhooks": response.webhooks?.map((c) => c.toJson()).toList() ?? []
      },
      "count": response.webhooks?.length ?? 0,
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
        name: 'address',
        label: 'Address',
        hint: 'Filter webhooks by address',
        isRequired: false,
      ),
      const ApiField(
        name: 'topic',
        label: 'Topic',
        hint: 'Filter webhooks by topic (e.g., orders/create)',
        isRequired: false,
      ),
      const ApiField(
        name: 'created_at_min',
        label: 'Created At Min',
        hint: 'Show webhooks created after this date (ISO format)',
        isRequired: false,
      ),
      const ApiField(
        name: 'created_at_max',
        label: 'Created At Max',
        hint: 'Show webhooks created before this date (ISO format)',
        isRequired: false,
      ),
      const ApiField(
        name: 'updated_at_min',
        label: 'Updated At Min',
        hint: 'Show webhooks updated after this date (ISO format)',
        isRequired: false,
      ),
      const ApiField(
        name: 'updated_at_max',
        label: 'Updated At Max',
        hint: 'Show webhooks updated before this date (ISO format)',
        isRequired: false,
      ),
      const ApiField(
        name: 'since_id',
        label: 'Since ID',
        hint: 'Show webhooks after this ID (for pagination)',
        isRequired: false,
        type: ApiFieldType.number,
      ),
      const ApiField(
        name: 'limit',
        label: 'Limit',
        hint: 'Maximum number of webhooks to return (default: 50)',
        isRequired: false,
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