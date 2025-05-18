import 'package:apis/apis.dart';
import 'package:apis/network/remote/webhooks/webhook/abstract/webhook_service.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/request/update_webhook_request.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// ******************************************************************
/// ************* ✏️ UPDATE WEBHOOK HANDLER ✏️ **********************
/// ******************************************************************

class UpdateWebhookHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    try {
      if (method == 'PUT') {
        // Extract and validate required parameters
        final idStr = params['id'];
        final address = params['address'];
        
        if (idStr == null || idStr.trim().isEmpty) {
          return {
            "status": "error",
            "message": "Webhook ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        if (address == null || address.trim().isEmpty) {
          return {
            "status": "error",
            "message": "New address is required",
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
        
        // Create request model
        final webhookData = UpdateWebhookData(
          id: id,
          address: address,
        );
        
        final request = UpdateWebhookRequest(webhook: webhookData);
        
        return await _handleUpdateWebhook(id, request);
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use PUT instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to update webhook: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }
  
  Future<Map<String, dynamic>> _handleUpdateWebhook(int id, UpdateWebhookRequest request) async {
    debugPrint('✏️ Updating webhook with ID: $id to address: ${request.webhook.address}');
    
    try {
      final service = GetIt.I.get<UpdateWebhookService>();
      final response = await service.updateWebhook(
        apiVersion: ApiNetwork.apiVersion,
        id: id,
        request: request,
      );
      
      final webhook = response.webhook;
      if (webhook == null) {
        return {
          "status": "error",
          "message": "Failed to update webhook - no data returned",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
      
      debugPrint('✅ Successfully updated webhook with ID: ${webhook.id}');
      
      return {
        "status": "success",
        "message": "Webhook updated successfully",
        "data": {
          "webhook": webhook.toJson()
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error updating webhook: $e');
      
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
        "message": "Failed to update webhook: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
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
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'PUT': [
      const ApiField(
        name: 'id',
        label: 'Webhook ID',
        hint: 'ID of the webhook to update',
        isRequired: true,
        type: ApiFieldType.number,
      ),
      const ApiField(
        name: 'address',
        label: 'New Address',
        hint: 'New URL where the webhook should send the POST request',
        isRequired: true,
      ),
    ],
  };
}