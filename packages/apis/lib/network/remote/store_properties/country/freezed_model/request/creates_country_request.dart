// To parse this JSON data, do
//
//     final createsCountryRequest = createsCountryRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_country_request.freezed.dart';
part 'creates_country_request.g.dart';

CreatesCountryRequest createsCountryRequestFromJson(String str) =>
    CreatesCountryRequest.fromJson(json.decode(str));

String createsCountryRequestToJson(CreatesCountryRequest data) =>
    json.encode(data.toJson());

@freezed
class CreatesCountryRequest with _$CreatesCountryRequest {
  const factory CreatesCountryRequest({
    @JsonKey(name: "country") Country? country,
  }) = _CreatesCountryRequest;

  factory CreatesCountryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatesCountryRequestFromJson(json);
}

@freezed
class Country with _$Country {
  const factory Country({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax") int? tax,
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
    @JsonKey(name: "tax_type") dynamic taxType,
    @JsonKey(name: "shipping_zone_id") dynamic shippingZoneId,
    @JsonKey(name: "tax") int? tax,
    @JsonKey(name: "tax_percentage") int? taxPercentage,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}
