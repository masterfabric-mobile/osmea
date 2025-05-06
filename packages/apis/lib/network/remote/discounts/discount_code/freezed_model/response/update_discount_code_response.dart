import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_discount_code_response.freezed.dart';
part 'update_discount_code_response.g.dart';

@freezed
class UpdateDiscountCodeResponse with _$UpdateDiscountCodeResponse {
  const factory UpdateDiscountCodeResponse({
    required DiscountCode discountCode,
  }) = _UpdateDiscountCodeResponse;

  factory UpdateDiscountCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateDiscountCodeResponseFromJson(json);
}

@freezed
class DiscountCode with _$DiscountCode {
  const factory DiscountCode({
    required String id,
    required String code,
    required int usageCount,
    @JsonKey(name: 'price_rule_id') required String priceRuleId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DiscountCode;

  factory DiscountCode.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeFromJson(json);
}
