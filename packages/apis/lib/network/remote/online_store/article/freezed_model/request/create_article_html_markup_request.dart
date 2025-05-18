// To parse this JSON data, do
//
//     final createArticleHtmlMarkupRequest = createArticleHtmlMarkupRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_article_html_markup_request.freezed.dart';
part 'create_article_html_markup_request.g.dart';

CreateArticleHtmlMarkupRequest createArticleHtmlMarkupRequestFromJson(String str) => CreateArticleHtmlMarkupRequest.fromJson(json.decode(str));

String createArticleHtmlMarkupRequestToJson(CreateArticleHtmlMarkupRequest data) => json.encode(data.toJson());

@freezed
class CreateArticleHtmlMarkupRequest with _$CreateArticleHtmlMarkupRequest {
    const factory CreateArticleHtmlMarkupRequest({
        @JsonKey(name: "article")
        Article? article,
    }) = _CreateArticleHtmlMarkupRequest;

    factory CreateArticleHtmlMarkupRequest.fromJson(Map<String, dynamic> json) => _$CreateArticleHtmlMarkupRequestFromJson(json);
}

@freezed
class Article with _$Article {
    const factory Article({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "tags")
        String? tags,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "published_at")
        String? publishedAt,
    }) = _Article;

    factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
