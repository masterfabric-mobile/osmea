// To parse this JSON data, do
//
//     final createCustomCollectionResponse = createCustomCollectionResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_custom_collection_response.freezed.dart';
part 'create_custom_collection_response.g.dart';

CreateCustomCollectionResponse createCustomCollectionResponseFromJson(String str) => CreateCustomCollectionResponse.fromJson(json.decode(str));

String createCustomCollectionResponseToJson(CreateCustomCollectionResponse data) => json.encode(data.toJson());

@freezed
class CreateCustomCollectionResponse with _$CreateCustomCollectionResponse {
    const factory CreateCustomCollectionResponse({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateCustomCollectionResponse;

    factory CreateCustomCollectionResponse.fromJson(Map<String, dynamic> json) => _$CreateCustomCollectionResponseFromJson(json);
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

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
