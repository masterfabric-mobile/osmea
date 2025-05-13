// To parse this JSON data, do
//
//     final updatesExistingProvinceForCountryResponse = updatesExistingProvinceForCountryResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'updates_existing_province_for_country_response.freezed.dart';
part 'updates_existing_province_for_country_response.g.dart';

UpdatesExistingProvinceForCountryResponse
    updatesExistingProvinceForCountryResponseFromJson(String str) =>
        UpdatesExistingProvinceForCountryResponse.fromJson(json.decode(str));

String updatesExistingProvinceForCountryResponseToJson(
        UpdatesExistingProvinceForCountryResponse data) =>
    json.encode(data.toJson());

@freezed
class UpdatesExistingProvinceForCountryResponse
    with _$UpdatesExistingProvinceForCountryResponse {
  const factory UpdatesExistingProvinceForCountryResponse({
    @JsonKey(name: "province") Province? province,
  }) = _UpdatesExistingProvinceForCountryResponse;

  factory UpdatesExistingProvinceForCountryResponse.fromJson(
          Map<String, dynamic> json) =>
      _$UpdatesExistingProvinceForCountryResponseFromJson(json);
}

@freezed
class Province with _$Province {
  const factory Province({
    @JsonKey(name: "country_id") int? countryId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax_type") dynamic taxType,
    @JsonKey(name: "shipping_zone_id") dynamic shippingZoneId,
    @JsonKey(name: "tax") int? tax,
    @JsonKey(name: "tax_percentage") int? taxPercentage,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}
