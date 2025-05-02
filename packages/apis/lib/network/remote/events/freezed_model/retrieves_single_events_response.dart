// To parse this JSON data, do
//
//     final retrievesSingleEventsResponse = retrievesSingleEventsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_single_events_response.freezed.dart';
part 'retrieves_single_events_response.g.dart';

RetrievesSingleEventsResponse retrievesSingleEventsResponseFromJson(
        String str) =>
    RetrievesSingleEventsResponse.fromJson(json.decode(str));

String retrievesSingleEventsResponseToJson(
        RetrievesSingleEventsResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesSingleEventsResponse with _$RetrievesSingleEventsResponse {
  const factory RetrievesSingleEventsResponse({
    @JsonKey(name: "event") Event? event,
  }) = _RetrievesSingleEventsResponse;

  factory RetrievesSingleEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrievesSingleEventsResponseFromJson(json);
}

@freezed
class Event with _$Event {
  const factory Event({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "subject_id") int? subjectId,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "subject_type") String? subjectType,
    @JsonKey(name: "verb") String? verb,
    @JsonKey(name: "arguments") List<String>? arguments,
    @JsonKey(name: "body") dynamic body,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "author") String? author,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "path") String? path,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
