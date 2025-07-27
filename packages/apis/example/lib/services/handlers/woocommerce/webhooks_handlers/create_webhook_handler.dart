import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/webhooks/abstract/webhooks_service.dart';
import 'package:dio/dio.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'dart:convert'; // Added missing import for json

class WooCreateWebhookHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'name',
            label: 'Name',
            hint: 'Webhook name (required)',
            isRequired: true,
          ),
          const ApiField(
            name: 'topic',
            label: 'Topic',
            hint: 'Webhook topic (e.g., order.created, product.updated)',
            isRequired: false,
          ),
          const ApiField(
            name: 'delivery_url',
            label: 'Delivery URL',
            hint: 'URL where webhook will be delivered (required)',
            isRequired: true,
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint: 'Webhook status (active, inactive)',
            isRequired: false,
          ),
          const ApiField(
            name: 'resource',
            label: 'Resource',
            hint: 'Resource type (e.g., order, product, customer)',
            isRequired: false,
          ),
          const ApiField(
            name: 'event',
            label: 'Event',
            hint: 'Event type (e.g., created, updated, deleted)',
            isRequired: false,
          ),
          const ApiField(
            name: 'hooks',
            label: 'Hooks',
            hint: 'Additional hooks (JSON array format)',
            isRequired: false,
          ),
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'WooCommerce API version (default: v3)',
            isRequired: false,
          ),
        ],
      };

  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, dynamic> params,
  ) async {
    try {
      // Validate required name parameter
      final name = params['name']?.toString()?.trim();
      if (name == null || name.isEmpty) {
        return {
          'success': false,
          'message': 'Name is required and cannot be empty',
        };
      }

      // Validate required delivery_url parameter
      final deliveryUrl = params['delivery_url']?.toString()?.trim();
      if (deliveryUrl == null || deliveryUrl.isEmpty) {
        return {
          'success': false,
          'message': 'Delivery URL is required and cannot be empty',
        };
      }

      // Parse API version
      final apiVersion = params['api_version']?.toString() ?? 'v3';

      // Create webhook data map
      final Map<String, dynamic> webhookData = {};

      // Add required fields
      webhookData['name'] = name;
      webhookData['delivery_url'] = deliveryUrl;

      // Parse optional parameters
      final topic = params['topic']?.toString()?.trim();
      final status = params['status']?.toString()?.trim();
      final resource = params['resource']?.toString()?.trim();
      final event = params['event']?.toString()?.trim();

      // Parse JSON parameter
      List<String>? hooks;
      if (params['hooks']?.toString().isNotEmpty == true) {
        try {
          final hooksJson = params['hooks'].toString();
          final hooksList = json.decode(hooksJson) as List;
          hooks = hooksList.cast<String>();
        } catch (e) {
          print('⚠️ Warning: Invalid hooks JSON format: ${e.toString()}');
        }
      }

      // Build webhook data
      if (topic?.isNotEmpty == true) {
        webhookData['topic'] = topic;
      }
      if (status?.isNotEmpty == true) {
        webhookData['status'] = status;
      }
      if (resource?.isNotEmpty == true) {
        webhookData['resource'] = resource;
      }
      if (event?.isNotEmpty == true) {
        webhookData['event'] = event;
      }
      if (hooks != null) {
        webhookData['hooks'] = hooks;
      }

      print('➕ Create Webhook Parameters:');
      print('  API Version: $apiVersion');
      print('  Name: $name');
      print('  Topic: $topic');
      print('  Delivery URL: $deliveryUrl');
      print('  Status: $status');
      print('  Resource: $resource');
      print('  Event: $event');
      print('  Hooks: $hooks');
      print('  Request body: $webhookData');

      // Get service and call API
      final service = WooNetwork.getIt.get<WebhooksService>();
      final response = await service.createWebhook(
        apiVersion: apiVersion,
        webhookData: webhookData,
      );

      print('✅ Create Webhook Success: ${response.toJson()}');

      return {
        'success': true,
        'message': 'Webhook created successfully',
        'data': response.toJson(),
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to create webhook';

      if (e.response?.statusCode == 400) {
        errorMessage = 'Invalid webhook data provided';
      } else if (e.response?.statusCode == 409) {
        errorMessage = 'Webhook with this name or delivery URL already exists';
      } else if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message']?.toString() ?? errorMessage;
        }
      }

      print('❌ Create Webhook Error: $errorMessage');
      print('🔍 Full error: ${e.toString()}');

      return {
        'success': false,
        'message': errorMessage,
        'error_details': e.toString(),
      };
    } catch (e) {
      print('❌ Create Webhook Unexpected Error: ${e.toString()}');
      return {
        'success': false,
        'message': 'Unexpected error occurred while creating webhook',
        'error_details': e.toString(),
      };
    }
  }
}
