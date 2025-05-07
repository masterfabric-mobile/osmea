import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/abandoned_checkouts/abstract/abandoned_checkouts.dart';
import 'package:apis/network/remote/orders/abandoned_checkouts/freezed_model/response/abandoned_checkouts_list_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class GetAbandonedCheckoutsListHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? status =
            'abandoned'; // We are specifically fetching abandoned checkouts
        final String? sinceId = params['since_id'];
        final String? createdAtMin = params['created_at_min'];
        final String? createdAtMax = params['created_at_max'];
        final String? updatedAtMin = params['updated_at_min'];
        final String? updatedAtMax = params['updated_at_max'];
        final int? limit =
            params['limit'] != null ? int.tryParse(params['limit']!) : null;

        try {
          // Assuming you have an AbandonedCheckoutsService with a method to get abandoned checkouts
          final AbandonedCheckoutsListResponse response = await GetIt.I
              .get<AbandonedCheckoutsService>()
              .getAbandonedCheckoutsList(
                apiVersion: apiVersion,
                status: status,
                sinceId: sinceId,
                createdAtMin: createdAtMin,
                createdAtMax: createdAtMax,
                updatedAtMin: updatedAtMin,
                updatedAtMax: updatedAtMax,
                limit: limit,
              );

          return {
            "status": "success",
            "checkouts": response.checkouts
                    ?.map((checkout) => checkout.toJson())
                    .toList() ??
                [],
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error fetching abandoned checkouts: $e");
          return {
            "status": "error",
            "message": "Failed to fetch abandoned checkouts: ${e.toString()}",
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
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Number of results to retrieve',
          ),
        ],
      };
}
