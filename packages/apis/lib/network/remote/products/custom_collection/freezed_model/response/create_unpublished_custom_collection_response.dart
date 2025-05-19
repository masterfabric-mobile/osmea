// To parse this JSON data, do
//
//     final createUnpublishedCustomCollectionResponse = createUnpublishedCustomCollectionResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_unpublished_custom_collection_response.freezed.dart';
part 'create_unpublished_custom_collection_response.g.dart';

CreateUnpublishedCustomCollectionResponse createUnpublishedCustomCollectionResponseFromJson(String str) => CreateUnpublishedCustomCollectionResponse.fromJson(json.decode(str));

String createUnpublishedCustomCollectionResponseToJson(CreateUnpublishedCustomCollectionResponse data) => json.encode(data.toJson());

@freezed
class CreateUnpublishedCustomCollectionResponse with _$CreateUnpublishedCustomCollectionResponse {
    const factory CreateUnpublishedCustomCollectionResponse({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateUnpublishedCustomCollectionResponse;

    factory CreateUnpublishedCustomCollectionResponse.fromJson(Map<String, dynamic> json) => _$CreateUnpublishedCustomCollectionResponseFromJson(json);
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
        dynamic publishedAt,
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

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
