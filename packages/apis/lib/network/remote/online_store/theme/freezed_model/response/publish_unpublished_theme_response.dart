// To parse this JSON data, do
//
//     final publishUnpublishedThemeResponse = publishUnpublishedThemeResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'publish_unpublished_theme_response.freezed.dart';
part 'publish_unpublished_theme_response.g.dart';

PublishUnpublishedThemeResponse publishUnpublishedThemeResponseFromJson(String str) => PublishUnpublishedThemeResponse.fromJson(json.decode(str));

String publishUnpublishedThemeResponseToJson(PublishUnpublishedThemeResponse data) => json.encode(data.toJson());

@freezed
class PublishUnpublishedThemeResponse with _$PublishUnpublishedThemeResponse {
    const factory PublishUnpublishedThemeResponse({
        @JsonKey(name: "theme")
        Theme? theme,
    }) = _PublishUnpublishedThemeResponse;

    factory PublishUnpublishedThemeResponse.fromJson(Map<String, dynamic> json) => _$PublishUnpublishedThemeResponseFromJson(json);
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
