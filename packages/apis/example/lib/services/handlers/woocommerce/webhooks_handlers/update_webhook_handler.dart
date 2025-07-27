import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/webhooks/abstract/webhooks_service.dart';
import 'package:dio/dio.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'dart:convert';

class WooUpdateWebhookHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'webhook_id',
            label: 'Webhook ID',
            hint: 'Webhook ID to update (required)',
            isRequired: true,
          ),
          const ApiField(
            name: 'name',
            label: 'Name',
            hint: 'Webhook name (optional)',
            isRequired: false,
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
            hint: 'URL where webhook will be delivered (optional)',
            isRequired: false,
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
      // Validate required webhook_id parameter
      final webhookIdStr = params['webhook_id']?.toString() ?? '';
      final webhookId = int.tryParse(webhookIdStr);

      if (webhookId == null || webhookId <= 0) {
        return {
          'success': false,
          'message':
              'Valid webhook_id is required and must be a positive integer',
        };
      }

      // Parse API version
      final apiVersion = params['api_version']?.toString() ?? 'v3';

      // Create webhook data map
      final Map<String, dynamic> webhookData = {};

      // Parse optional parameters
      final name = params['name']?.toString()?.trim();
      final topic = params['topic']?.toString()?.trim();
      final deliveryUrl = params['delivery_url']?.toString()?.trim();
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
      if (name?.isNotEmpty == true) {
        webhookData['name'] = name;
      }
      if (topic?.isNotEmpty == true) {
        webhookData['topic'] = topic;
      }
      if (deliveryUrl?.isNotEmpty == true) {
        webhookData['delivery_url'] = deliveryUrl;
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

      print('✏️ Update Webhook Parameters:');
      print('  API Version: $apiVersion');
      print('  Webhook ID: $webhookId');
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
      final response = await service.updateWebhook(
        apiVersion: apiVersion,
        webhookId: webhookId,
        webhookData: webhookData,
      );

      print('✅ Update Webhook Success: ${response.toJson()}');

      return {
        'success': true,
        'message': 'Webhook updated successfully',
        'data': response.toJson(),
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to update webhook';

      if (e.response?.statusCode == 400) {
        errorMessage = 'Invalid webhook data provided';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Webhook not found';
      } else if (e.response?.statusCode == 409) {
        errorMessage = 'Webhook with this name or delivery URL already exists';
      } else if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message']?.toString() ?? errorMessage;
        }
      }

      print('❌ Update Webhook Error: $errorMessage');
      print('🔍 Full error: ${e.toString()}');

      return {
        'success': false,
        'message': errorMessage,
        'error_details': e.toString(),
      };
    } catch (e) {
      print('❌ Update Webhook Unexpected Error: ${e.toString()}');
      return {
        'success': false,
        'message': 'Unexpected error occurred while updating webhook',
        'error_details': e.toString(),
      };
    }
  }
}
