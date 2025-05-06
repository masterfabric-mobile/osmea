// To parse this JSON data, do
//
//     final singleLocationByIdResponse = singleLocationByIdResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'single_location_by_id_response.freezed.dart';
part 'single_location_by_id_response.g.dart';

SingleLocationByIdResponse singleLocationByIdResponseFromJson(String str) => SingleLocationByIdResponse.fromJson(json.decode(str));

String singleLocationByIdResponseToJson(SingleLocationByIdResponse data) => json.encode(data.toJson());

@freezed
class SingleLocationByIdResponse with _$SingleLocationByIdResponse {
    const factory SingleLocationByIdResponse({
        @JsonKey(name: "location")
        Location? location,
    }) = _SingleLocationByIdResponse;

    factory SingleLocationByIdResponse.fromJson(Map<String, dynamic> json) => _$SingleLocationByIdResponseFromJson(json);
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
    }) = _Location;

    factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}
