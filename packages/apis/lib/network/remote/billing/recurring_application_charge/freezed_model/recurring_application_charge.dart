// To parse this JSON data, do
//
//     final recurringApplicationCharge = recurringApplicationChargeFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'recurring_application_charge.freezed.dart';
part 'recurring_application_charge.g.dart';

RecurringApplicationCharge recurringApplicationChargeFromJson(String str) =>
    RecurringApplicationCharge.fromJson(json.decode(str));

String recurringApplicationChargeToJson(RecurringApplicationCharge data) =>
    json.encode(data.toJson());

@freezed
class RecurringApplicationCharge with _$RecurringApplicationCharge {
  const factory RecurringApplicationCharge({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "price") required String price,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "return_url") required String returnUrl,
    @JsonKey(name: "capped_amount") String? cappedAmount,
    @JsonKey(name: "terms") String? terms,
    @JsonKey(name: "trial_days") int? trialDays,
    @JsonKey(name: "activated_on") String? activatedOn,
    @JsonKey(name: "billing_on") String? billingOn,
    @JsonKey(name: "cancelled_on") String? cancelledOn,
    @JsonKey(name: "trial_ends_on") String? trialEndsOn,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "test") bool? test,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "confirmation_url") String? confirmationUrl,
  }) = _RecurringApplicationCharge;

  factory RecurringApplicationCharge.fromJson(Map<String, dynamic> json) =>
      _$RecurringApplicationChargeFromJson(json);
}