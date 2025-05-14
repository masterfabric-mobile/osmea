// To parse this JSON data, do
//
//     final createArticleHtmlMarkupResponse = createArticleHtmlMarkupResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_article_html_markup_response.freezed.dart';
part 'create_article_html_markup_response.g.dart';

CreateArticleHtmlMarkupResponse createArticleHtmlMarkupResponseFromJson(String str) => CreateArticleHtmlMarkupResponse.fromJson(json.decode(str));

String createArticleHtmlMarkupResponseToJson(CreateArticleHtmlMarkupResponse data) => json.encode(data.toJson());

@freezed
class CreateArticleHtmlMarkupResponse with _$CreateArticleHtmlMarkupResponse {
    const factory CreateArticleHtmlMarkupResponse({
        @JsonKey(name: "article")
        Article? article,
    }) = _CreateArticleHtmlMarkupResponse;

    factory CreateArticleHtmlMarkupResponse.fromJson(Map<String, dynamic> json) => _$CreateArticleHtmlMarkupResponseFromJson(json);
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
        String? publishedAt,
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
