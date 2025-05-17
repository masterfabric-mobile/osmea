// To parse this JSON data, do
//
//     final updateThemeNameResponse = updateThemeNameResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_theme_name_response.freezed.dart';
part 'update_theme_name_response.g.dart';

UpdateThemeNameResponse updateThemeNameResponseFromJson(String str) => UpdateThemeNameResponse.fromJson(json.decode(str));

String updateThemeNameResponseToJson(UpdateThemeNameResponse data) => json.encode(data.toJson());

@freezed
class UpdateThemeNameResponse with _$UpdateThemeNameResponse {
    const factory UpdateThemeNameResponse({
        @JsonKey(name: "theme")
        Theme? theme,
    }) = _UpdateThemeNameResponse;

    factory UpdateThemeNameResponse.fromJson(Map<String, dynamic> json) => _$UpdateThemeNameResponseFromJson(json);
}

@freezed
class Theme with _$Theme {
    const factory Theme({
        @JsonKey(name: "role")
        String? role,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "theme_store_id")
        int? themeStoreId,
        @JsonKey(name: "previewable")
        bool? previewable,
        @JsonKey(name: "processing")
        bool? processing,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Theme;

    factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
}
