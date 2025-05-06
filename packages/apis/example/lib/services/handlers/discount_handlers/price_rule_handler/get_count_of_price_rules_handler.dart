import 'package:apis/network/remote/discounts/price_rule/abstract/price_rule.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_list_response.dart';
import 'package:apis/apis.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class GetPriceRuleCountHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        try {
          final PriceRuleListResponse response =
              await GetIt.I.get<PriceRuleService>().getPriceRules(
                    apiVersion: apiVersion,
                  );

          final int count = response.priceRules?.length ?? 0;

          return {
            "status": "success",
            "count": count,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to fetch price rule count: ${e.toString()}",
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
        'GET': [],
      };
}
