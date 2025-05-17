// To parse this JSON data, do
//
//     final createPageWithMetafieldResponse = createPageWithMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_page_with_metafield_response.freezed.dart';
part 'create_page_with_metafield_response.g.dart';

CreatePageWithMetafieldResponse createPageWithMetafieldResponseFromJson(String str) => CreatePageWithMetafieldResponse.fromJson(json.decode(str));

String createPageWithMetafieldResponseToJson(CreatePageWithMetafieldResponse data) => json.encode(data.toJson());

@freezed
class CreatePageWithMetafieldResponse with _$CreatePageWithMetafieldResponse {
    const factory CreatePageWithMetafieldResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _CreatePageWithMetafieldResponse;

    factory CreatePageWithMetafieldResponse.fromJson(Map<String, dynamic> json) => _$CreatePageWithMetafieldResponseFromJson(json);
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
