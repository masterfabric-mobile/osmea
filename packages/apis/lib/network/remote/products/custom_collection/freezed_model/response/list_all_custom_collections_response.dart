// To parse this JSON data, do
//
//     final listAllCustomCollectionsResponse = listAllCustomCollectionsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_custom_collections_response.freezed.dart';
part 'list_all_custom_collections_response.g.dart';

ListAllCustomCollectionsResponse listAllCustomCollectionsResponseFromJson(String str) => ListAllCustomCollectionsResponse.fromJson(json.decode(str));

String listAllCustomCollectionsResponseToJson(ListAllCustomCollectionsResponse data) => json.encode(data.toJson());

@freezed
class ListAllCustomCollectionsResponse with _$ListAllCustomCollectionsResponse {
    const factory ListAllCustomCollectionsResponse({
        @JsonKey(name: "custom_collections")
        List<CustomCollection>? customCollections,
    }) = _ListAllCustomCollectionsResponse;

    factory ListAllCustomCollectionsResponse.fromJson(Map<String, dynamic> json) => _$ListAllCustomCollectionsResponseFromJson(json);
}

@freezed
class CustomCollection with _$CustomCollection {
    const factory CustomCollection({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "body_html")
        dynamic bodyHtml,
        @JsonKey(name: "published_at")
        String? publishedAt,
        @JsonKey(name: "sort_order")
        String? sortOrder,
        @JsonKey(name: "template_suffix")
        dynamic templateSuffix,
        @JsonKey(name: "published_scope")
        String? publishedScope,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}
