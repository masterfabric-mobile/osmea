// To parse this JSON data, do
//
//     final publishUnpublishedThemeRequest = publishUnpublishedThemeRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'publish_unpublished_theme_request.freezed.dart';
part 'publish_unpublished_theme_request.g.dart';

PublishUnpublishedThemeRequest publishUnpublishedThemeRequestFromJson(String str) => PublishUnpublishedThemeRequest.fromJson(json.decode(str));

String publishUnpublishedThemeRequestToJson(PublishUnpublishedThemeRequest data) => json.encode(data.toJson());

@freezed
class PublishUnpublishedThemeRequest with _$PublishUnpublishedThemeRequest {
    const factory PublishUnpublishedThemeRequest({
        @JsonKey(name: "theme")
        Theme? theme,
    }) = _PublishUnpublishedThemeRequest;

    factory PublishUnpublishedThemeRequest.fromJson(Map<String, dynamic> json) => _$PublishUnpublishedThemeRequestFromJson(json);
}

@freezed
class Theme with _$Theme {
    const factory Theme({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "role")
        String? role,
    }) = _Theme;

    factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
}
