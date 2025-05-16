import 'package:freezed_annotation/freezed_annotation.dart';

part 'customize_recurring_application_charge_request.freezed.dart';
part 'customize_recurring_application_charge_request.g.dart';

@freezed
class CustomizeRecurringApplicationChargeRequest with _$CustomizeRecurringApplicationChargeRequest {
  const factory CustomizeRecurringApplicationChargeRequest({
    @JsonKey(name: "recurring_application_charge")
    required Map<String, dynamic> recurringApplicationCharge,
  }) = _CustomizeRecurringApplicationChargeRequest;

  factory CustomizeRecurringApplicationChargeRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomizeRecurringApplicationChargeRequestFromJson(json);
}

@freezed
class RecurringApplicationChargeUpdateData with _$RecurringApplicationChargeUpdateData {
  const factory RecurringApplicationChargeUpdateData({
    @JsonKey(name: "capped_amount") required String cappedAmount,
  }) = _RecurringApplicationChargeUpdateData;

  factory RecurringApplicationChargeUpdateData.fromJson(Map<String, dynamic> json) =>
      _$RecurringApplicationChargeUpdateDataFromJson(json);
}