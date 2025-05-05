import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'discount_code_location_response.freezed.dart';
part 'discount_code_location_response.g.dart';

DiscountCodeLocationResponse discountCodeLocationResponseFromJson(String str) =>
    DiscountCodeLocationResponse.fromJson(json.decode(str));

String discountCodeLocationResponseToJson(DiscountCodeLocationResponse data) =>
    json.encode(data.toJson());

@freezed
class DiscountCodeLocationResponse with _$DiscountCodeLocationResponse {
  const factory DiscountCodeLocationResponse({
    @JsonKey(name: "discount_code") DiscountCode? discountCode,
  }) = _DiscountCodeLocationResponse;

  factory DiscountCodeLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeLocationResponseFromJson(json);
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
