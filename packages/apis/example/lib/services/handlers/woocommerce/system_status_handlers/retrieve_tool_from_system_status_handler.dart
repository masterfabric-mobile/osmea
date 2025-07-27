import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/system_status/abstract/system_status_service.dart';
import 'package:dio/dio.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

class RetrieveToolFromSystemStatusHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'tool_id',
            label: 'Tool ID',
            hint: 'Tool ID to retrieve (required)',
            isRequired: true,
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
      // Validate required tool_id parameter
      final toolId = params['tool_id']?.toString()?.trim();
      if (toolId == null || toolId.isEmpty) {
        return {
          'success': false,
          'message': 'Tool ID is required and cannot be empty',
        };
      }

      // Parse API version
      final apiVersion = params['api_version']?.toString() ?? 'v3';

      print('🔧 Retrieve Tool From System Status Parameters:');
      print('  API Version: $apiVersion');
      print('  Tool ID: $toolId');

      // Get service and call API
      final service = WooNetwork.getIt.get<SystemStatusService>();
      final response = await service.retrieveToolFromSystemStatus(
        apiVersion: apiVersion,
        toolId: toolId,
      );

      print('✅ Retrieve Tool From System Status Success: ${response.toJson()}');

      return {
        'success': true,
        'message': 'System status tool retrieved successfully',
        'data': response.toJson(),
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to retrieve system status tool';

      if (e.response?.statusCode == 404) {
        errorMessage = 'System status tool not found';
      } else if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message']?.toString() ?? errorMessage;
        }
      }

      print('❌ Retrieve Tool From System Status Error: $errorMessage');
      print('🔍 Full error: ${e.toString()}');

      return {
        'success': false,
        'message': errorMessage,
        'error_details': e.toString(),
      };
    } catch (e) {
      print(
          '❌ Retrieve Tool From System Status Unexpected Error: ${e.toString()}');
      return {
        'success': false,
        'message':
            'Unexpected error occurred while retrieving system status tool',
        'error_details': e.toString(),
      };
    }
  }
}
