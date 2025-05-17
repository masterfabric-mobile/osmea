// To parse this JSON data, do
//
//     final createThemeRequest = createThemeRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_theme_request.freezed.dart';
part 'create_theme_request.g.dart';

CreateThemeRequest createThemeRequestFromJson(String str) => CreateThemeRequest.fromJson(json.decode(str));

String createThemeRequestToJson(CreateThemeRequest data) => json.encode(data.toJson());

@freezed
class CreateThemeRequest with _$CreateThemeRequest {
    const factory CreateThemeRequest({
        @JsonKey(name: "theme")
        Theme? theme,
    }) = _CreateThemeRequest;

    factory CreateThemeRequest.fromJson(Map<String, dynamic> json) => _$CreateThemeRequestFromJson(json);
}

@freezed
class Theme with _$Theme {
    const factory Theme({
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "src")
        String? src,
        @JsonKey(name: "role")
        String? role,
    }) = _Theme;

    factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
}
