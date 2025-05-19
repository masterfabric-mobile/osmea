// To parse this JSON data, do
//
//     final listAllScriptTagsResponse = listAllScriptTagsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_script_tags_response.freezed.dart';
part 'list_all_script_tags_response.g.dart';

ListAllScriptTagsResponse listAllScriptTagsResponseFromJson(String str) => ListAllScriptTagsResponse.fromJson(json.decode(str));

String listAllScriptTagsResponseToJson(ListAllScriptTagsResponse data) => json.encode(data.toJson());

@freezed
class ListAllScriptTagsResponse with _$ListAllScriptTagsResponse {
    const factory ListAllScriptTagsResponse({
        @JsonKey(name: "script_tags")
        List<ScriptTag>? scriptTags,
    }) = _ListAllScriptTagsResponse;

    factory ListAllScriptTagsResponse.fromJson(Map<String, dynamic> json) => _$ListAllScriptTagsResponseFromJson(json);
}

@freezed
class ScriptTag with _$ScriptTag {
    const factory ScriptTag({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "src")
        String? src,
        @JsonKey(name: "event")
        String? event,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "display_scope")
        String? displayScope,
        @JsonKey(name: "cache")
        bool? cache,
    }) = _ScriptTag;

    factory ScriptTag.fromJson(Map<String, dynamic> json) => _$ScriptTagFromJson(json);
}
