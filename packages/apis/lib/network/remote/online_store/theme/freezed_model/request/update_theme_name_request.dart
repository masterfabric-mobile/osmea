// To parse this JSON data, do
//
//     final updateThemeNameRequest = updateThemeNameRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_theme_name_request.freezed.dart';
part 'update_theme_name_request.g.dart';

UpdateThemeNameRequest updateThemeNameRequestFromJson(String str) => UpdateThemeNameRequest.fromJson(json.decode(str));

String updateThemeNameRequestToJson(UpdateThemeNameRequest data) => json.encode(data.toJson());

@freezed
class UpdateThemeNameRequest with _$UpdateThemeNameRequest {
    const factory UpdateThemeNameRequest({
        @JsonKey(name: "theme")
        Theme? theme,
    }) = _UpdateThemeNameRequest;

    factory UpdateThemeNameRequest.fromJson(Map<String, dynamic> json) => _$UpdateThemeNameRequestFromJson(json);
}

@freezed
class Theme with _$Theme {
    const factory Theme({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
    }) = _Theme;

    factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
}
