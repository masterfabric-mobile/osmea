// To parse this JSON data, do
//
//     final specificCustomCollectionsResponse = specificCustomCollectionsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'specific_custom_collections_response.freezed.dart';
part 'specific_custom_collections_response.g.dart';

SpecificCustomCollectionsResponse specificCustomCollectionsResponseFromJson(String str) => SpecificCustomCollectionsResponse.fromJson(json.decode(str));

String specificCustomCollectionsResponseToJson(SpecificCustomCollectionsResponse data) => json.encode(data.toJson());

@freezed
class SpecificCustomCollectionsResponse with _$SpecificCustomCollectionsResponse {
    const factory SpecificCustomCollectionsResponse({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
    }) = _SpecificCustomCollectionsResponse;

    factory SpecificCustomCollectionsResponse.fromJson(Map<String, dynamic> json) => _$SpecificCustomCollectionsResponseFromJson(json);
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
        @JsonKey(name: "products_count")
        int? productsCount,
        @JsonKey(name: "published_scope")
        String? publishedScope,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}
