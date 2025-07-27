// To parse this JSON data, do
//
//     final retrieveToolFromSystemStatusResponse = retrieveToolFromSystemStatusResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieve_tool_from_system_status_response.freezed.dart';
part 'retrieve_tool_from_system_status_response.g.dart';

RetrieveToolFromSystemStatusResponse
    retrieveToolFromSystemStatusResponseFromJson(String str) =>
        RetrieveToolFromSystemStatusResponse.fromJson(json.decode(str));

String retrieveToolFromSystemStatusResponseToJson(
        RetrieveToolFromSystemStatusResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrieveToolFromSystemStatusResponse
    with _$RetrieveToolFromSystemStatusResponse {
  const factory RetrieveToolFromSystemStatusResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "action") String? action,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "_links") Links? links,
  }) = _RetrieveToolFromSystemStatusResponse;

  factory RetrieveToolFromSystemStatusResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrieveToolFromSystemStatusResponseFromJson(json);
}

@freezed
class Links with _$Links {
  const factory Links({
    @JsonKey(name: "item") List<Item>? item,
  }) = _Links;

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
}

@freezed
class Item with _$Item {
  const factory Item({
    @JsonKey(name: "embeddable") bool? embeddable,
    @JsonKey(name: "href") String? href,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
