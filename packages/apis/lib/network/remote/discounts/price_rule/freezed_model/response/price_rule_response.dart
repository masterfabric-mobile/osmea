import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'price_rule_response.freezed.dart';
part 'price_rule_response.g.dart';

PriceRuleResponse priceRuleResponseFromJson(String str) =>
    PriceRuleResponse.fromJson(json.decode(str));

String priceRuleResponseToJson(PriceRuleResponse data) =>
    json.encode(data.toJson());

@freezed
class PriceRuleResponse with _$PriceRuleResponse {
  const factory PriceRuleResponse({
    @JsonKey(name: "price_rule") PriceRule? priceRule,
  }) = _PriceRuleResponse;

  factory PriceRuleResponse.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleResponseFromJson(json);
}

@freezed
class PriceRule with _$PriceRule {
  const factory PriceRule({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "value_type") String? valueType,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "customer_selection") String? customerSelection,
    @JsonKey(name: "target_type") String? targetType,
    @JsonKey(name: "target_selection") String? targetSelection,
    @JsonKey(name: "allocation_method") String? allocationMethod,
    @JsonKey(name: "allocation_limit") dynamic allocationLimit,
    @JsonKey(name: "once_per_customer") bool? oncePerCustomer,
    @JsonKey(name: "usage_limit") dynamic usageLimit,
    @JsonKey(name: "starts_at") String? startsAt,
    @JsonKey(name: "ends_at") dynamic endsAt,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "entitled_product_ids") List<dynamic>? entitledProductIds,
    @JsonKey(name: "entitled_variant_ids") List<dynamic>? entitledVariantIds,
    @JsonKey(name: "entitled_collection_ids")
    List<dynamic>? entitledCollectionIds,
    @JsonKey(name: "entitled_country_ids") List<dynamic>? entitledCountryIds,
    @JsonKey(name: "prerequisite_product_ids")
    List<dynamic>? prerequisiteProductIds,
    @JsonKey(name: "prerequisite_variant_ids")
    List<dynamic>? prerequisiteVariantIds,
    @JsonKey(name: "prerequisite_collection_ids")
    List<dynamic>? prerequisiteCollectionIds,
    @JsonKey(name: "customer_segment_prerequisite_ids")
    List<dynamic>? customerSegmentPrerequisiteIds,
    @JsonKey(name: "prerequisite_customer_ids")
    List<dynamic>? prerequisiteCustomerIds,
    @JsonKey(name: "prerequisite_subtotal_range")
    dynamic prerequisiteSubtotalRange,
    @JsonKey(name: "prerequisite_quantity_range")
    dynamic prerequisiteQuantityRange,
    @JsonKey(name: "prerequisite_shipping_price_range")
    dynamic prerequisiteShippingPriceRange,
    @JsonKey(name: "prerequisite_to_entitlement_quantity_ratio")
    PrerequisiteToEntitlementQuantityRatio?
        prerequisiteToEntitlementQuantityRatio,
    @JsonKey(name: "prerequisite_to_entitlement_purchase")
    PrerequisiteToEntitlementPurchase? prerequisiteToEntitlementPurchase,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
  }) = _PriceRule;

  factory PriceRule.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleFromJson(json);
}

@freezed
class PrerequisiteToEntitlementPurchase
    with _$PrerequisiteToEntitlementPurchase {
  const factory PrerequisiteToEntitlementPurchase({
    @JsonKey(name: "prerequisite_amount") dynamic prerequisiteAmount,
  }) = _PrerequisiteToEntitlementPurchase;

  factory PrerequisiteToEntitlementPurchase.fromJson(
          Map<String, dynamic> json) =>
      _$PrerequisiteToEntitlementPurchaseFromJson(json);
}

@freezed
class PrerequisiteToEntitlementQuantityRatio
    with _$PrerequisiteToEntitlementQuantityRatio {
  const factory PrerequisiteToEntitlementQuantityRatio({
    @JsonKey(name: "prerequisite_quantity") dynamic prerequisiteQuantity,
    @JsonKey(name: "entitled_quantity") dynamic entitledQuantity,
  }) = _PrerequisiteToEntitlementQuantityRatio;

  factory PrerequisiteToEntitlementQuantityRatio.fromJson(
          Map<String, dynamic> json) =>
      _$PrerequisiteToEntitlementQuantityRatioFromJson(json);
}
