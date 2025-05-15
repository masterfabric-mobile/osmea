// To parse this JSON data, do
//
//     final getAnApplicationChargeResponse = getAnApplicationChargeResponseFromJson(jsonString);

import 'package:apis/network/remote/billing/application_charge/freezed_model/application_charge.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_an_application_charge_response.freezed.dart';
part 'get_an_application_charge_response.g.dart';

GetAnApplicationChargeResponse getAnApplicationChargeResponseFromJson(String str) =>
    GetAnApplicationChargeResponse.fromJson(json.decode(str));

String getAnApplicationChargeResponseToJson(GetAnApplicationChargeResponse data) =>
    json.encode(data.toJson());

@freezed
class GetAnApplicationChargeResponse with _$GetAnApplicationChargeResponse {
  const factory GetAnApplicationChargeResponse({
    @JsonKey(name: "application_charge") ApplicationCharge? applicationCharge,
  }) = _GetAnApplicationChargeResponse;

  factory GetAnApplicationChargeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnApplicationChargeResponseFromJson(json);
}