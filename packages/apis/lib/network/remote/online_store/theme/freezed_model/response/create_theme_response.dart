// To parse this JSON data, do
//
//     final createThemeResponse = createThemeResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_theme_response.freezed.dart';
part 'create_theme_response.g.dart';

CreateThemeResponse createThemeResponseFromJson(String str) => CreateThemeResponse.fromJson(json.decode(str));

String createThemeResponseToJson(CreateThemeResponse data) => json.encode(data.toJson());

@freezed
class CreateThemeResponse with _$CreateThemeResponse {
    const factory CreateThemeResponse({
        @JsonKey(name: "errors")
        Errors? errors,
        @JsonKey(name: "theme")
        Theme? theme,
    }) = _CreateThemeResponse;

    factory CreateThemeResponse.fromJson(Map<String, dynamic> json) => _$CreateThemeResponseFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "name")
        List<String>? name,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}

@freezed
class Theme with _$Theme {
    const factory Theme({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "role")
        String? role,
        @JsonKey(name: "theme_store_id")
        dynamic themeStoreId,
        @JsonKey(name: "previewable")
        bool? previewable,
        @JsonKey(name: "processing")
        bool? processing,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Theme;

    factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
}
