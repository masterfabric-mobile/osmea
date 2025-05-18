// To parse this JSON data, do
//
//     final updateExistingBlogTitleResponse = updateExistingBlogTitleResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_existing_blog_title_response.freezed.dart';
part 'update_existing_blog_title_response.g.dart';

UpdateExistingBlogTitleResponse updateExistingBlogTitleResponseFromJson(String str) => UpdateExistingBlogTitleResponse.fromJson(json.decode(str));

String updateExistingBlogTitleResponseToJson(UpdateExistingBlogTitleResponse data) => json.encode(data.toJson());

@freezed
class UpdateExistingBlogTitleResponse with _$UpdateExistingBlogTitleResponse {
    const factory UpdateExistingBlogTitleResponse({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _UpdateExistingBlogTitleResponse;

    factory UpdateExistingBlogTitleResponse.fromJson(Map<String, dynamic> json) => _$UpdateExistingBlogTitleResponseFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "commentable")
        String? commentable,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "updated_at")
        String? updatedAt,
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
