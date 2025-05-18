// To parse this JSON data, do
//
//     final createArticleWithMetafieldRequest = createArticleWithMetafieldRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_article_with_metafield_request.freezed.dart';
part 'create_article_with_metafield_request.g.dart';

CreateArticleWithMetafieldRequest createArticleWithMetafieldRequestFromJson(String str) => CreateArticleWithMetafieldRequest.fromJson(json.decode(str));

String createArticleWithMetafieldRequestToJson(CreateArticleWithMetafieldRequest data) => json.encode(data.toJson());

@freezed
class CreateArticleWithMetafieldRequest with _$CreateArticleWithMetafieldRequest {
    const factory CreateArticleWithMetafieldRequest({
        @JsonKey(name: "article")
        Article? article,
    }) = _CreateArticleWithMetafieldRequest;

    factory CreateArticleWithMetafieldRequest.fromJson(Map<String, dynamic> json) => _$CreateArticleWithMetafieldRequestFromJson(json);
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
        @JsonKey(name: "metafields")
        List<Metafield>? metafields,
    }) = _Article;

    factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "key")
        String? key,
        @JsonKey(name: "value")
        String? value,
        @JsonKey(name: "type")
        String? type,
        @JsonKey(name: "namespace")
        String? namespace,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
