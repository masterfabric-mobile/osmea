// To parse this JSON data, do
//
//     final metafieldExistingBlogResponse = metafieldExistingBlogResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'metafield_existing_blog_response.freezed.dart';
part 'metafield_existing_blog_response.g.dart';

MetafieldExistingBlogResponse metafieldExistingBlogResponseFromJson(String str) => MetafieldExistingBlogResponse.fromJson(json.decode(str));

String metafieldExistingBlogResponseToJson(MetafieldExistingBlogResponse data) => json.encode(data.toJson());

@freezed
class MetafieldExistingBlogResponse with _$MetafieldExistingBlogResponse {
    const factory MetafieldExistingBlogResponse({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _MetafieldExistingBlogResponse;

    factory MetafieldExistingBlogResponse.fromJson(Map<String, dynamic> json) => _$MetafieldExistingBlogResponseFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "id")
        int? id,
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
