// To parse this JSON data, do
//
//     final updateArticleResponse = updateArticleResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_article_response.freezed.dart';
part 'update_article_response.g.dart';

UpdateArticleResponse updateArticleResponseFromJson(String str) => UpdateArticleResponse.fromJson(json.decode(str));

String updateArticleResponseToJson(UpdateArticleResponse data) => json.encode(data.toJson());

@freezed
class UpdateArticleResponse with _$UpdateArticleResponse {
    const factory UpdateArticleResponse({
        @JsonKey(name: "article")
        Article? article,
    }) = _UpdateArticleResponse;

    factory UpdateArticleResponse.fromJson(Map<String, dynamic> json) => _$UpdateArticleResponseFromJson(json);
}

@freezed
class Article with _$Article {
    const factory Article({
        @JsonKey(name: "blog_id")
        int? blogId,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "created_at")
        String? createdAt,
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
        @JsonKey(name: "tags")
        String? tags,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
        @JsonKey(name: "image")
        Image? image,
    }) = _Article;

    factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}

@freezed
class Image with _$Image {
    const factory Image({
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "alt")
        String? alt,
        @JsonKey(name: "width")
        int? width,
        @JsonKey(name: "height")
        int? height,
        @JsonKey(name: "src")
        String? src,
    }) = _Image;

    factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
