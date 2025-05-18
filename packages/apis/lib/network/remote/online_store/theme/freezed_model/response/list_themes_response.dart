// To parse this JSON data, do
//
//     final listThemesResponse = listThemesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_themes_response.freezed.dart';
part 'list_themes_response.g.dart';

ListThemesResponse listThemesResponseFromJson(String str) => ListThemesResponse.fromJson(json.decode(str));

String listThemesResponseToJson(ListThemesResponse data) => json.encode(data.toJson());

@freezed
class ListThemesResponse with _$ListThemesResponse {
    const factory ListThemesResponse({
        @JsonKey(name: "themes")
        List<Theme>? themes,
    }) = _ListThemesResponse;

    factory ListThemesResponse.fromJson(Map<String, dynamic> json) => _$ListThemesResponseFromJson(json);
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
