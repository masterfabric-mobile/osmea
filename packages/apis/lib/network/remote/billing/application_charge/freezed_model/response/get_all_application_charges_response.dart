// To parse this JSON data, do
//
//     final getAllApplicationChargesResponse = getAllApplicationChargesResponseFromJson(jsonString);

import 'package:apis/network/remote/billing/application_charge/freezed_model/application_charge.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_all_application_charges_response.freezed.dart';
part 'get_all_application_charges_response.g.dart';

GetAllApplicationChargesResponse getAllApplicationChargesResponseFromJson(String str) =>
    GetAllApplicationChargesResponse.fromJson(json.decode(str));

String getAllApplicationChargesResponseToJson(GetAllApplicationChargesResponse data) =>
    json.encode(data.toJson());

@freezed
class GetAllApplicationChargesResponse with _$GetAllApplicationChargesResponse {
  const factory GetAllApplicationChargesResponse({
    @JsonKey(name: "application_charges") List<ApplicationCharge>? applicationCharges,
    
    // Remove the rawData field since it's causing problems
  }) = _GetAllApplicationChargesResponse;

  factory GetAllApplicationChargesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllApplicationChargesResponseFromJson(json);
}