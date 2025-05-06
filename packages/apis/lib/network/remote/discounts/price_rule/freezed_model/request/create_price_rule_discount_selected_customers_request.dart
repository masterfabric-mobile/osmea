import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_price_rule_discount_selected_customers_request.freezed.dart';
part 'create_price_rule_discount_selected_customers_request.g.dart';

CreatePriceRuleDiscountSelectedCustomersRequest
    createPriceRuleDiscountSelectedCustomersRequestFromJson(String str) =>
        CreatePriceRuleDiscountSelectedCustomersRequest.fromJson(
            json.decode(str));

String createPriceRuleDiscountSelectedCustomersRequestToJson(
        CreatePriceRuleDiscountSelectedCustomersRequest data) =>
    json.encode(data.toJson());

@freezed
class CreatePriceRuleDiscountSelectedCustomersRequest
    with _$CreatePriceRuleDiscountSelectedCustomersRequest {
  const factory CreatePriceRuleDiscountSelectedCustomersRequest({
    @JsonKey(name: "price_rule") PriceRule? priceRule,
  }) = _CreatePriceRuleDiscountSelectedCustomersRequest;

  factory CreatePriceRuleDiscountSelectedCustomersRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreatePriceRuleDiscountSelectedCustomersRequestFromJson(json);
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
    @JsonKey(name: "prerequisite_saved_search_ids")
    List<int>? prerequisiteSavedSearchIds,
    @JsonKey(name: "starts_at") String? startsAt,
  }) = _PriceRule;

  factory PriceRule.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleFromJson(json);
}
