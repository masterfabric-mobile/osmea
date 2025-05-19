// To parse this JSON data, do
//
//     final applicationCharge = applicationChargeFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'application_charge.freezed.dart';
part 'application_charge.g.dart';

ApplicationCharge applicationChargeFromJson(String str) =>
    ApplicationCharge.fromJson(json.decode(str));

String applicationChargeToJson(ApplicationCharge data) =>
    json.encode(data.toJson());

@freezed
class ApplicationCharge with _$ApplicationCharge {
  const factory ApplicationCharge({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "api_client_id") required int apiClientId,
    @JsonKey(name: "price") required String price,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "return_url") required String returnUrl,
    @JsonKey(name: "test") required bool test,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "updated_at") required String updatedAt,
    @JsonKey(name: "currency") required String currency,
    @JsonKey(name: "charge_type") String? chargeType,
    @JsonKey(name: "decorated_return_url") required String decoratedReturnUrl,
    @JsonKey(name: "confirmation_url") String? confirmationUrl, // Made nullable/optional
  }) = _ApplicationCharge;

  factory ApplicationCharge.fromJson(Map<String, dynamic> json) =>
      _$ApplicationChargeFromJson(json);
}