import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/recurring_application_charge.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_a_recurring_application_charge_response.freezed.dart';
part 'get_a_recurring_application_charge_response.g.dart';

@freezed
class GetARecurringApplicationChargeResponse with _$GetARecurringApplicationChargeResponse {
  const factory GetARecurringApplicationChargeResponse({
    @JsonKey(name: "recurring_application_charge") RecurringApplicationCharge? recurringApplicationCharge,
  }) = _GetARecurringApplicationChargeResponse;

  factory GetARecurringApplicationChargeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetARecurringApplicationChargeResponseFromJson(json);
}