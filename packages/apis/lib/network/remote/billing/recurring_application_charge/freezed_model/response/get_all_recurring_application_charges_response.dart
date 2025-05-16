import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/recurring_application_charge.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_all_recurring_application_charges_response.freezed.dart';
part 'get_all_recurring_application_charges_response.g.dart';

@freezed
class GetAllRecurringApplicationChargesResponse with _$GetAllRecurringApplicationChargesResponse {
  const factory GetAllRecurringApplicationChargesResponse({
    @JsonKey(name: "recurring_application_charges") List<RecurringApplicationCharge>? recurringApplicationCharges,
  }) = _GetAllRecurringApplicationChargesResponse;

  factory GetAllRecurringApplicationChargesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllRecurringApplicationChargesResponseFromJson(json);
}