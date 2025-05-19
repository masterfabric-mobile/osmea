// To parse this JSON data, do
//
//     final listArticlesFromBlogResponse = listArticlesFromBlogResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_articles_from_blog_response.freezed.dart';
part 'list_articles_from_blog_response.g.dart';

ListArticlesFromBlogResponse listArticlesFromBlogResponseFromJson(String str) => ListArticlesFromBlogResponse.fromJson(json.decode(str));

String listArticlesFromBlogResponseToJson(ListArticlesFromBlogResponse data) => json.encode(data.toJson());

@freezed
class ListArticlesFromBlogResponse with _$ListArticlesFromBlogResponse {
    const factory ListArticlesFromBlogResponse({
        @JsonKey(name: "articles")
        List<Article>? articles,
    }) = _ListArticlesFromBlogResponse;

    factory ListArticlesFromBlogResponse.fromJson(Map<String, dynamic> json) => _$ListArticlesFromBlogResponseFromJson(json);
}

@freezed
class Article with _$Article {
    const factory Article({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "blog_id")
        int? blogId,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "user_id")
        dynamic userId,
        @JsonKey(name: "published_at")
        dynamic publishedAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "summary_html")
        dynamic summaryHtml,
        @JsonKey(name: "template_suffix")
        dynamic templateSuffix,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "tags")
        String? tags,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Article;

    factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
