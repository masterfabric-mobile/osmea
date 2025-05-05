import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'discount_code_creation_response.freezed.dart';
part 'discount_code_creation_response.g.dart';

DiscountCodeCreationResponse discountCodeCreationResponseFromJson(String str) =>
    DiscountCodeCreationResponse.fromJson(json.decode(str));

String discountCodeCreationResponseToJson(DiscountCodeCreationResponse data) =>
    json.encode(data.toJson());

@freezed
class DiscountCodeCreationResponse with _$DiscountCodeCreationResponse {
  const factory DiscountCodeCreationResponse({
    @JsonKey(name: "discount_code_creation")
    DiscountCodeCreation? discountCodeCreation,
  }) = _DiscountCodeCreationResponse;

  factory DiscountCodeCreationResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeCreationResponseFromJson(json);
}

@freezed
class DiscountCodeCreation with _$DiscountCodeCreation {
  const factory DiscountCodeCreation({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "price_rule_id") int? priceRuleId,
    @JsonKey(name: "started_at") String? startedAt,
    @JsonKey(name: "completed_at") String? completedAt,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "codes_count") int? codesCount,
    @JsonKey(name: "imported_count") int? importedCount,
    @JsonKey(name: "failed_count") int? failedCount,
    @JsonKey(name: "logs") List<dynamic>? logs,
  }) = _DiscountCodeCreation;

  factory DiscountCodeCreation.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeCreationFromJson(json);
}
