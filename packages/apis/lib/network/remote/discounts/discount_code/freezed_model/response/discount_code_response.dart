// To parse this JSON data, do
//
//     final discountCodeResponse = discountCodeResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'discount_code_response.freezed.dart';
part 'discount_code_response.g.dart';

DiscountCodeResponse discountCodeResponseFromJson(String str) =>
    DiscountCodeResponse.fromJson(json.decode(str));

String discountCodeResponseToJson(DiscountCodeResponse data) =>
    json.encode(data.toJson());

@freezed
class DiscountCodeResponse with _$DiscountCodeResponse {
  const factory DiscountCodeResponse({
    @JsonKey(name: "discount_code") DiscountCode? discountCode,
  }) = _DiscountCodeResponse;

  factory DiscountCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeResponseFromJson(json);
}

@freezed
class DiscountCode with _$DiscountCode {
  const factory DiscountCode({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "price_rule_id") int? priceRuleId,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "usage_count") int? usageCount,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _DiscountCode;

  factory DiscountCode.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeFromJson(json);
}
