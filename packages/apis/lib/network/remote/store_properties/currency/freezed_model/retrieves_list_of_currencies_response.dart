// To parse this JSON data, do
//
//     final retrievesListOfCurrenciesResponse = retrievesListOfCurrenciesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_list_of_currencies_response.freezed.dart';
part 'retrieves_list_of_currencies_response.g.dart';

RetrievesListOfCurrenciesResponse retrievesListOfCurrenciesResponseFromJson(
        String str) =>
    RetrievesListOfCurrenciesResponse.fromJson(json.decode(str));

String retrievesListOfCurrenciesResponseToJson(
        RetrievesListOfCurrenciesResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesListOfCurrenciesResponse
    with _$RetrievesListOfCurrenciesResponse {
  const factory RetrievesListOfCurrenciesResponse({
    @JsonKey(name: "currencies") List<dynamic>? currencies,
  }) = _RetrievesListOfCurrenciesResponse;

  factory RetrievesListOfCurrenciesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesListOfCurrenciesResponseFromJson(json);
}
