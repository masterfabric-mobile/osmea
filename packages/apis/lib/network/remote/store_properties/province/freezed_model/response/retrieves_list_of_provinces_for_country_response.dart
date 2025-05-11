// To parse this JSON data, do
//
//     final retrievesListOfProvincesForCountryResponse = retrievesListOfProvincesForCountryResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_list_of_provinces_for_country_response.freezed.dart';
part 'retrieves_list_of_provinces_for_country_response.g.dart';

RetrievesListOfProvincesForCountryResponse
    retrievesListOfProvincesForCountryResponseFromJson(String str) =>
        RetrievesListOfProvincesForCountryResponse.fromJson(json.decode(str));

String retrievesListOfProvincesForCountryResponseToJson(
        RetrievesListOfProvincesForCountryResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesListOfProvincesForCountryResponse
    with _$RetrievesListOfProvincesForCountryResponse {
  const factory RetrievesListOfProvincesForCountryResponse({
    @JsonKey(name: "provinces") List<Province>? provinces,
  }) = _RetrievesListOfProvincesForCountryResponse;

  factory RetrievesListOfProvincesForCountryResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesListOfProvincesForCountryResponseFromJson(json);
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
