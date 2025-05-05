import 'package:apis/network/remote/discounts/discount_code/abstract/discount_code.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_list_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:apis/apis.dart';
import 'package:get_it/get_it.dart';

class GetListDiscountCodesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['price_rule_id'];

        if (priceRuleId == null || priceRuleId.isEmpty) {
          return {
            "status": "error",
            "message": "Price Rule ID is required to fetch discount codes",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final DiscountCodeListResponse response =
              await GetIt.I.get<DiscountCodeService>().getListDiscountCodes(
                    apiVersion: apiVersion,
                    priceRuleId: priceRuleId,
                  );
          return {
            "status": "success",
            "discount_codes":
                response.discountCodes?.map((e) => e.toJson()).toList(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error fetching discount codes by price rule: $e");
          return {
            "status": "error",
            "message":
                "Failed to fetch discount codes by price rule: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Discount Codes API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'price_rule_id',
            label: 'Price Rule ID',
            hint: 'Enter the Price Rule ID to fetch discount codes for',
          ),
        ],
      };
}
