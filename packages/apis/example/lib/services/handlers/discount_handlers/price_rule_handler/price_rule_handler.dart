import 'package:apis/apis.dart';
import 'package:apis/network/remote/discounts/price_rule/abstract/price_rule.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rules_request.dart'
    as create_request;
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/update_price_rule_request.dart'
    as update_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class PriceRuleHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['id'];

        if (priceRuleId == null || priceRuleId.isEmpty) {
          return {
            "status": "error",
            "message": "Price Rule ID is required for GET request",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final PriceRuleResponse response =
              await GetIt.I.get<PriceRuleService>().singlePriceRule(
                    apiVersion: apiVersion,
                    priceRuleId: priceRuleId,
                  );
          return {
            "status": "success",
            "price_rule": response.priceRule?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to fetch price rule: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final String? valueType = params['value_type'];
        final String? value = params['value'];
        final String? customerSelection = params['customer_selection'];
        final String? targetType = params['target_type'];
        final String? targetSelection = params['target_selection'];
        final String? allocationMethod = params['allocation_method'];
        final dynamic allocationLimit = params['allocation_limit'];
        final bool oncePerCustomer =
            params['once_per_customer']?.toLowerCase() == 'true';
        final dynamic usageLimit = params['usage_limit'];
        final String? startsAt = params['starts_at'];
        final dynamic endsAt = params['ends_at'];
        final List<dynamic>? entitledProductIds = params['entitled_product_ids']
            ?.split(',')
            .map((e) => e.trim())
            .toList();
        final List<dynamic>? entitledVariantIds = params['entitled_variant_ids']
            ?.split(',')
            .map((e) => e.trim())
            .toList();
        final List<dynamic>? entitledCollectionIds =
            params['entitled_collection_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? entitledCountryIds = params['entitled_country_ids']
            ?.split(',')
            .map((e) => e.trim())
            .toList();
        final List<dynamic>? prerequisiteProductIds =
            params['prerequisite_product_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? prerequisiteVariantIds =
            params['prerequisite_variant_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? prerequisiteCollectionIds =
            params['prerequisite_collection_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? customerSegmentPrerequisiteIds =
            params['customer_segment_prerequisite_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? prerequisiteCustomerIds =
            params['prerequisite_customer_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final dynamic prerequisiteSubtotalRange =
            params['prerequisite_subtotal_range'];
        final dynamic prerequisiteQuantityRange =
            params['prerequisite_quantity_range'];
        final dynamic prerequisiteShippingPriceRange =
            params['prerequisite_shipping_price_range'];

        final String? title = params['title'];

        if (title == null ||
            title.isEmpty ||
            valueType == null ||
            valueType.isEmpty ||
            customerSelection == null ||
            customerSelection.isEmpty ||
            targetType == null ||
            targetType.isEmpty ||
            targetSelection == null ||
            targetSelection.isEmpty ||
            allocationMethod == null ||
            allocationMethod.isEmpty ||
            startsAt == null ||
            startsAt.isEmpty) {
          return {
            "status": "error",
            "message":
                "Title, Value Type, Customer Selection, Target Type, Target Selection, Allocation Method, and Starts At are required for POST request",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = create_request.CreatePriceRulesRequest(
            priceRule: create_request.PriceRule(
              valueType: valueType,
              value: value,
              customerSelection: customerSelection,
              targetType: targetType,
              targetSelection: targetSelection,
              allocationMethod: allocationMethod,
              allocationLimit: allocationLimit,
              oncePerCustomer: oncePerCustomer,
              usageLimit: usageLimit,
              startsAt: startsAt,
              endsAt: endsAt,
              entitledProductIds: entitledProductIds,
              entitledVariantIds: entitledVariantIds,
              entitledCollectionIds: entitledCollectionIds,
              entitledCountryIds: entitledCountryIds,
              prerequisiteProductIds: prerequisiteProductIds,
              prerequisiteVariantIds: prerequisiteVariantIds,
              prerequisiteCollectionIds: prerequisiteCollectionIds,
              customerSegmentPrerequisiteIds: customerSegmentPrerequisiteIds,
              prerequisiteCustomerIds: prerequisiteCustomerIds,
              prerequisiteSubtotalRange: prerequisiteSubtotalRange,
              prerequisiteQuantityRange: prerequisiteQuantityRange,
              prerequisiteShippingPriceRange: prerequisiteShippingPriceRange,
              title: title,
            ),
          );
          final PriceRuleResponse response =
              await GetIt.I.get<PriceRuleService>().createPriceRule(
                    apiVersion: apiVersion,
                    model: model,
                  );
          return {
            "status": "success",
            "message": "Price rule created successfully",
            "price_rule": response.priceRule?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to create price rule: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'PUT':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['id'];

        if (priceRuleId == null || priceRuleId.isEmpty) {
          return {
            "status": "error",
            "message": "Price Rule ID is required for PUT request",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        final String? title = params['title'];
        final String? valueType = params['value_type'];
        final String? value = params['value'];
        final String? customerSelection = params['customer_selection'];
        final String? targetType = params['target_type'];
        final String? targetSelection = params['target_selection'];
        final String? allocationMethod = params['allocation_method'];
        final dynamic allocationLimit = params['allocation_limit'];
        final bool oncePerCustomer =
            params['once_per_customer']?.toLowerCase() == 'true';
        final dynamic usageLimit = params['usage_limit'];
        final String? startsAt = params['starts_at'];
        final dynamic endsAt = params['ends_at'];
        final List<dynamic>? entitledProductIds = params['entitled_product_ids']
            ?.split(',')
            .map((e) => e.trim())
            .toList();
        final List<dynamic>? entitledVariantIds = params['entitled_variant_ids']
            ?.split(',')
            .map((e) => e.trim())
            .toList();
        final List<dynamic>? entitledCollectionIds =
            params['entitled_collection_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? entitledCountryIds = params['entitled_country_ids']
            ?.split(',')
            .map((e) => e.trim())
            .toList();
        final List<dynamic>? prerequisiteProductIds =
            params['prerequisite_product_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? prerequisiteVariantIds =
            params['prerequisite_variant_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? prerequisiteCollectionIds =
            params['prerequisite_collection_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? customerSegmentPrerequisiteIds =
            params['customer_segment_prerequisite_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final List<dynamic>? prerequisiteCustomerIds =
            params['prerequisite_customer_ids']
                ?.split(',')
                .map((e) => e.trim())
                .toList();
        final dynamic prerequisiteSubtotalRange =
            params['prerequisite_subtotal_range'];
        final dynamic prerequisiteQuantityRange =
            params['prerequisite_quantity_range'];
        final dynamic prerequisiteShippingPriceRange =
            params['prerequisite_shipping_price_range'];

        if (title == null || title.isEmpty) {
          return {
            "status": "error",
            "message": "Title is required for PUT request",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = update_request.UpdatePriceRuleRequest(
            priceRule: update_request.PriceRule(
              id: int.tryParse(priceRuleId),
              title: title,
              valueType: valueType,
              value: value,
              customerSelection: customerSelection,
              targetType: targetType,
              targetSelection: targetSelection,
              allocationMethod: allocationMethod,
              allocationLimit: allocationLimit,
              oncePerCustomer: oncePerCustomer,
              usageLimit: usageLimit,
              startsAt: startsAt,
              endsAt: endsAt,
              entitledProductIds: entitledProductIds,
              entitledVariantIds: entitledVariantIds,
              entitledCollectionIds: entitledCollectionIds,
              entitledCountryIds: entitledCountryIds,
              prerequisiteProductIds: prerequisiteProductIds,
              prerequisiteVariantIds: prerequisiteVariantIds,
              prerequisiteCollectionIds: prerequisiteCollectionIds,
              customerSegmentPrerequisiteIds: customerSegmentPrerequisiteIds,
              prerequisiteCustomerIds: prerequisiteCustomerIds,
              prerequisiteSubtotalRange: prerequisiteSubtotalRange,
              prerequisiteQuantityRange: prerequisiteQuantityRange,
              prerequisiteShippingPriceRange: prerequisiteShippingPriceRange,
            ),
          );
          final PriceRuleResponse response =
              await GetIt.I.get<PriceRuleService>().updatePriceRule(
                    apiVersion: apiVersion,
                    priceRuleId: priceRuleId,
                    model: model,
                  );
          return {
            "status": "success",
            "message": "Price rule updated successfully",
            "price_rule": response.priceRule?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to update price rule: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'DELETE':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? priceRuleId = params['id'];

        if (priceRuleId == null || priceRuleId.isEmpty) {
          return {
            "status": "error",
            "message": "Price Rule ID is required for DELETE request",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          await GetIt.I.get<PriceRuleService>().deletePriceRule(
                apiVersion: apiVersion,
                priceRuleId: priceRuleId,
              );
          return {
            "status": "success",
            "message": "Price rule deleted successfully",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to delete price rule: ${e.toString()}",
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
  List<String> get supportedMethods => ['GET', 'POST', 'PUT', 'DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'id',
            label: 'Price Rule ID',
            hint: 'Enter the ID of the price rule',
          ),
        ],
        'POST': [
          const ApiField(
            name: 'value_type',
            label: 'Value Type',
            hint: 'Enter the value type',
          ),
          const ApiField(
            name: 'customer_selection',
            label: 'Customer Selection',
            hint: 'Enter the customer selection',
          ),
          const ApiField(
            name: 'target_type',
            label: 'Target Type',
            hint: 'Enter the target type',
          ),
          const ApiField(
            name: 'target_selection',
            label: 'Target Selection',
            hint: 'Enter the target selection',
          ),
          const ApiField(
            name: 'allocation_method',
            label: 'Allocation Method',
            hint: 'Enter the allocation method',
          ),
          const ApiField(
            name: 'starts_at',
            label: 'Starts At',
            hint: 'Enter the start date',
          ),
          const ApiField(
            name: 'title',
            label: 'Title',
            hint: 'Enter the title of the price rule',
          ),
        ],
        'PUT': [
          const ApiField(
            name: 'id',
            label: 'Price Rule ID',
            hint: 'Enter the ID of the price rule to update',
          ),
          const ApiField(
            name: 'title',
            label: 'Title',
            hint: 'Enter the new title of the price rule',
          ),
          const ApiField(
            name: 'value_type',
            label: 'Value Type',
            hint: 'Enter the value type',
          ),
          const ApiField(
            name: 'value',
            label: 'Value',
            hint: 'Enter the value',
          ),
          const ApiField(
            name: 'customer_selection',
            label: 'Customer Selection',
            hint: 'Enter the customer selection',
          ),
          const ApiField(
            name: 'target_type',
            label: 'Target Type',
            hint: 'Enter the target type',
          ),
          const ApiField(
            name: 'target_selection',
            label: 'Target Selection',
            hint: 'Enter the target selection',
          ),
          const ApiField(
            name: 'allocation_method',
            label: 'Allocation Method',
            hint: 'Enter the allocation method',
          ),
          const ApiField(
            name: 'starts_at',
            label: 'Starts At',
            hint: 'Enter the start date',
          ),
        ],
        'DELETE': [
          const ApiField(
            name: 'id',
            label: 'Price Rule ID',
            hint: 'Enter the ID of the price rule to delete',
          ),
        ],
      };
}
