// To parse this JSON data, do
//
//     final getAllApplicationCreditsResponse = getAllApplicationCreditsResponseFromJson(jsonString);

import 'package:apis/network/remote/billing/application_credit/freezed_model/application_credit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_all_application_credits_response.freezed.dart';
part 'get_all_application_credits_response.g.dart';

GetAllApplicationCreditsResponse getAllApplicationCreditsResponseFromJson(String str) =>
    GetAllApplicationCreditsResponse.fromJson(json.decode(str));

String getAllApplicationCreditsResponseToJson(GetAllApplicationCreditsResponse data) =>
    json.encode(data.toJson());

@freezed
class GetAllApplicationCreditsResponse with _$GetAllApplicationCreditsResponse {
  const factory GetAllApplicationCreditsResponse({
    @JsonKey(name: "application_credits") List<ApplicationCredit>? applicationCredits,
  }) = _GetAllApplicationCreditsResponse;

  factory GetAllApplicationCreditsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllApplicationCreditsResponseFromJson(json);
}