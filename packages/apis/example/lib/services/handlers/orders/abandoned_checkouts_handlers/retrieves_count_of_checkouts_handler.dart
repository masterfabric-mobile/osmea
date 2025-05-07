import 'package:apis/network/remote/orders/abandoned_checkouts/abstract/abandoned_checkouts.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';

class GetAbandonedCheckoutsCountHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? status = params['status'];
        final String? sinceId = params['since_id'];
        final String? createdAtMin = params['created_at_min'];
        final String? createdAtMax = params['created_at_max'];
        final String? updatedAtMin = params['updated_at_min'];
        final String? updatedAtMax = params['updated_at_max'];

        try {
          final countResponse = await GetIt.I
              .get<AbandonedCheckoutsService>()
              .getAbandonedCheckoutsCount(
                apiVersion: apiVersion,
                sinceId: sinceId,
                createdAtMin: createdAtMin,
                createdAtMax: createdAtMax,
                updatedAtMin: updatedAtMin,
                updatedAtMax: updatedAtMax,
                status: status,
              );

          final int count = countResponse.count ?? 0;

          return {
            "status": "success",
            "count": count,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error fetching abandoned checkouts count: $e");
          return {
            "status": "error",
            "message":
                "Failed to fetch abandoned checkouts count: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Abandoned Checkouts API",
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
            hint: 'Retrieve only results after the specified ID',
          ),
          const ApiField(
            name: 'created_at_min',
            label: 'Created At Min',
            hint: 'Retrieve results created after this date (ISO 8601)',
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created At Max',
            hint: 'Retrieve results created before this date (ISO 8601)',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated At Min',
            hint: 'Retrieve results updated after this date (ISO 8601)',
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated At Max',
            hint: 'Retrieve results updated before this date (ISO 8601)',
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint: 'Filter by status (e.g., abandoned)',
          ),
        ],
      };
}
