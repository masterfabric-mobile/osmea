// To parse this JSON data, do
//
//     final createPageHtmlMarkupResponse = createPageHtmlMarkupResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_page_html_markup_response.freezed.dart';
part 'create_page_html_markup_response.g.dart';

CreatePageHtmlMarkupResponse createPageHtmlMarkupResponseFromJson(String str) => CreatePageHtmlMarkupResponse.fromJson(json.decode(str));

String createPageHtmlMarkupResponseToJson(CreatePageHtmlMarkupResponse data) => json.encode(data.toJson());

@freezed
class CreatePageHtmlMarkupResponse with _$CreatePageHtmlMarkupResponse {
    const factory CreatePageHtmlMarkupResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _CreatePageHtmlMarkupResponse;

    factory CreatePageHtmlMarkupResponse.fromJson(Map<String, dynamic> json) => _$CreatePageHtmlMarkupResponseFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "shop_id")
        int? shopId,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "published_at")
        String? publishedAt,
        @JsonKey(name: "template_suffix")
        dynamic templateSuffix,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
