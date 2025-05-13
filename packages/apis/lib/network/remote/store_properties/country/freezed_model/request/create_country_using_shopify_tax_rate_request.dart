// To parse this JSON data, do
//
//     final createCountryUsingShopifyTaxRateRequest = createCountryUsingShopifyTaxRateRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_country_using_shopify_tax_rate_request.freezed.dart';
part 'create_country_using_shopify_tax_rate_request.g.dart';

CreateCountryUsingShopifyTaxRateRequest
    createCountryUsingShopifyTaxRateRequestFromJson(String str) =>
        CreateCountryUsingShopifyTaxRateRequest.fromJson(json.decode(str));

String createCountryUsingShopifyTaxRateRequestToJson(
        CreateCountryUsingShopifyTaxRateRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateCountryUsingShopifyTaxRateRequest
    with _$CreateCountryUsingShopifyTaxRateRequest {
  const factory CreateCountryUsingShopifyTaxRateRequest({
    @JsonKey(name: "country") Country? country,
  }) = _CreateCountryUsingShopifyTaxRateRequest;

  factory CreateCountryUsingShopifyTaxRateRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateCountryUsingShopifyTaxRateRequestFromJson(json);
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
