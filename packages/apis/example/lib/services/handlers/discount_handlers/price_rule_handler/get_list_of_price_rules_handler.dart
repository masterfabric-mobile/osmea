import 'package:apis/apis.dart';

import 'package:apis/network/remote/discounts/price_rule/abstract/price_rule.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_list_response.dart';

import 'package:example/services/api_request_handler.dart';

import 'package:example/services/api_service_registry.dart';

import 'package:get_it/get_it.dart';

class GetPriceRuleListHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final int? limit =
            params['limit'] != null ? int.tryParse(params['limit']!) : null;
        final String? sinceId = params['since_id'];
        final String? createdAtMin = params['created_at_min'];
        final String? createdAtMax = params['created_at_max'];
        final String? updatedAtMin = params['updated_at_min'];
        final String? updatedAtMax = params['updated_at_max'];
        final String? startAtMin = params['start_at_min'];
        final String? startAtMax = params['start_at_max'];

        try {
          final PriceRuleListResponse response =
              await GetIt.I.get<PriceRuleService>().getPriceRules(
                    apiVersion: apiVersion,
                    limit: limit,
                    sinceId: sinceId,
                    createdAtMin: createdAtMin,
                    createdAtMax: createdAtMax,
                    updatedAtMin: updatedAtMin,
                    updatedAtMax: updatedAtMax,
                    startAtMin: startAtMin,
                    startAtMax: startAtMax,
                  );

          return {
            "status": "success",
            "price_rules":
                response.priceRules?.map((rule) => rule.toJson()).toList() ??
                    [],
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to fetch price rule list: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Price Rule API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Number of results to retrieve',
          ),
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
            name: 'start_at_min',
            label: 'Start At Min',
            hint: 'Retrieve results starting after this date (ISO 8601)',
          ),
          const ApiField(
            name: 'start_at_max',
            label: 'Start At Max',
            hint: 'Retrieve results starting before this date (ISO 8601)',
          ),
        ]
      };
}
