// To parse this JSON data, do
//
//     final retrievesListOfEventsResponse = retrievesListOfEventsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_list_of_events_response.freezed.dart';
part 'retrieves_list_of_events_response.g.dart';

RetrievesListOfEventsResponse retrievesListOfEventsResponseFromJson(
        String str) =>
    RetrievesListOfEventsResponse.fromJson(json.decode(str));

String retrievesListOfEventsResponseToJson(
        RetrievesListOfEventsResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesListOfEventsResponse with _$RetrievesListOfEventsResponse {
  const factory RetrievesListOfEventsResponse({
    @JsonKey(name: "events") List<Event>? events,
  }) = _RetrievesListOfEventsResponse;

  factory RetrievesListOfEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrievesListOfEventsResponseFromJson(json);
}

@freezed
class Event with _$Event {
  const factory Event({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "subject_id") int? subjectId,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "subject_type") String? subjectType,
    @JsonKey(name: "verb") String? verb,
    @JsonKey(name: "arguments") List<dynamic>? arguments,
    @JsonKey(name: "body") dynamic body,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "author") String? author,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "path") String? path,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
