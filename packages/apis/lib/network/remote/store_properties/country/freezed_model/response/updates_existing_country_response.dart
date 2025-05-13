// To parse this JSON data, do
//
//     final updatesExistingCountryResponse = updatesExistingCountryResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'updates_existing_country_response.freezed.dart';
part 'updates_existing_country_response.g.dart';

UpdatesExistingCountryResponse updatesExistingCountryResponseFromJson(
        String str) =>
    UpdatesExistingCountryResponse.fromJson(json.decode(str));

String updatesExistingCountryResponseToJson(
        UpdatesExistingCountryResponse data) =>
    json.encode(data.toJson());

@freezed
class UpdatesExistingCountryResponse with _$UpdatesExistingCountryResponse {
  const factory UpdatesExistingCountryResponse({
    @JsonKey(name: "country") Country? country,
  }) = _UpdatesExistingCountryResponse;

  factory UpdatesExistingCountryResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatesExistingCountryResponseFromJson(json);
}

@freezed
class Country with _$Country {
  const factory Country({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "tax") double? tax,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
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
    @JsonKey(name: "tax") double? tax,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax_type") String? taxType,
    @JsonKey(name: "shipping_zone_id") dynamic shippingZoneId,
    @JsonKey(name: "tax_percentage") int? taxPercentage,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}
