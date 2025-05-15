import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_usage_charge_request.freezed.dart';
part 'create_usage_charge_request.g.dart';

@freezed
class CreateUsageChargeRequest with _$CreateUsageChargeRequest {
  const factory CreateUsageChargeRequest({
    @JsonKey(name: "usage_charge")
    required UsageChargeData usageCharge,
  }) = _CreateUsageChargeRequest;

  factory CreateUsageChargeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUsageChargeRequestFromJson(json);
}

@freezed
class UsageChargeData with _$UsageChargeData {
  const factory UsageChargeData({
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "price") required String price,
  }) = _UsageChargeData;

  factory UsageChargeData.fromJson(Map<String, dynamic> json) =>
      _$UsageChargeDataFromJson(json);
}