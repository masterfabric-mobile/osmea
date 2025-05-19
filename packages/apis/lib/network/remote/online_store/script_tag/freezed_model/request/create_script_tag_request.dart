// To parse this JSON data, do
//
//     final createScriptTagRequest = createScriptTagRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_script_tag_request.freezed.dart';
part 'create_script_tag_request.g.dart';

CreateScriptTagRequest createScriptTagRequestFromJson(String str) => CreateScriptTagRequest.fromJson(json.decode(str));

String createScriptTagRequestToJson(CreateScriptTagRequest data) => json.encode(data.toJson());

@freezed
class CreateScriptTagRequest with _$CreateScriptTagRequest {
    const factory CreateScriptTagRequest({
        @JsonKey(name: "script_tag")
        ScriptTag? scriptTag,
    }) = _CreateScriptTagRequest;

    factory CreateScriptTagRequest.fromJson(Map<String, dynamic> json) => _$CreateScriptTagRequestFromJson(json);
}

@freezed
class ScriptTag with _$ScriptTag {
    const factory ScriptTag({
        @JsonKey(name: "event")
        String? event,
        @JsonKey(name: "src")
        String? src,
    }) = _ScriptTag;

    factory ScriptTag.fromJson(Map<String, dynamic> json) => _$ScriptTagFromJson(json);
}
