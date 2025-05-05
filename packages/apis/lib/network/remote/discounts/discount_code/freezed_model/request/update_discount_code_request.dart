import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_discount_code_request.freezed.dart';
part 'update_discount_code_request.g.dart';

UpdateDiscountCodeRequest updateDiscountCodeRequestFromJson(String str) =>
    UpdateDiscountCodeRequest.fromJson(json.decode(str));

String updateDiscountCodeRequestToJson(UpdateDiscountCodeRequest data) =>
    json.encode(data.toJson());

@freezed
class UpdateDiscountCodeRequest with _$UpdateDiscountCodeRequest {
  const factory UpdateDiscountCodeRequest({
    @JsonKey(name: "discount_code") DiscountCode? discountCode,
  }) = _UpdateDiscountCodeRequest;

  factory UpdateDiscountCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateDiscountCodeRequestFromJson(json);
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
