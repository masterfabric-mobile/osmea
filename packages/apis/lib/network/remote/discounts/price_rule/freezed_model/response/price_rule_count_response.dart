import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_rule_count_response.freezed.dart';
part 'price_rule_count_response.g.dart';

@freezed
class PriceRuleCountResponse with _$PriceRuleCountResponse {
  factory PriceRuleCountResponse({
    required int count,
  }) = _PriceRuleCountResponse;

  factory PriceRuleCountResponse.fromJson(Map<String, dynamic> json) =>
      _$PriceRuleCountResponseFromJson(json);
}
