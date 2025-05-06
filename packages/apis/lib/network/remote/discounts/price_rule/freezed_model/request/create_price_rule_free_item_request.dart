import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_price_rule_free_item_request.freezed.dart';
part 'create_price_rule_free_item_request.g.dart';

CreatePriceRuleFreeItemRequest createPriceRuleFreeItemRequestFromJson(
        String str) =>
    CreatePriceRuleFreeItemRequest.fromJson(json.decode(str));

String createPriceRuleFreeItemRequestToJson(
        CreatePriceRuleFreeItemRequest data) =>
    json.encode(data.toJson());

@freezed
class CreatePriceRuleFreeItemRequest with _$CreatePriceRuleFreeItemRequest {
  const factory CreatePriceRuleFreeItemRequest({
    @JsonKey(name: "price_rule") PriceRule? priceRule,
  }) = _CreatePriceRuleFreeItemRequest;

  factory CreatePriceRuleFreeItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePriceRuleFreeItemRequestFromJson(json);
}

@freezed
class PriceRule with _$PriceRule {
  const factory PriceRule({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "value_type") String? valueType,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "customer_selection") String? customerSelection,
    @JsonKey(name: "target_type") String? targetType,
    @JsonKey(name: "target_selection") String? targetSelection,
    @JsonKey(name: "allocation_method") String? allocationMethod,
    @JsonKey(name: "starts_at") String? startsAt,
    @JsonKey(name: "prerequisite_collection_ids")
    List<int>? prerequisiteCollectionIds,
    @JsonKey(name: "entitled_product_ids") List<int>? entitledProductIds,
    @JsonKey(name: "prerequisite_to_entitlement_quantity_ratio")
    PrerequisiteToEntitlementQuantityRatio?
        prerequisiteToEntitlementQuantityRatio,
    @JsonKey(name: "allocation_limit") int? allocationLimit,
  }) = _PriceRule;

  factory PriceRule.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleFromJson(json);
}

@freezed
class PrerequisiteToEntitlementQuantityRatio
    with _$PrerequisiteToEntitlementQuantityRatio {
  const factory PrerequisiteToEntitlementQuantityRatio({
    @JsonKey(name: "prerequisite_quantity") int? prerequisiteQuantity,
    @JsonKey(name: "entitled_quantity") int? entitledQuantity,
  }) = _PrerequisiteToEntitlementQuantityRatio;

  factory PrerequisiteToEntitlementQuantityRatio.fromJson(
          Map<String, dynamic> json) =>
      _$PrerequisiteToEntitlementQuantityRatioFromJson(json);
}
