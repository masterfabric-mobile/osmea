import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class GetDraftOrderCountHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? sinceId = params['since_id'];
        final String? status = params['status'];
        final String? updatedAtMin = params['updated_at_min'];
        final String? updatedAtMax = params['updated_at_max'];

        try {
          final response =
              await GetIt.I.get<DraftOrderService>().getDraftOrderCount(
                    apiVersion: apiVersion,
                    since_id: sinceId,
                    status: status,
                    updated_at_min: updatedAtMin,
                    updated_at_max: updatedAtMax,
                  );

          final int count = response.count ?? 0;

          return {
            "status": "success",
            "count": count,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to fetch draft order count: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Draft Order Count API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'GET': [
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Restrict results to after the specified ID',
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint: 'Filter by status (e.g., open, completed)',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated At Min',
            hint:
                'Show draft orders updated after the specified date (ISO 8601)',
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated At Max',
            hint:
                'Show draft orders updated before the specified date (ISO 8601)',
          ),
        ],
      };
}
