import 'package:apis/network/remote/discounts/discount_code/abstract/discount_code.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/request/create_discount_code_request.dart'
    as request;
import 'package:apis/network/remote/discounts/discount_code/freezed_model/request/update_discount_code_request.dart'
    as update_request;
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:apis/apis.dart';
import 'package:get_it/get_it.dart';

class DiscountCodeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['price_rule_id'];
        final String? discountCodeId = params['id'];

        if (priceRuleId == null ||
            priceRuleId.isEmpty ||
            discountCodeId == null ||
            discountCodeId.isEmpty) {
          return {
            "status": "error",
            "message": "Price Rule ID and Discount Code ID are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final DiscountCodeResponse? response =
              await GetIt.I.get<DiscountCodeService>().getSingleDiscountCode(
                    apiVersion: apiVersion,
                    priceRuleId: priceRuleId,
                    discountCodeId: discountCodeId,
                  );

          if (response?.discountCode != null) {
            return {
              "status": "success",
              "discount_code": response!.discountCode!.toJson(),
              "timestamp": DateTime.now().toIso8601String(),
            };
          } else {
            return {
              "status": "error",
              "message":
                  "Discount code not found with ID: $discountCodeId and Price Rule ID: $priceRuleId",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
        } catch (e) {
          print("Error fetching single discount code: $e");
          return {
            "status": "error",
            "message": "Failed to fetch discount code: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'POST':
        final String priceRuleId = params['price_rule_id'] ?? '';
        final String? code = params['code'];

        if (priceRuleId.isEmpty || code == null || code.isEmpty) {
          return {
            "status": "error",
            "message":
                "Price Rule ID and Discount Code are required for single creation",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final DiscountCodeResponse response =
              await GetIt.I.get<DiscountCodeService>().createDiscountCode(
                    apiVersion: ApiNetwork.apiVersion,
                    priceRuleId: priceRuleId,
                    model: request.CreateDiscountCodeRequest(
                      discountCode: request.DiscountCode(code: code),
                    ),
                  );
          return {
            "status": "success",
            "message": "Discount code created successfully",
            "discount_code": response.discountCode!.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error creating single discount code: $e");
          return {
            "status": "error",
            "message": "Failed to create single discount code: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'PUT':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['price_rule_id'];
        final String? discountCodeId = params['id'];

        if (priceRuleId == null ||
            priceRuleId.isEmpty ||
            discountCodeId == null ||
            discountCodeId.isEmpty) {
          return {
            "status": "error",
            "message":
                "Price Rule ID and Discount Code ID are required for update",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          // Assuming the update data (code, usage_count) is passed in the params map
          final String? code = params['code'];
          final String? usageCountStr = params['usage_count'];
          int? usageCount =
              usageCountStr != null ? int.tryParse(usageCountStr) : null;

          final updateModel = update_request.UpdateDiscountCodeRequest(
            // Use alias here
            discountCode: update_request.DiscountCode(
              // Use alias here
              id: int.tryParse(discountCodeId),
              code: code,
              usageCount: usageCount,
            ),
          );

          final DiscountCodeResponse response =
              await GetIt.I.get<DiscountCodeService>().updateDiscountCode(
                    apiVersion: apiVersion,
                    priceRuleId: priceRuleId,
                    discountCodeId: discountCodeId,
                    model: updateModel, // Pass updateModel directly
                  );

          return {
            "status": "success",
            "message": "Discount code updated successfully",
            "discount_code": response.discountCode?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error updating discount code: $e");
          return {
            "status": "error",
            "message": "Failed to update discount code: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'DELETE':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['price_rule_id'];
        final String? discountCodeId = params['id'];

        if (priceRuleId == null ||
            priceRuleId.isEmpty ||
            discountCodeId == null ||
            discountCodeId.isEmpty) {
          return {
            "status": "error",
            "message":
                "Price Rule ID and Discount Code ID are required for deletion",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          await GetIt.I.get<DiscountCodeService>().deleteDiscountCode(
                apiVersion: apiVersion,
                priceRuleId: priceRuleId,
                discountCodeId: discountCodeId,
              );
          return {
            "status": "success",
            "message": "Discount code deleted successfully",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error deleting discount code: $e");
          return {
            "status": "error",
            "message": "Failed to delete discount code: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Discount Code API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET', 'POST', 'PUT', 'DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'price_rule_id',
            label: 'Price Rule ID',
            hint: 'Enter the Price Rule ID',
          ),
          const ApiField(
            name: 'id',
            label: 'Discount Code ID',
            hint: 'Enter the ID of the discount code to fetch',
          ),
        ],
        'POST': [
          const ApiField(
            name: 'price_rule_id',
            label: 'Price Rule ID',
            hint: 'Enter the Price Rule ID',
          ),
          const ApiField(
            name: 'code',
            label: 'Discount Code',
            hint: 'Enter the discount code to create',
          ),
        ],
        'PUT': [
          const ApiField(
            name: 'price_rule_id',
            label: 'Price Rule ID',
            hint: 'Enter the Price Rule ID',
          ),
          const ApiField(
            name: 'id',
            label: 'Discount Code ID',
            hint: 'Enter the ID of the discount code to update',
          ),
          const ApiField(
            name: 'code',
            label: 'Discount Code',
            hint: 'Enter the new discount code (optional)',
          ),
          const ApiField(
            name: 'usage_count',
            label: 'Usage Count',
            hint: 'Enter the new usage count (optional)',
          ),
        ],
        'DELETE': [
          const ApiField(
            name: 'price_rule_id',
            label: 'Price Rule ID',
            hint: 'Enter the Price Rule ID',
          ),
          const ApiField(
            name: 'id',
            label: 'Discount Code ID',
            hint: 'Enter the ID of the discount code to delete',
          ),
        ],
      };
}
