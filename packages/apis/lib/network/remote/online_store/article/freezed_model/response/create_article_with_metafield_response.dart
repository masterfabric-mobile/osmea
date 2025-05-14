// To parse this JSON data, do
//
//     final createArticleWithMetafieldResponse = createArticleWithMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_article_with_metafield_response.freezed.dart';
part 'create_article_with_metafield_response.g.dart';

CreateArticleWithMetafieldResponse createArticleWithMetafieldResponseFromJson(String str) => CreateArticleWithMetafieldResponse.fromJson(json.decode(str));

String createArticleWithMetafieldResponseToJson(CreateArticleWithMetafieldResponse data) => json.encode(data.toJson());

@freezed
class CreateArticleWithMetafieldResponse with _$CreateArticleWithMetafieldResponse {
    const factory CreateArticleWithMetafieldResponse({
        @JsonKey(name: "article")
        Article? article,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateArticleWithMetafieldResponse;

    factory CreateArticleWithMetafieldResponse.fromJson(Map<String, dynamic> json) => _$CreateArticleWithMetafieldResponseFromJson(json);
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

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
