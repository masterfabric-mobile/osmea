// To parse this JSON data, do
//
//     final createCountryUsingCustomTaxRateRequest = createCountryUsingCustomTaxRateRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_country_using_custom_tax_rate_request.freezed.dart';
part 'create_country_using_custom_tax_rate_request.g.dart';

CreateCountryUsingCustomTaxRateRequest
    createCountryUsingCustomTaxRateRequestFromJson(String str) =>
        CreateCountryUsingCustomTaxRateRequest.fromJson(json.decode(str));

String createCountryUsingCustomTaxRateRequestToJson(
        CreateCountryUsingCustomTaxRateRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateCountryUsingCustomTaxRateRequest
    with _$CreateCountryUsingCustomTaxRateRequest {
  const factory CreateCountryUsingCustomTaxRateRequest({
    @JsonKey(name: "country") Country? country,
  }) = _CreateCountryUsingCustomTaxRateRequest;

  factory CreateCountryUsingCustomTaxRateRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateCountryUsingCustomTaxRateRequestFromJson(json);
}

@freezed
class Country with _$Country {
  const factory Country({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "tax") double? tax,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "provinces") List<dynamic>? provinces,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}
