// To parse this JSON data, do
//
//     final updateScriptTagUrlResponse = updateScriptTagUrlResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_script_tag_url_response.freezed.dart';
part 'update_script_tag_url_response.g.dart';

UpdateScriptTagUrlResponse updateScriptTagUrlResponseFromJson(String str) => UpdateScriptTagUrlResponse.fromJson(json.decode(str));

String updateScriptTagUrlResponseToJson(UpdateScriptTagUrlResponse data) => json.encode(data.toJson());

@freezed
class UpdateScriptTagUrlResponse with _$UpdateScriptTagUrlResponse {
    const factory UpdateScriptTagUrlResponse({
        @JsonKey(name: "script_tag")
        ScriptTag? scriptTag,
    }) = _UpdateScriptTagUrlResponse;

    factory UpdateScriptTagUrlResponse.fromJson(Map<String, dynamic> json) => _$UpdateScriptTagUrlResponseFromJson(json);
}

@freezed
class ScriptTag with _$ScriptTag {
    const factory ScriptTag({
        @JsonKey(name: "src")
        String? src,
        @JsonKey(name: "display_scope")
        String? displayScope,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "event")
        String? event,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "cache")
        bool? cache,
    }) = _ScriptTag;

    factory ScriptTag.fromJson(Map<String, dynamic> json) => _$ScriptTagFromJson(json);
}
