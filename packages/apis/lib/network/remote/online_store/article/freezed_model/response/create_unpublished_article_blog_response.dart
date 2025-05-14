// To parse this JSON data, do
//
//     final createUnpublishedArticleBlogResponse = createUnpublishedArticleBlogResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_unpublished_article_blog_response.freezed.dart';
part 'create_unpublished_article_blog_response.g.dart';

CreateUnpublishedArticleBlogResponse createUnpublishedArticleBlogResponseFromJson(String str) => CreateUnpublishedArticleBlogResponse.fromJson(json.decode(str));

String createUnpublishedArticleBlogResponseToJson(CreateUnpublishedArticleBlogResponse data) => json.encode(data.toJson());

@freezed
class CreateUnpublishedArticleBlogResponse with _$CreateUnpublishedArticleBlogResponse {
    const factory CreateUnpublishedArticleBlogResponse({
        @JsonKey(name: "article")
        Article? article,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateUnpublishedArticleBlogResponse;

    factory CreateUnpublishedArticleBlogResponse.fromJson(Map<String, dynamic> json) => _$CreateUnpublishedArticleBlogResponseFromJson(json);
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

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
