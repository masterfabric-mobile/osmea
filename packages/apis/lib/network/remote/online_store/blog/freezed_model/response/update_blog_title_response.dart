// To parse this JSON data, do
//
//     final updateBlogTitleResponse = updateBlogTitleResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_blog_title_response.freezed.dart';
part 'update_blog_title_response.g.dart';

UpdateBlogTitleResponse updateBlogTitleResponseFromJson(String str) => UpdateBlogTitleResponse.fromJson(json.decode(str));

String updateBlogTitleResponseToJson(UpdateBlogTitleResponse data) => json.encode(data.toJson());

@freezed
class UpdateBlogTitleResponse with _$UpdateBlogTitleResponse {
    const factory UpdateBlogTitleResponse({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _UpdateBlogTitleResponse;

    factory UpdateBlogTitleResponse.fromJson(Map<String, dynamic> json) => _$UpdateBlogTitleResponseFromJson(json);
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
