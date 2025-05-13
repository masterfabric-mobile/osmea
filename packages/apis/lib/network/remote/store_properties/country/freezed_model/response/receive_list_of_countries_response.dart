// To parse this JSON data, do
//
//     final receiveListOfCountriesResponse = receiveListOfCountriesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'receive_list_of_countries_response.freezed.dart';
part 'receive_list_of_countries_response.g.dart';

ReceiveListOfCountriesResponse receiveListOfCountriesResponseFromJson(
        String str) =>
    ReceiveListOfCountriesResponse.fromJson(json.decode(str));

String receiveListOfCountriesResponseToJson(
        ReceiveListOfCountriesResponse data) =>
    json.encode(data.toJson());

@freezed
class ReceiveListOfCountriesResponse with _$ReceiveListOfCountriesResponse {
  const factory ReceiveListOfCountriesResponse({
    @JsonKey(name: "countries") List<Country>? countries,
  }) = _ReceiveListOfCountriesResponse;

  factory ReceiveListOfCountriesResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceiveListOfCountriesResponseFromJson(json);
}

@freezed
class Country with _$Country {
  const factory Country({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax") double? tax,
    @JsonKey(name: "provinces") List<Province>? provinces,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}

@freezed
class Province with _$Province {
  const factory Province({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "country_id") int? countryId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax_type") String? taxType,
    @JsonKey(name: "shipping_zone_id") dynamic shippingZoneId,
    @JsonKey(name: "tax") int? tax,
    @JsonKey(name: "tax_percentage") int? taxPercentage,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}
