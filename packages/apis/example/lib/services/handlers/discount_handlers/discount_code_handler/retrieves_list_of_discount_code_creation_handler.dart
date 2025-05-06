import 'package:apis/network/remote/discounts/discount_code/abstract/discount_code.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_list_creation_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:apis/apis.dart';
import 'package:get_it/get_it.dart';

class GetListDiscountCodeCreationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['price_rule_id'];
        final String? batchId = params['batch_id'];

        if (priceRuleId == null ||
            priceRuleId.isEmpty ||
            batchId == null ||
            batchId.isEmpty) {
          return {
            "status": "error",
            "message":
                "Price Rule ID and Batch ID are required to fetch discount codes for creation",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final DiscountCodeListCreationResponse response = await GetIt.I
              .get<DiscountCodeService>()
              .getListDiscountCodeCreations(
                apiVersion: apiVersion,
                priceRuleId: priceRuleId,
                batchId: batchId,
              );
          return {
            "status": "success",
            "discount_codes":
                response.discountCodes?.map((e) => e.toJson()).toList(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to fetch discount codes for creation: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Discount Codes Creation API",
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
            hint: 'Enter the Price Rule ID',
          ),
          const ApiField(
            name: 'batch_id',
            label: 'Batch ID',
            hint: 'Enter the Batch ID',
          ),
        ],
      };
}
