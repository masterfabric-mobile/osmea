import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_basic_recurring_application_charge_request.freezed.dart';
part 'create_basic_recurring_application_charge_request.g.dart';

@freezed
class CreateBasicRecurringApplicationChargeRequest with _$CreateBasicRecurringApplicationChargeRequest {
  const factory CreateBasicRecurringApplicationChargeRequest({
    @JsonKey(name: "recurring_application_charge")
    required BasicRecurringApplicationChargeData recurringApplicationCharge,
  }) = _CreateBasicRecurringApplicationChargeRequest;

  factory CreateBasicRecurringApplicationChargeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBasicRecurringApplicationChargeRequestFromJson(json);
}

@freezed
class BasicRecurringApplicationChargeData with _$BasicRecurringApplicationChargeData {
  const factory BasicRecurringApplicationChargeData({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "price") required double price,
    @JsonKey(name: "return_url") required String returnUrl,
    @JsonKey(name: "test") bool? test,
  }) = _BasicRecurringApplicationChargeData;

  factory BasicRecurringApplicationChargeData.fromJson(Map<String, dynamic> json) =>
      _$BasicRecurringApplicationChargeDataFromJson(json);
}