// To parse this JSON data, do
//
//     final createApplicationChargeResponse = createApplicationChargeResponseFromJson(jsonString);

import 'package:apis/network/remote/billing/application_charge/freezed_model/application_charge.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_application_charge_response.freezed.dart';
part 'create_application_charge_response.g.dart';

CreateApplicationChargeResponse createApplicationChargeResponseFromJson(String str) =>
    CreateApplicationChargeResponse.fromJson(json.decode(str));

String createApplicationChargeResponseToJson(CreateApplicationChargeResponse data) =>
    json.encode(data.toJson());

@freezed
class CreateApplicationChargeResponse with _$CreateApplicationChargeResponse {
  const factory CreateApplicationChargeResponse({
    @JsonKey(name: "application_charge") ApplicationCharge? applicationCharge,
  }) = _CreateApplicationChargeResponse;

  factory CreateApplicationChargeResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateApplicationChargeResponseFromJson(json);
}