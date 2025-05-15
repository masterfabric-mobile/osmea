import 'package:apis/network/remote/billing/usage_charge/freezed_model/usage_charge.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_a_usage_charge_response.freezed.dart';
part 'get_a_usage_charge_response.g.dart';

@freezed
class GetAUsageChargeResponse with _$GetAUsageChargeResponse {
  const factory GetAUsageChargeResponse({
    @JsonKey(name: "usage_charge") UsageCharge? usageCharge,
  }) = _GetAUsageChargeResponse;

  factory GetAUsageChargeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAUsageChargeResponseFromJson(json);
}