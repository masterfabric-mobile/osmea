// To parse this JSON data, do
//
//     final createCustomCollectionUploadedImageResponse = createCustomCollectionUploadedImageResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_custom_collection_uploaded_image_response.freezed.dart';
part 'create_custom_collection_uploaded_image_response.g.dart';

CreateCustomCollectionUploadedImageResponse createCustomCollectionUploadedImageResponseFromJson(String str) => CreateCustomCollectionUploadedImageResponse.fromJson(json.decode(str));

String createCustomCollectionUploadedImageResponseToJson(CreateCustomCollectionUploadedImageResponse data) => json.encode(data.toJson());

@freezed
class CreateCustomCollectionUploadedImageResponse with _$CreateCustomCollectionUploadedImageResponse {
    const factory CreateCustomCollectionUploadedImageResponse({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateCustomCollectionUploadedImageResponse;

    factory CreateCustomCollectionUploadedImageResponse.fromJson(Map<String, dynamic> json) => _$CreateCustomCollectionUploadedImageResponseFromJson(json);
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
        @JsonKey(name: "image")
        Image? image,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}

@freezed
class Image with _$Image {
    const factory Image({
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "alt")
        String? alt,
        @JsonKey(name: "width")
        int? width,
        @JsonKey(name: "height")
        int? height,
        @JsonKey(name: "src")
        String? src,
    }) = _Image;

    factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
