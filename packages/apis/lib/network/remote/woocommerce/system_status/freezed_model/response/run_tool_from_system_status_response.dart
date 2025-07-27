// To parse this JSON data, do
//
//     final runToolFromSystemStatusResponse = runToolFromSystemStatusResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'run_tool_from_system_status_response.freezed.dart';
part 'run_tool_from_system_status_response.g.dart';

RunToolFromSystemStatusResponse runToolFromSystemStatusResponseFromJson(
        String str) =>
    RunToolFromSystemStatusResponse.fromJson(json.decode(str));

String runToolFromSystemStatusResponseToJson(
        RunToolFromSystemStatusResponse data) =>
    json.encode(data.toJson());

@freezed
class RunToolFromSystemStatusResponse with _$RunToolFromSystemStatusResponse {
  const factory RunToolFromSystemStatusResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "action") String? action,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "success") bool? success,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "_links") Links? links,
  }) = _RunToolFromSystemStatusResponse;

  factory RunToolFromSystemStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$RunToolFromSystemStatusResponseFromJson(json);
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
