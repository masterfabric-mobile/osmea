// To parse this JSON data, do
//
//     final retrievesCountEventsResponse = retrievesCountEventsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_count_events_response.freezed.dart';
part 'retrieves_count_events_response.g.dart';

RetrievesCountEventsResponse retrievesCountEventsResponseFromJson(String str) =>
    RetrievesCountEventsResponse.fromJson(json.decode(str));

String retrievesCountEventsResponseToJson(RetrievesCountEventsResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesCountEventsResponse with _$RetrievesCountEventsResponse {
  const factory RetrievesCountEventsResponse({
    @JsonKey(name: "count") int? count,
  }) = _RetrievesCountEventsResponse;

  factory RetrievesCountEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrievesCountEventsResponseFromJson(json);
}
