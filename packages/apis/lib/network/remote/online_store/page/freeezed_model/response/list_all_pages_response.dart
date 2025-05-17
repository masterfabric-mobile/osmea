// To parse this JSON data, do
//
//     final listAllPagesResponse = listAllPagesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_pages_response.freezed.dart';
part 'list_all_pages_response.g.dart';

ListAllPagesResponse listAllPagesResponseFromJson(String str) => ListAllPagesResponse.fromJson(json.decode(str));

String listAllPagesResponseToJson(ListAllPagesResponse data) => json.encode(data.toJson());

@freezed
class ListAllPagesResponse with _$ListAllPagesResponse {
    const factory ListAllPagesResponse({
        @JsonKey(name: "pages")
        List<Page>? pages,
    }) = _ListAllPagesResponse;

    factory ListAllPagesResponse.fromJson(Map<String, dynamic> json) => _$ListAllPagesResponseFromJson(json);
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
        dynamic bodyHtml,
        @JsonKey(name: "author")
        dynamic author,
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
