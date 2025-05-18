// To parse this JSON data, do
//
//     final updateExistingPageCompletelyResponse = updateExistingPageCompletelyResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_existing_page_completely_response.freezed.dart';
part 'update_existing_page_completely_response.g.dart';

UpdateExistingPageCompletelyResponse updateExistingPageCompletelyResponseFromJson(String str) => UpdateExistingPageCompletelyResponse.fromJson(json.decode(str));

String updateExistingPageCompletelyResponseToJson(UpdateExistingPageCompletelyResponse data) => json.encode(data.toJson());

@freezed
class UpdateExistingPageCompletelyResponse with _$UpdateExistingPageCompletelyResponse {
    const factory UpdateExistingPageCompletelyResponse({
        @JsonKey(name: "page")
        Page? page,
    }) = _UpdateExistingPageCompletelyResponse;

    factory UpdateExistingPageCompletelyResponse.fromJson(Map<String, dynamic> json) => _$UpdateExistingPageCompletelyResponseFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "shop_id")
        int? shopId,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "id")
        int? id,
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
