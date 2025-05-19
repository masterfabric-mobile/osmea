// To send this JSON data, use:
// final json = updatesExistingCountryRequestToJson(request);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'updates_existing_country_request.freezed.dart';
part 'updates_existing_country_request.g.dart';

UpdatesExistingCountryRequest updatesExistingCountryRequestFromJson(
        String str) =>
    UpdatesExistingCountryRequest.fromJson(json.decode(str));

String updatesExistingCountryRequestToJson(
        UpdatesExistingCountryRequest data) =>
    json.encode(data.toJson());

@freezed
class UpdatesExistingCountryRequest with _$UpdatesExistingCountryRequest {
  const factory UpdatesExistingCountryRequest({
    @JsonKey(name: "country") required Country country,
  }) = _UpdatesExistingCountryRequest;

  factory UpdatesExistingCountryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatesExistingCountryRequestFromJson(json);
}

@freezed
class Country with _$Country {
  const factory Country({
    @JsonKey(name: "id") required int id,
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
