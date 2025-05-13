// To parse this JSON data, do
//
//     final retrievesCountOfProvincesForCountryResponse = retrievesCountOfProvincesForCountryResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_count_of_provinces_for_country_response.freezed.dart';
part 'retrieves_count_of_provinces_for_country_response.g.dart';

RetrievesCountOfProvincesForCountryResponse
    retrievesCountOfProvincesForCountryResponseFromJson(String str) =>
        RetrievesCountOfProvincesForCountryResponse.fromJson(json.decode(str));

String retrievesCountOfProvincesForCountryResponseToJson(
        RetrievesCountOfProvincesForCountryResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesCountOfProvincesForCountryResponse
    with _$RetrievesCountOfProvincesForCountryResponse {
  const factory RetrievesCountOfProvincesForCountryResponse({
    @JsonKey(name: "count") int? count,
  }) = _RetrievesCountOfProvincesForCountryResponse;

  factory RetrievesCountOfProvincesForCountryResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesCountOfProvincesForCountryResponseFromJson(json);
}
