// To parse this JSON data, do
//
//     final createPriceRuleFreeShippingRequest = createPriceRuleFreeShippingRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_price_rule_free_shipping_request.freezed.dart';
part 'create_price_rule_free_shipping_request.g.dart';

CreatePriceRuleFreeShippingRequest createPriceRuleFreeShippingRequestFromJson(
        String str) =>
    CreatePriceRuleFreeShippingRequest.fromJson(json.decode(str));

String createPriceRuleFreeShippingRequestToJson(
        CreatePriceRuleFreeShippingRequest data) =>
    json.encode(data.toJson());

@freezed
class CreatePriceRuleFreeShippingRequest
    with _$CreatePriceRuleFreeShippingRequest {
  const factory CreatePriceRuleFreeShippingRequest({
    @JsonKey(name: "price_rule") PriceRule? priceRule,
  }) = _CreatePriceRuleFreeShippingRequest;

  factory CreatePriceRuleFreeShippingRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreatePriceRuleFreeShippingRequestFromJson(json);
}

@freezed
class PriceRule with _$PriceRule {
  const factory PriceRule({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "target_type") String? targetType,
    @JsonKey(name: "target_selection") String? targetSelection,
    @JsonKey(name: "allocation_method") String? allocationMethod,
    @JsonKey(name: "value_type") String? valueType,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "usage_limit") int? usageLimit,
    @JsonKey(name: "customer_selection") String? customerSelection,
    @JsonKey(name: "prerequisite_subtotal_range")
    PrerequisiteSubtotalRange? prerequisiteSubtotalRange,
    @JsonKey(name: "starts_at") String? startsAt,
  }) = _PriceRule;

  factory PriceRule.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleFromJson(json);
}

@freezed
class PrerequisiteSubtotalRange with _$PrerequisiteSubtotalRange {
  const factory PrerequisiteSubtotalRange({
    @JsonKey(name: "greater_than_or_equal_to") String? greaterThanOrEqualTo,
  }) = _PrerequisiteSubtotalRange;

  factory PrerequisiteSubtotalRange.fromJson(Map<String, dynamic> json) =>
      _$PrerequisiteSubtotalRangeFromJson(json);
}
