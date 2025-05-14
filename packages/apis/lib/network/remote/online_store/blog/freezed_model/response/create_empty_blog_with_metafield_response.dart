// To parse this JSON data, do
//
//     final createEmptyBlogWithMetafieldResponse = createEmptyBlogWithMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_empty_blog_with_metafield_response.freezed.dart';
part 'create_empty_blog_with_metafield_response.g.dart';

CreateEmptyBlogWithMetafieldResponse createEmptyBlogWithMetafieldResponseFromJson(String str) => CreateEmptyBlogWithMetafieldResponse.fromJson(json.decode(str));

String createEmptyBlogWithMetafieldResponseToJson(CreateEmptyBlogWithMetafieldResponse data) => json.encode(data.toJson());

@freezed
class CreateEmptyBlogWithMetafieldResponse with _$CreateEmptyBlogWithMetafieldResponse {
    const factory CreateEmptyBlogWithMetafieldResponse({
        @JsonKey(name: "blog")
        Blog? blog,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateEmptyBlogWithMetafieldResponse;

    factory CreateEmptyBlogWithMetafieldResponse.fromJson(Map<String, dynamic> json) => _$CreateEmptyBlogWithMetafieldResponseFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "commentable")
        String? commentable,
        @JsonKey(name: "feedburner")
        dynamic feedburner,
        @JsonKey(name: "feedburner_location")
        dynamic feedburnerLocation,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "template_suffix")
        dynamic templateSuffix,
        @JsonKey(name: "tags")
        String? tags,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Blog;

    factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
