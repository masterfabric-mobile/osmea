// To parse this JSON data, do
//
//     final receiveListOfShippingZonesResponse = receiveListOfShippingZonesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'receive_list_of_shipping_zones_response.freezed.dart';
part 'receive_list_of_shipping_zones_response.g.dart';

ReceiveListOfShippingZonesResponse receiveListOfShippingZonesResponseFromJson(
        String str) =>
    ReceiveListOfShippingZonesResponse.fromJson(json.decode(str));

String receiveListOfShippingZonesResponseToJson(
        ReceiveListOfShippingZonesResponse data) =>
    json.encode(data.toJson());

@freezed
class ReceiveListOfShippingZonesResponse
    with _$ReceiveListOfShippingZonesResponse {
  const factory ReceiveListOfShippingZonesResponse({
    @JsonKey(name: "shipping_zones") List<ShippingZone>? shippingZones,
  }) = _ReceiveListOfShippingZonesResponse;

  factory ReceiveListOfShippingZonesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ReceiveListOfShippingZonesResponseFromJson(json);
}

@freezed
class ShippingZone with _$ShippingZone {
  const factory ShippingZone({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "profile_id") String? profileId,
    @JsonKey(name: "location_group_id") String? locationGroupId,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "countries") List<Country>? countries,
    @JsonKey(name: "weight_based_shipping_rates")
    List<dynamic>? weightBasedShippingRates,
    @JsonKey(name: "price_based_shipping_rates")
    List<PriceBasedShippingRate>? priceBasedShippingRates,
    @JsonKey(name: "carrier_shipping_rate_providers")
    List<dynamic>? carrierShippingRateProviders,
  }) = _ShippingZone;

  factory ShippingZone.fromJson(Map<String, dynamic> json) =>
      _$ShippingZoneFromJson(json);
}

@freezed
class Country with _$Country {
  const factory Country({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "tax") double? tax,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "shipping_zone_id") int? shippingZoneId,
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
    @JsonKey(name: "tax") int? tax,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax_type") String? taxType,
    @JsonKey(name: "tax_percentage") int? taxPercentage,
    @JsonKey(name: "shipping_zone_id") int? shippingZoneId,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}

@freezed
class PriceBasedShippingRate with _$PriceBasedShippingRate {
  const factory PriceBasedShippingRate({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "shipping_zone_id") int? shippingZoneId,
    @JsonKey(name: "min_order_subtotal") dynamic minOrderSubtotal,
    @JsonKey(name: "max_order_subtotal") dynamic maxOrderSubtotal,
  }) = _PriceBasedShippingRate;

  factory PriceBasedShippingRate.fromJson(Map<String, dynamic> json) =>
      _$PriceBasedShippingRateFromJson(json);
}
