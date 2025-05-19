// To parse this JSON data, do
//
//     final showHiddenPageResponse = showHiddenPageResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'show_hidden_page_response.freezed.dart';
part 'show_hidden_page_response.g.dart';

ShowHiddenPageResponse showHiddenPageResponseFromJson(String str) => ShowHiddenPageResponse.fromJson(json.decode(str));

String showHiddenPageResponseToJson(ShowHiddenPageResponse data) => json.encode(data.toJson());

@freezed
class ShowHiddenPageResponse with _$ShowHiddenPageResponse {
    const factory ShowHiddenPageResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _ShowHiddenPageResponse;

    factory ShowHiddenPageResponse.fromJson(Map<String, dynamic> json) => _$ShowHiddenPageResponseFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "shop_id")
        int? shopId,
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
        @JsonKey(name: "published_at")
        String? publishedAt,
        @JsonKey(name: "template_suffix")
        String? templateSuffix,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
