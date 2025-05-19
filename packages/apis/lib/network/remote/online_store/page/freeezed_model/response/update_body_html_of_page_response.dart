// To parse this JSON data, do
//
//     final updateBodyHtmlOfPageResponse = updateBodyHtmlOfPageResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_body_html_of_page_response.freezed.dart';
part 'update_body_html_of_page_response.g.dart';

UpdateBodyHtmlOfPageResponse updateBodyHtmlOfPageResponseFromJson(String str) => UpdateBodyHtmlOfPageResponse.fromJson(json.decode(str));

String updateBodyHtmlOfPageResponseToJson(UpdateBodyHtmlOfPageResponse data) => json.encode(data.toJson());

@freezed
class UpdateBodyHtmlOfPageResponse with _$UpdateBodyHtmlOfPageResponse {
    const factory UpdateBodyHtmlOfPageResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _UpdateBodyHtmlOfPageResponse;

    factory UpdateBodyHtmlOfPageResponse.fromJson(Map<String, dynamic> json) => _$UpdateBodyHtmlOfPageResponseFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "shop_id")
        int? shopId,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "handle")
        String? handle,
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
