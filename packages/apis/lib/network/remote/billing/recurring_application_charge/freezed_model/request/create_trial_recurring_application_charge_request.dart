import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_trial_recurring_application_charge_request.freezed.dart';
part 'create_trial_recurring_application_charge_request.g.dart';

@freezed
class CreateTrialRecurringApplicationChargeRequest with _$CreateTrialRecurringApplicationChargeRequest {
  const factory CreateTrialRecurringApplicationChargeRequest({
    @JsonKey(name: "recurring_application_charge")
    required TrialRecurringApplicationChargeData recurringApplicationCharge,
  }) = _CreateTrialRecurringApplicationChargeRequest;

  factory CreateTrialRecurringApplicationChargeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTrialRecurringApplicationChargeRequestFromJson(json);
}

@freezed
class TrialRecurringApplicationChargeData with _$TrialRecurringApplicationChargeData {
  const factory TrialRecurringApplicationChargeData({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "price") required double price,
    @JsonKey(name: "return_url") required String returnUrl,
    @JsonKey(name: "trial_days") required int trialDays,
    @JsonKey(name: "test") bool? test,
  }) = _TrialRecurringApplicationChargeData;

  factory TrialRecurringApplicationChargeData.fromJson(Map<String, dynamic> json) =>
      _$TrialRecurringApplicationChargeDataFromJson(json);
}