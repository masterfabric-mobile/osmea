import 'package:apis/network/remote/billing/usage_charge/freezed_model/usage_charge.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_all_usage_charges_response.freezed.dart';
part 'get_all_usage_charges_response.g.dart';

@freezed
class GetAllUsageChargesResponse with _$GetAllUsageChargesResponse {
  const factory GetAllUsageChargesResponse({
    @JsonKey(name: "usage_charges") List<UsageCharge>? usageCharges,
  }) = _GetAllUsageChargesResponse;

  factory GetAllUsageChargesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllUsageChargesResponseFromJson(json);
}