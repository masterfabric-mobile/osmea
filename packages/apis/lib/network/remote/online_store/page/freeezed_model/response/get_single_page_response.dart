// To parse this JSON data, do
//
//     final getSinglePageResponse = getSinglePageResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_single_page_response.freezed.dart';
part 'get_single_page_response.g.dart';

GetSinglePageResponse getSinglePageResponseFromJson(String str) => GetSinglePageResponse.fromJson(json.decode(str));

String getSinglePageResponseToJson(GetSinglePageResponse data) => json.encode(data.toJson());

@freezed
class GetSinglePageResponse with _$GetSinglePageResponse {
    const factory GetSinglePageResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _GetSinglePageResponse;

    factory GetSinglePageResponse.fromJson(Map<String, dynamic> json) => _$GetSinglePageResponseFromJson(json);
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
