import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/system_status/abstract/system_status_service.dart';
import 'package:dio/dio.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

class RunToolFromSystemStatusHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'tool_id',
            label: 'Tool ID',
            hint: 'Tool ID to run (required)',
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

      print('🔧 Run Tool From System Status Parameters:');
      print('  API Version: $apiVersion');
      print('  Tool ID: $toolId');

      // Get service and call API
      final service = WooNetwork.getIt.get<SystemStatusService>();
      final response = await service.runToolFromSystemStatus(
        apiVersion: apiVersion,
        toolId: toolId,
      );

      print('✅ Run Tool From System Status Success: ${response.toJson()}');

      // Provide appropriate message based on success status
      String successMessage = 'System status tool executed successfully';
      if (response.success == true) {
        successMessage = 'System status tool executed successfully';
      } else if (response.success == false) {
        successMessage = 'System status tool execution failed';
      }

      return {
        'success': true,
        'message': successMessage,
        'data': response.toJson(),
        'tool_success': response.success,
        'tool_message': response.message,
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to run system status tool';

      if (e.response?.statusCode == 404) {
        errorMessage = 'System status tool not found';
      } else if (e.response?.statusCode == 400) {
        errorMessage = 'Invalid tool ID or tool cannot be executed';
      } else if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message']?.toString() ?? errorMessage;
        }
      }

      print('❌ Run Tool From System Status Error: $errorMessage');
      print('🔍 Full error: ${e.toString()}');

      return {
        'success': false,
        'message': errorMessage,
        'error_details': e.toString(),
      };
    } catch (e) {
      print('❌ Run Tool From System Status Unexpected Error: ${e.toString()}');
      return {
        'success': false,
        'message': 'Unexpected error occurred while running system status tool',
        'error_details': e.toString(),
      };
    }
  }
}
