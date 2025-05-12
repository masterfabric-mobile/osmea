// To parse this JSON data, do
//
//     final applicationCredit = applicationCreditFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'application_credit.freezed.dart';
part 'application_credit.g.dart';

ApplicationCredit applicationCreditFromJson(String str) =>
    ApplicationCredit.fromJson(json.decode(str));

String applicationCreditToJson(ApplicationCredit data) =>
    json.encode(data.toJson());

@freezed
class ApplicationCredit with _$ApplicationCredit {
  const factory ApplicationCredit({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "amount") required String amount,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "test") required bool test,
    @JsonKey(name: "currency") required String currency
  }) = _ApplicationCredit;

  factory ApplicationCredit.fromJson(Map<String, dynamic> json) =>
      _$ApplicationCreditFromJson(json);
}