// To parse this JSON data, do
//
//     final createUnpublishedArticleBlogRequest = createUnpublishedArticleBlogRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_unpublished_article_blog_request.freezed.dart';
part 'create_unpublished_article_blog_request.g.dart';

CreateUnpublishedArticleBlogRequest createUnpublishedArticleBlogRequestFromJson(String str) => CreateUnpublishedArticleBlogRequest.fromJson(json.decode(str));

String createUnpublishedArticleBlogRequestToJson(CreateUnpublishedArticleBlogRequest data) => json.encode(data.toJson());

@freezed
class CreateUnpublishedArticleBlogRequest with _$CreateUnpublishedArticleBlogRequest {
    const factory CreateUnpublishedArticleBlogRequest({
        @JsonKey(name: "article")
        Article? article,
    }) = _CreateUnpublishedArticleBlogRequest;

    factory CreateUnpublishedArticleBlogRequest.fromJson(Map<String, dynamic> json) => _$CreateUnpublishedArticleBlogRequestFromJson(json);
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
        @JsonKey(name: "published")
        bool? published,
    }) = _Article;

    factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
