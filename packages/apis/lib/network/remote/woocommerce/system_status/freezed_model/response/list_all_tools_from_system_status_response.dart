// To parse this JSON data, do
//
//     final listAllToolsFromSystemStatusResponse = listAllToolsFromSystemStatusResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_tools_from_system_status_response.freezed.dart';
part 'list_all_tools_from_system_status_response.g.dart';

List<ListAllToolsFromSystemStatusResponse>
    listAllToolsFromSystemStatusResponseFromJson(String str) =>
        List<ListAllToolsFromSystemStatusResponse>.from(json
            .decode(str)
            .map((x) => ListAllToolsFromSystemStatusResponse.fromJson(x)));

String listAllToolsFromSystemStatusResponseToJson(
        List<ListAllToolsFromSystemStatusResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
class ListAllToolsFromSystemStatusResponse
    with _$ListAllToolsFromSystemStatusResponse {
  const factory ListAllToolsFromSystemStatusResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "action") String? action,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "_links") Links? links,
  }) = _ListAllToolsFromSystemStatusResponse;

  factory ListAllToolsFromSystemStatusResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ListAllToolsFromSystemStatusResponseFromJson(json);
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
