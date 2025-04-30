import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'discount_code_list_response.freezed.dart';
part 'discount_code_list_response.g.dart';

DiscountCodeListResponse discountCodeListResponseFromJson(String str) =>
    DiscountCodeListResponse.fromJson(json.decode(str));

String discountCodeListResponseToJson(DiscountCodeListResponse data) =>
    json.encode(data.toJson());

@freezed
class DiscountCodeListResponse with _$DiscountCodeListResponse {
  const factory DiscountCodeListResponse({
    @JsonKey(name: "discount_codes") List<DiscountCode>? discountCodes,
  }) = _DiscountCodeListResponse;

  factory DiscountCodeListResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeListResponseFromJson(json);
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
