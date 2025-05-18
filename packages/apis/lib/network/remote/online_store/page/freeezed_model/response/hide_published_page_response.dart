// To parse this JSON data, do
//
//     final hidePublishedPageResponse = hidePublishedPageResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'hide_published_page_response.freezed.dart';
part 'hide_published_page_response.g.dart';

HidePublishedPageResponse hidePublishedPageResponseFromJson(String str) => HidePublishedPageResponse.fromJson(json.decode(str));

String hidePublishedPageResponseToJson(HidePublishedPageResponse data) => json.encode(data.toJson());

@freezed
class HidePublishedPageResponse with _$HidePublishedPageResponse {
    const factory HidePublishedPageResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _HidePublishedPageResponse;

    factory HidePublishedPageResponse.fromJson(Map<String, dynamic> json) => _$HidePublishedPageResponseFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "shop_id")
        int? shopId,
        @JsonKey(name: "published_at")
        dynamic publishedAt,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "template_suffix")
        String? templateSuffix,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
