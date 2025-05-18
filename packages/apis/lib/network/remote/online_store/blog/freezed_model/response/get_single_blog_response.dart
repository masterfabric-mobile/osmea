// To parse this JSON data, do
//
//     final getSingleBlogResponse = getSingleBlogResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_single_blog_response.freezed.dart';
part 'get_single_blog_response.g.dart';

GetSingleBlogResponse getSingleBlogResponseFromJson(String str) => GetSingleBlogResponse.fromJson(json.decode(str));

String getSingleBlogResponseToJson(GetSingleBlogResponse data) => json.encode(data.toJson());

@freezed
class GetSingleBlogResponse with _$GetSingleBlogResponse {
    const factory GetSingleBlogResponse({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _GetSingleBlogResponse;

    factory GetSingleBlogResponse.fromJson(Map<String, dynamic> json) => _$GetSingleBlogResponseFromJson(json);
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
