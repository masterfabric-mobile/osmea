import 'package:apis/apis.dart';
import 'package:apis/network/remote/webhooks/webhook/abstract/webhook_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';

/// ******************************************************************
/// ************* 🔢 RETRIEVE COUNT OF WEBHOOKS HANDLER 🔢 ********
/// ******************************************************************

class RetrieveCountOfWebhooksHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    try {
      if (method == 'GET') {
        // Parse parameters
        final address = params['address']?.isNotEmpty == true ? params['address'] : null;
        final topic = params['topic']?.isNotEmpty == true ? params['topic'] : null;
        
        return await _handleStandardRequest(address, topic);
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
        "message": "Failed to fetch webhook count: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }
  
  // Standard request using the model
  Future<Map<String, dynamic>> _handleStandardRequest(String? address, String? topic) async {
    debugPrint('📌 Using standard model-based approach');
    
    final service = GetIt.I.get<GetWebhooksCountService>();
    
    final response = await service.getWebhooksCount(
      apiVersion: ApiNetwork.apiVersion,
      address: address?.trim().isNotEmpty == true ? address : null,
      topic: topic?.trim().isNotEmpty == true ? topic : null,
    );
    
    debugPrint('📊 Received count: ${response.count}');
    
    return {
      "status": "success",
      "appliedFilters": {
        if (address != null) "address": address,
        if (topic != null) "topic": topic,
      },
      "data": {
        "count": response.count
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
        name: 'address',
        label: 'Address',
        hint: 'Filter count by webhook address',
        isRequired: false,
      ),
      const ApiField(
        name: 'topic',
        label: 'Topic',
        hint: 'Filter count by webhook topic (e.g., orders/create)',
        isRequired: false,
      ),
    ],
  };
}