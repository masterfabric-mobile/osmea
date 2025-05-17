// To parse this JSON data, do
//
//     final addMetafieldToPageResponse = addMetafieldToPageResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'add_metafield_to_page_response.freezed.dart';
part 'add_metafield_to_page_response.g.dart';

AddMetafieldToPageResponse addMetafieldToPageResponseFromJson(String str) => AddMetafieldToPageResponse.fromJson(json.decode(str));

String addMetafieldToPageResponseToJson(AddMetafieldToPageResponse data) => json.encode(data.toJson());

@freezed
class AddMetafieldToPageResponse with _$AddMetafieldToPageResponse {
    const factory AddMetafieldToPageResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _AddMetafieldToPageResponse;

    factory AddMetafieldToPageResponse.fromJson(Map<String, dynamic> json) => _$AddMetafieldToPageResponseFromJson(json);
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
