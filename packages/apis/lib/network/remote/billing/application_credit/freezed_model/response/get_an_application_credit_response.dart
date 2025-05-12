// To parse this JSON data, do
//
//     final getAnApplicationCreditResponse = getAnApplicationCreditResponseFromJson(jsonString);

import 'package:apis/network/remote/billing/application_credit/freezed_model/application_credit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_an_application_credit_response.freezed.dart';
part 'get_an_application_credit_response.g.dart';

GetAnApplicationCreditResponse getAnApplicationCreditResponseFromJson(String str) =>
    GetAnApplicationCreditResponse.fromJson(json.decode(str));

String getAnApplicationCreditResponseToJson(GetAnApplicationCreditResponse data) =>
    json.encode(data.toJson());

@freezed
class GetAnApplicationCreditResponse with _$GetAnApplicationCreditResponse {
  const factory GetAnApplicationCreditResponse({
    @JsonKey(name: "application_credit") ApplicationCredit? applicationCredit,
  }) = _GetAnApplicationCreditResponse;

  factory GetAnApplicationCreditResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnApplicationCreditResponseFromJson(json);
}