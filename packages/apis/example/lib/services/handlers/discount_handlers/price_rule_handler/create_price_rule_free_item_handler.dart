import 'package:apis/apis.dart';
import 'package:apis/network/remote/discounts/price_rule/abstract/price_rule.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rule_free_item_request.dart'
    as create_request;
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/create_price_rule_free_item_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreatePriceRuleFreeItemHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? title = params['title'];
        final String valueType = 'percentage';
        final String value = '-100.0';
        final String? customerSelection = params['customer_selection'];
        final String? targetType = params['target_type'];
        final String? targetSelection = params['target_selection'];
        final String? allocationMethod = params['allocation_method'];
        final String? startsAt = params['starts_at'];
        final String? prerequisiteCollectionIdsStr =
            params['prerequisite_collection_ids'];
        final String? entitledProductIdsStr = params['entitled_product_ids'];
        final String? prerequisiteQuantityStr = params['prerequisite_quantity'];
        final String? entitledQuantityStr = params['entitled_quantity'];
        final String? allocationLimitStr = params['allocation_limit'];

        if (title == null ||
            title.isEmpty ||
            customerSelection == null ||
            customerSelection.isEmpty ||
            targetType == null ||
            targetType.isEmpty ||
            targetSelection == null ||
            targetSelection.isEmpty ||
            allocationMethod == null ||
            allocationMethod.isEmpty ||
            startsAt == null ||
            startsAt.isEmpty ||
            prerequisiteCollectionIdsStr == null ||
            prerequisiteCollectionIdsStr.isEmpty ||
            entitledProductIdsStr == null ||
            entitledProductIdsStr.isEmpty ||
            prerequisiteQuantityStr == null ||
            prerequisiteQuantityStr.isEmpty ||
            entitledQuantityStr == null ||
            entitledQuantityStr.isEmpty ||
            allocationLimitStr == null ||
            allocationLimitStr.isEmpty) {
          return {
            "status": "error",
            "message":
                "Title, Customer Selection, Target Type, Target Selection, Allocation Method, Starts At, Prerequisite Collection IDs, Entitled Product IDs, Prerequisite Quantity, Entitled Quantity, and Allocation Limit are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = create_request.CreatePriceRuleFreeItemRequest(
            priceRule: create_request.PriceRule(
              title: title,
              valueType: valueType,
              value: value,
              customerSelection: customerSelection,
              targetType: targetType,
              targetSelection: targetSelection,
              allocationMethod: allocationMethod,
              startsAt: startsAt,
              prerequisiteCollectionIds: prerequisiteCollectionIdsStr
                  .split(',')
                  .map((e) => int.parse(e.trim()))
                  .toList(),
              entitledProductIds: entitledProductIdsStr
                  .split(',')
                  .map((e) => int.parse(e.trim()))
                  .toList(),
              prerequisiteToEntitlementQuantityRatio:
                  create_request.PrerequisiteToEntitlementQuantityRatio(
                prerequisiteQuantity: int.parse(prerequisiteQuantityStr),
                entitledQuantity: int.parse(entitledQuantityStr),
              ),
              allocationLimit: int.parse(allocationLimitStr),
            ),
          );

          final CreatePriceRuleFreeItemResponse response =
              await GetIt.I.get<PriceRuleService>().createPriceRuleFreeItem(
                    apiVersion: apiVersion,
                    model: model,
                  );

          return {
            "status": "success",
            "message": "Buy X Get Y free item price rule created successfully",
            "price_rule": response.priceRule?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to create buy X get Y free item price rule: ${e.toString()}",
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
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'title',
            label: 'Title',
            hint: 'Enter the title of the price rule',
          ),
          const ApiField(
            name: 'customer_selection',
            label: 'Customer Selection',
            hint: 'Enter the customer selection (e.g., all)',
          ),
          const ApiField(
            name: 'target_type',
            label: 'Target Type',
            hint: 'Enter the target type (e.g., line_item)',
          ),
          const ApiField(
            name: 'target_selection',
            label: 'Target Selection',
            hint: 'Enter the target selection (e.g., entitled)',
          ),
          const ApiField(
            name: 'allocation_method',
            label: 'Allocation Method',
            hint: 'Enter the allocation method (e.g., each)',
          ),
          const ApiField(
            name: 'starts_at',
            label: 'Starts At',
            hint:
                'Enter the start date and time (e.g., 2025-05-10T10:00:00-04:00)',
          ),
          const ApiField(
            name: 'prerequisite_collection_ids',
            label: 'Prerequisite Collection IDs',
            hint:
                'Enter comma-separated IDs of collections whose products must be purchased (e.g., 123,456)',
          ),
          const ApiField(
            name: 'entitled_product_ids',
            label: 'Entitled Product IDs',
            hint:
                'Enter comma-separated IDs of products that will be offered for free (e.g., 789)',
          ),
          const ApiField(
            name: 'prerequisite_quantity',
            label: 'Prerequisite Quantity',
            hint:
                'Enter the number of prerequisite items that must be purchased (e.g., 2)',
          ),
          const ApiField(
            name: 'entitled_quantity',
            label: 'Entitled Quantity',
            hint: 'Enter the number of free items to give (e.g., 1)',
          ),
          const ApiField(
            name: 'allocation_limit',
            label: 'Allocation Limit',
            hint:
                'Enter the maximum number of times the discount can be applied in an order (e.g., 3)',
          ),
        ],
      };
}
