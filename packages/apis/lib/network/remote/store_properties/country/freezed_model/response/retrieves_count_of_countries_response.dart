// To parse this JSON data, do
//
//     final retrievesCountOfCountriesResponse = retrievesCountOfCountriesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_count_of_countries_response.freezed.dart';
part 'retrieves_count_of_countries_response.g.dart';

RetrievesCountOfCountriesResponse retrievesCountOfCountriesResponseFromJson(
        String str) =>
    RetrievesCountOfCountriesResponse.fromJson(json.decode(str));

String retrievesCountOfCountriesResponseToJson(
        RetrievesCountOfCountriesResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesCountOfCountriesResponse
    with _$RetrievesCountOfCountriesResponse {
  const factory RetrievesCountOfCountriesResponse({
    @JsonKey(name: "count") int? count,
  }) = _RetrievesCountOfCountriesResponse;

  factory RetrievesCountOfCountriesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesCountOfCountriesResponseFromJson(json);
}
