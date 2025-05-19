// To parse this JSON data, do
//
//     final createUnpublishedPageResponse = createUnpublishedPageResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_unpublished_page_response.freezed.dart';
part 'create_unpublished_page_response.g.dart';

CreateUnpublishedPageResponse createUnpublishedPageResponseFromJson(String str) => CreateUnpublishedPageResponse.fromJson(json.decode(str));

String createUnpublishedPageResponseToJson(CreateUnpublishedPageResponse data) => json.encode(data.toJson());

@freezed
class CreateUnpublishedPageResponse with _$CreateUnpublishedPageResponse {
    const factory CreateUnpublishedPageResponse({
        @JsonKey(name: "page")
        Page? page,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateUnpublishedPageResponse;

    factory CreateUnpublishedPageResponse.fromJson(Map<String, dynamic> json) => _$CreateUnpublishedPageResponseFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
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
        dynamic publishedAt,
        @JsonKey(name: "template_suffix")
        dynamic templateSuffix,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
