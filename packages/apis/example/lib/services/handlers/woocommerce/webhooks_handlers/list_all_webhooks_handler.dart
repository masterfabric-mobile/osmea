import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/webhooks/abstract/webhooks_service.dart';
import 'package:dio/dio.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

class ListAllWebhooksHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'context',
            label: 'Context',
            hint: 'Scope under which the request is made (view, edit)',
            isRequired: false,
          ),
          const ApiField(
            name: 'page',
            label: 'Page',
            hint: 'Current page of the collection (default: 1)',
            isRequired: false,
          ),
          const ApiField(
            name: 'per_page',
            label: 'Per Page',
            hint: 'Maximum number of items to be returned (default: 10)',
            isRequired: false,
          ),
          const ApiField(
            name: 'search',
            label: 'Search',
            hint: 'Limit results to those matching a string',
            isRequired: false,
          ),
          const ApiField(
            name: 'exclude',
            label: 'Exclude',
            hint: 'Ensure result set excludes specific IDs (comma-separated)',
            isRequired: false,
          ),
          const ApiField(
            name: 'include',
            label: 'Include',
            hint: 'Limit result set to specific IDs (comma-separated)',
            isRequired: false,
          ),
          const ApiField(
            name: 'order',
            label: 'Order',
            hint: 'Order sort attribute ascending or descending (asc, desc)',
            isRequired: false,
          ),
          const ApiField(
            name: 'orderby',
            label: 'Order By',
            hint:
                'Sort collection by object attribute (date, id, include, title, slug)',
            isRequired: false,
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint:
                'Limit result set to webhooks with specific status (active, inactive)',
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
      // Parse API version
      final apiVersion = params['api_version']?.toString() ?? 'v3';

      // Parse optional parameters
      final context = params['context']?.toString();
      final search = params['search']?.toString();
      final order = params['order']?.toString();
      final orderby = params['orderby']?.toString();
      final status = params['status']?.toString();

      // Parse integer parameters
      int? page;
      if (params['page'] != null) {
        page = int.tryParse(params['page'].toString());
      }

      int? perPage;
      if (params['per_page'] != null) {
        perPage = int.tryParse(params['per_page'].toString());
      }

      // Parse comma-separated lists
      List<int>? exclude;
      if (params['exclude']?.toString().isNotEmpty == true) {
        exclude = params['exclude']
            .toString()
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .where((e) => e != null)
            .cast<int>()
            .toList();
      }

      List<int>? include;
      if (params['include']?.toString().isNotEmpty == true) {
        include = params['include']
            .toString()
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .where((e) => e != null)
            .cast<int>()
            .toList();
      }

      print('📋 List All Webhooks Parameters:');
      print('  API Version: $apiVersion');
      print('  Context: $context');
      print('  Page: $page');
      print('  Per Page: $perPage');
      print('  Search: $search');
      print('  Exclude: $exclude');
      print('  Include: $include');
      print('  Order: $order');
      print('  Order By: $orderby');
      print('  Status: $status');

      // Get service and call API
      final service = WooNetwork.getIt.get<WebhooksService>();
      final response = await service.listAllWebhooks(
        apiVersion: apiVersion,
        context: context,
        page: page,
        perPage: perPage,
        search: search,
        exclude: exclude,
        include: include,
        order: order,
        orderby: orderby,
        status: status,
      );

      print('✅ List All Webhooks Success: Found ${response.length} webhooks');

      return {
        'success': true,
        'data': response.map((webhook) => webhook.toJson()).toList(),
        'message': 'Webhooks retrieved successfully',
        'count': response.length,
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to retrieve webhooks';

      if (e.response?.statusCode == 400) {
        errorMessage = 'Invalid parameters provided';
      } else if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message']?.toString() ?? errorMessage;
        }
      }

      print('❌ List All Webhooks Error: $errorMessage');
      print('🔍 Full error: ${e.toString()}');

      return {
        'success': false,
        'message': errorMessage,
        'error_details': e.toString(),
      };
    } catch (e) {
      print('❌ List All Webhooks Unexpected Error: ${e.toString()}');
      return {
        'success': false,
        'message': 'Unexpected error occurred while retrieving webhooks',
        'error_details': e.toString(),
      };
    }
  }
}
