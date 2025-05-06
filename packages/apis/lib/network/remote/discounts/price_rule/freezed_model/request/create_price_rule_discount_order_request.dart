import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_price_rule_discount_order_request.freezed.dart';
part 'create_price_rule_discount_order_request.g.dart';

CreatePriceRuleDiscountOrderRequest createPriceRuleDiscountOrderRequestFromJson(
        String str) =>
    CreatePriceRuleDiscountOrderRequest.fromJson(json.decode(str));

String createPriceRuleDiscountOrderRequestToJson(
        CreatePriceRuleDiscountOrderRequest data) =>
    json.encode(data.toJson());

@freezed
class CreatePriceRuleDiscountOrderRequest
    with _$CreatePriceRuleDiscountOrderRequest {
  const factory CreatePriceRuleDiscountOrderRequest({
    @JsonKey(name: "price_rule") PriceRule? priceRule,
  }) = _CreatePriceRuleDiscountOrderRequest;

  factory CreatePriceRuleDiscountOrderRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreatePriceRuleDiscountOrderRequestFromJson(json);
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
    @JsonKey(name: "customer_selection") String? customerSelection,
    @JsonKey(name: "starts_at") String? startsAt,
  }) = _PriceRule;

  factory PriceRule.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleFromJson(json);
}
