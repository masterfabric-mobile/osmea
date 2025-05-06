import 'package:apis/apis.dart';
import 'package:apis/network/remote/discounts/price_rule/abstract/price_rule.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rule_discount_collection_request.dart'
    as create_request;
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/create_price_rule_discount_collection_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreatePriceRuleDiscountCollectionHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? title = params['title'];
        final String? targetType = params['target_type'];
        final String? targetSelection = params['target_selection'];
        final String? allocationMethod = params['allocation_method'];
        final String? valueType = params['value_type'];
        final String? value = params['value'];
        final String? customerSelection = params['customer_selection'];
        final String? startsAt = params['starts_at'];
        final String? entitledCollectionIdsStr =
            params['entitled_collection_ids'];

        if (title == null ||
            title.isEmpty ||
            targetType == null ||
            targetType.isEmpty ||
            targetSelection == null ||
            targetSelection.isEmpty ||
            allocationMethod == null ||
            allocationMethod.isEmpty ||
            valueType == null ||
            valueType.isEmpty ||
            value == null ||
            value.isEmpty ||
            customerSelection == null ||
            customerSelection.isEmpty ||
            startsAt == null ||
            startsAt.isEmpty) {
          return {
            "status": "error",
            "message":
                "Title, Target Type, Target Selection, Allocation Method, Value Type, Value, Customer Selection, and Starts At are required fields",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          List<int>? entitledCollectionIds;
          if (entitledCollectionIdsStr != null &&
              entitledCollectionIdsStr.isNotEmpty) {
            entitledCollectionIds = entitledCollectionIdsStr
                .split(',')
                .map((e) => int.tryParse(e.trim()))
                .where((e) => e != null)
                .cast<int>()
                .toList();
          }

          final model = create_request.CreatePriceRuleDiscountCollectionRequest(
            priceRule: create_request.PriceRule(
              title: title,
              targetType: targetType,
              targetSelection: targetSelection,
              allocationMethod: allocationMethod,
              valueType: valueType,
              value: value,
              customerSelection: customerSelection,
              entitledCollectionIds: entitledCollectionIds,
              startsAt: startsAt,
            ),
          );

          final CreatePriceRuleDiscountCollectionResponse response = await GetIt
              .I
              .get<PriceRuleService>()
              .createPriceRuleDiscountCollection(
                apiVersion: apiVersion,
                model: model,
              );

          return {
            "status": "success",
            "message":
                "Price rule and discount collection created successfully",
            "price_rule": response.priceRule?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error creating price rule and discount collection: $e");
          return {
            "status": "error",
            "message":
                "Failed to create price rule and discount collection: ${e.toString()}",
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
            name: 'target_type',
            label: 'Target Type',
            hint: 'Enter the target type (e.g., line_item)',
          ),
          const ApiField(
            name: 'target_selection',
            label: 'Target Selection',
            hint: 'Enter the target selection (e.g., all)',
          ),
          const ApiField(
            name: 'allocation_method',
            label: 'Allocation Method',
            hint: 'Enter the allocation method (e.g., across)',
          ),
          const ApiField(
            name: 'value_type',
            label: 'Value Type',
            hint: 'Enter the value type (e.g., fixed_amount)',
          ),
          const ApiField(
            name: 'value',
            label: 'Value',
            hint: 'Enter the discount value (e.g., -10.0)',
          ),
          const ApiField(
            name: 'customer_selection',
            label: 'Customer Selection',
            hint: 'Enter the customer selection (e.g., all)',
          ),
          const ApiField(
            name: 'starts_at',
            label: 'Starts At',
            hint:
                'Enter the start date and time (e.g., 2025-05-10T10:00:00-04:00)',
          ),
          const ApiField(
            name: 'entitled_collection_ids',
            label: 'Entitled Collection IDs',
            hint: 'Enter comma-separated entitled collection IDs (optional)',
          ),
        ],
      };
}
