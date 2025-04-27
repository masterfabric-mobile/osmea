// To parse this JSON data, do
//
//     final retrievesCountOfCustomersResponse = retrievesCountOfCustomersResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_count_of_customers_response.freezed.dart';
part 'retrieves_count_of_customers_response.g.dart';

RetrievesCountOfCustomersResponse retrievesCountOfCustomersResponseFromJson(String str) => RetrievesCountOfCustomersResponse.fromJson(json.decode(str));

String retrievesCountOfCustomersResponseToJson(RetrievesCountOfCustomersResponse data) => json.encode(data.toJson());

@freezed
class RetrievesCountOfCustomersResponse with _$RetrievesCountOfCustomersResponse {
    const factory RetrievesCountOfCustomersResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _RetrievesCountOfCustomersResponse;

    factory RetrievesCountOfCustomersResponse.fromJson(Map<String, dynamic> json) => _$RetrievesCountOfCustomersResponseFromJson(json);
}
