// To parse this JSON data, do
//
//     final updateScriptTagUrlRequest = updateScriptTagUrlRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_script_tag_url_request.freezed.dart';
part 'update_script_tag_url_request.g.dart';

UpdateScriptTagUrlRequest updateScriptTagUrlRequestFromJson(String str) => UpdateScriptTagUrlRequest.fromJson(json.decode(str));

String updateScriptTagUrlRequestToJson(UpdateScriptTagUrlRequest data) => json.encode(data.toJson());

@freezed
class UpdateScriptTagUrlRequest with _$UpdateScriptTagUrlRequest {
    const factory UpdateScriptTagUrlRequest({
        @JsonKey(name: "script_tag")
        ScriptTag? scriptTag,
    }) = _UpdateScriptTagUrlRequest;

    factory UpdateScriptTagUrlRequest.fromJson(Map<String, dynamic> json) => _$UpdateScriptTagUrlRequestFromJson(json);
}

@freezed
class ScriptTag with _$ScriptTag {
    const factory ScriptTag({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "src")
        String? src,
    }) = _ScriptTag;

    factory ScriptTag.fromJson(Map<String, dynamic> json) => _$ScriptTagFromJson(json);
}
