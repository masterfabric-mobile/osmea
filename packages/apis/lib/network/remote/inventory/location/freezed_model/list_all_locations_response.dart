// To parse this JSON data, do
//
//     final listAllLocationsResponse = listAllLocationsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_locations_response.freezed.dart';
part 'list_all_locations_response.g.dart';

ListAllLocationsResponse listAllLocationsResponseFromJson(String str) => ListAllLocationsResponse.fromJson(json.decode(str));

String listAllLocationsResponseToJson(ListAllLocationsResponse data) => json.encode(data.toJson());

@freezed
class ListAllLocationsResponse with _$ListAllLocationsResponse {
    const factory ListAllLocationsResponse({
        @JsonKey(name: "locations")
        List<Location>? locations,
    }) = _ListAllLocationsResponse;

    factory ListAllLocationsResponse.fromJson(Map<String, dynamic> json) => _$ListAllLocationsResponseFromJson(json);
}

@freezed
class Location with _$Location {
    const factory Location({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "address1")
        String? address1,
        @JsonKey(name: "address2")
        String? address2,
        @JsonKey(name: "city")
        String? city,
        @JsonKey(name: "zip")
        String? zip,
        @JsonKey(name: "province")
        dynamic province,
        @JsonKey(name: "country")
        String? country,
        @JsonKey(name: "phone")
        String? phone,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "country_code")
        String? countryCode,
        @JsonKey(name: "country_name")
        String? countryName,
        @JsonKey(name: "province_code")
        dynamic provinceCode,
        @JsonKey(name: "legacy")
        bool? legacy,
        @JsonKey(name: "active")
        bool? active,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
        @JsonKey(name: "localized_country_name")
        String? localizedCountryName,
        @JsonKey(name: "localized_province_name")
        dynamic localizedProvinceName,
    }) = _Location;

    factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}
