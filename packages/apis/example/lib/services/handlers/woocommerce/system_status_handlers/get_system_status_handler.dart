import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/system_status/abstract/system_status_service.dart';
import 'package:dio/dio.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

class GetSystemStatusHandler implements ApiRequestHandler {
  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
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

      print('🔍 Get System Status Parameters:');
      print('  API Version: $apiVersion');

      // Get service and call API
      final service = WooNetwork.getIt.get<SystemStatusService>();
      final response = await service.getSystemStatus(
        apiVersion: apiVersion,
      );

      print('✅ Get System Status Success: ${response.toJson()}');

      return {
        'success': true,
        'message': 'System status retrieved successfully',
        'data': response.toJson(),
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to retrieve system status';

      if (e.response?.statusCode == 404) {
        errorMessage = 'System status not found';
      } else if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message']?.toString() ?? errorMessage;
        }
      }

      print('❌ Get System Status Error: $errorMessage');
      print('🔍 Full error: ${e.toString()}');

      return {
        'success': false,
        'message': errorMessage,
        'error_details': e.toString(),
      };
    } catch (e) {
      print('❌ Get System Status Unexpected Error: ${e.toString()}');
      return {
        'success': false,
        'message': 'Unexpected error occurred while retrieving system status',
        'error_details': e.toString(),
      };
    }
  }
}
