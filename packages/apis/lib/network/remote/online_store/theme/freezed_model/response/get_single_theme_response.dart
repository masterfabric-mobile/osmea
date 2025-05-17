// To parse this JSON data, do
//
//     final getSingleThemeResponse = getSingleThemeResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_single_theme_response.freezed.dart';
part 'get_single_theme_response.g.dart';

GetSingleThemeResponse getSingleThemeResponseFromJson(String str) => GetSingleThemeResponse.fromJson(json.decode(str));

String getSingleThemeResponseToJson(GetSingleThemeResponse data) => json.encode(data.toJson());

@freezed
class GetSingleThemeResponse with _$GetSingleThemeResponse {
    const factory GetSingleThemeResponse({
        @JsonKey(name: "theme")
        Theme? theme,
    }) = _GetSingleThemeResponse;

    factory GetSingleThemeResponse.fromJson(Map<String, dynamic> json) => _$GetSingleThemeResponseFromJson(json);
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
