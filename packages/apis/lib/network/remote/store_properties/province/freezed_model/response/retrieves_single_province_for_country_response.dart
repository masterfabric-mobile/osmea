// To parse this JSON data, do
//
//     final retrievesSingleProvinceForCountryResponse = retrievesSingleProvinceForCountryResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_single_province_for_country_response.freezed.dart';
part 'retrieves_single_province_for_country_response.g.dart';

RetrievesSingleProvinceForCountryResponse
    retrievesSingleProvinceForCountryResponseFromJson(String str) =>
        RetrievesSingleProvinceForCountryResponse.fromJson(json.decode(str));

String retrievesSingleProvinceForCountryResponseToJson(
        RetrievesSingleProvinceForCountryResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesSingleProvinceForCountryResponse
    with _$RetrievesSingleProvinceForCountryResponse {
  const factory RetrievesSingleProvinceForCountryResponse({
    @JsonKey(name: "province") Province? province,
  }) = _RetrievesSingleProvinceForCountryResponse;

  factory RetrievesSingleProvinceForCountryResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesSingleProvinceForCountryResponseFromJson(json);
}

@freezed
class Province with _$Province {
  const factory Province({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "country_id") int? countryId,
    @JsonKey(name: "name") String? name,
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
