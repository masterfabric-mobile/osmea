import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_price_rule_discount_collection_request.freezed.dart';
part 'create_price_rule_discount_collection_request.g.dart';

CreatePriceRuleDiscountCollectionRequest
    createPriceRuleDiscountCollectionRequestFromJson(String str) =>
        CreatePriceRuleDiscountCollectionRequest.fromJson(json.decode(str));

String createPriceRuleDiscountCollectionRequestToJson(
        CreatePriceRuleDiscountCollectionRequest data) =>
    json.encode(data.toJson());

@freezed
class CreatePriceRuleDiscountCollectionRequest
    with _$CreatePriceRuleDiscountCollectionRequest {
  const factory CreatePriceRuleDiscountCollectionRequest({
    @JsonKey(name: "price_rule") PriceRule? priceRule,
  }) = _CreatePriceRuleDiscountCollectionRequest;

  factory CreatePriceRuleDiscountCollectionRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreatePriceRuleDiscountCollectionRequestFromJson(json);
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
    @JsonKey(name: "entitled_collection_ids") List<int>? entitledCollectionIds,
    @JsonKey(name: "starts_at") String? startsAt,
  }) = _PriceRule;

  factory PriceRule.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleFromJson(json);
}
