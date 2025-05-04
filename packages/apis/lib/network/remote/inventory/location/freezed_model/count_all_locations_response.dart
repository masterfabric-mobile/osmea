// To parse this JSON data, do
//
//     final countAllLocationsResponse = countAllLocationsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_all_locations_response.freezed.dart';
part 'count_all_locations_response.g.dart';

CountAllLocationsResponse countAllLocationsResponseFromJson(String str) => CountAllLocationsResponse.fromJson(json.decode(str));

String countAllLocationsResponseToJson(CountAllLocationsResponse data) => json.encode(data.toJson());

@freezed
class CountAllLocationsResponse with _$CountAllLocationsResponse {
    const factory CountAllLocationsResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountAllLocationsResponse;

    factory CountAllLocationsResponse.fromJson(Map<String, dynamic> json) => _$CountAllLocationsResponseFromJson(json);
}
