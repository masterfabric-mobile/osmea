import 'package:apis/apis.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:dio/dio.dart'; // Make sure this import is added
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';

/// ******************************************************************
/// ********** 📋 RETRIEVE LIST OF TENDER TRANSACTIONS HANDLER 📋 ****
/// ******************************************************************

class RetrieveListOfTenderTransactionsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    try {
      if (method == 'GET') {
        // Extract the valid parameters and filter out empty strings
        final limit = params['limit']?.isNotEmpty == true ? params['limit'] : null;
        final orderedBy = params['order']?.isNotEmpty == true ? params['order'] : null;
        final processedAt = params['processed_at']?.isNotEmpty == true ? params['processed_at'] : null;
        final processedAtMax = params['processed_at_max']?.isNotEmpty == true ? params['processed_at_max'] : null;
        final processedAtMin = params['processed_at_min']?.isNotEmpty == true ? params['processed_at_min'] : null;
        final sinceId = params['since_id']?.isNotEmpty == true ? params['since_id'] : null;
        
        return await _handleStandardRequest(
          limit: limit != null ? int.tryParse(limit) : null,
          order: orderedBy,
          processedAt: processedAt,
          processedAtMax: processedAtMax,
          processedAtMin: processedAtMin,
          sinceId: sinceId != null ? int.tryParse(sinceId) : null,
        );
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
        "message": "Failed to fetch tender transactions: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleStandardRequest({
    int? limit,
    String? order,
    String? processedAt,
    String? processedAtMax,
    String? processedAtMin,
    int? sinceId,
  }) async {
    debugPrint('📌 Using direct API call approach to avoid empty parameters');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // Start building URL with no query parameters
    String url = '$baseUrl/api/$apiVersion/tender_transactions.json';
    
    // Create a map of query parameters, only including non-null values
    final Map<String, dynamic> queryParams = {};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (order != null && order.trim().isNotEmpty) queryParams['order'] = order;
    if (processedAt != null && processedAt.trim().isNotEmpty) queryParams['processed_at'] = processedAt;
    if (processedAtMax != null && processedAtMax.trim().isNotEmpty) queryParams['processed_at_max'] = processedAtMax;
    if (processedAtMin != null && processedAtMin.trim().isNotEmpty) queryParams['processed_at_min'] = processedAtMin;
    if (sinceId != null) queryParams['since_id'] = sinceId.toString();
    
    // Only add the query string if we have parameters
    if (queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');
      url = '$url?$queryString';
    }
    
    debugPrint('🔗 Making request to: $url');
    
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
          "data": data,
          "count": (data['tender_transactions'] as List?)?.length ?? 0,
          "appliedFilters": queryParams,
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
      
      // Generic error
      return {
        "status": "error",
        "message": "Failed to fetch tender transactions: ${e.toString()}",
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
        name: 'limit',
        label: 'Limit',
        hint: 'Maximum number of results to retrieve (max 250, default 50)',
        isRequired: false,
      ),
      const ApiField(
        name: 'order',
        label: 'Order',
        hint: 'Show tender transactions ordered by processed_at (asc or desc)',
        isRequired: false,
      ),
      const ApiField(
        name: 'processed_at',
        label: 'Processed At',
        hint: 'Show tender transactions processed at the specified date (ISO format)',
        isRequired: false,
      ),
      const ApiField(
        name: 'processed_at_max',
        label: 'Processed At Max',
        hint: 'Show tender transactions processed at or before the specified date',
        isRequired: false,
      ),
      const ApiField(
        name: 'processed_at_min',
        label: 'Processed At Min',
        hint: 'Show tender transactions processed at or after the specified date',
        isRequired: false,
      ),
      const ApiField(
        name: 'since_id',
        label: 'Since ID',
        hint: 'Retrieve only transactions after the specified ID',
        isRequired: false,
      ),
    ],
  };
  
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
}