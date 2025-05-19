// To parse this JSON data, do
//
//     final getSingleScriptResponse = getSingleScriptResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_single_script_response.freezed.dart';
part 'get_single_script_response.g.dart';

GetSingleScriptResponse getSingleScriptResponseFromJson(String str) => GetSingleScriptResponse.fromJson(json.decode(str));

String getSingleScriptResponseToJson(GetSingleScriptResponse data) => json.encode(data.toJson());

@freezed
class GetSingleScriptResponse with _$GetSingleScriptResponse {
    const factory GetSingleScriptResponse({
        @JsonKey(name: "script_tag")
        ScriptTag? scriptTag,
    }) = _GetSingleScriptResponse;

    factory GetSingleScriptResponse.fromJson(Map<String, dynamic> json) => _$GetSingleScriptResponseFromJson(json);
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
