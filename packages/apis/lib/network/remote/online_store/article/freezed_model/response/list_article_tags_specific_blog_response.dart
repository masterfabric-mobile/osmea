// To parse this JSON data, do
//
//     final listArticleTagsSpecificBlogResponse = listArticleTagsSpecificBlogResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_article_tags_specific_blog_response.freezed.dart';
part 'list_article_tags_specific_blog_response.g.dart';

ListArticleTagsSpecificBlogResponse listArticleTagsSpecificBlogResponseFromJson(String str) => ListArticleTagsSpecificBlogResponse.fromJson(json.decode(str));

String listArticleTagsSpecificBlogResponseToJson(ListArticleTagsSpecificBlogResponse data) => json.encode(data.toJson());

@freezed
class ListArticleTagsSpecificBlogResponse with _$ListArticleTagsSpecificBlogResponse {
    const factory ListArticleTagsSpecificBlogResponse({
        @JsonKey(name: "tags")
        List<String>? tags,
    }) = _ListArticleTagsSpecificBlogResponse;

    factory ListArticleTagsSpecificBlogResponse.fromJson(Map<String, dynamic> json) => _$ListArticleTagsSpecificBlogResponseFromJson(json);
}
