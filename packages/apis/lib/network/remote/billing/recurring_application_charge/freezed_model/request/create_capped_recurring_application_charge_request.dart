import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_capped_recurring_application_charge_request.freezed.dart';
part 'create_capped_recurring_application_charge_request.g.dart';

@freezed
class CreateCappedRecurringApplicationChargeRequest with _$CreateCappedRecurringApplicationChargeRequest {
  const factory CreateCappedRecurringApplicationChargeRequest({
    @JsonKey(name: "recurring_application_charge")
    required CappedRecurringApplicationChargeData recurringApplicationCharge,
  }) = _CreateCappedRecurringApplicationChargeRequest;

  factory CreateCappedRecurringApplicationChargeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCappedRecurringApplicationChargeRequestFromJson(json);
}

@freezed
class CappedRecurringApplicationChargeData with _$CappedRecurringApplicationChargeData {
  const factory CappedRecurringApplicationChargeData({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "price") required double price,
    @JsonKey(name: "return_url") required String returnUrl,
    @JsonKey(name: "capped_amount") required double cappedAmount,
    @JsonKey(name: "terms") required String terms,
    @JsonKey(name: "test") bool? test,
  }) = _CappedRecurringApplicationChargeData;

  factory CappedRecurringApplicationChargeData.fromJson(Map<String, dynamic> json) =>
      _$CappedRecurringApplicationChargeDataFromJson(json);
}