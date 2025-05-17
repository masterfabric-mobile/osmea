// To parse this JSON data, do
//
//     final createScriptTagResponse = createScriptTagResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_script_tag_response.freezed.dart';
part 'create_script_tag_response.g.dart';

CreateScriptTagResponse createScriptTagResponseFromJson(String str) => CreateScriptTagResponse.fromJson(json.decode(str));

String createScriptTagResponseToJson(CreateScriptTagResponse data) => json.encode(data.toJson());

@freezed
class CreateScriptTagResponse with _$CreateScriptTagResponse {
    const factory CreateScriptTagResponse({
        @JsonKey(name: "script_tag")
        ScriptTag? scriptTag,
    }) = _CreateScriptTagResponse;

    factory CreateScriptTagResponse.fromJson(Map<String, dynamic> json) => _$CreateScriptTagResponseFromJson(json);
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
