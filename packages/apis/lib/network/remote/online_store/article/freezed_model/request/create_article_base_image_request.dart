// To parse this JSON data, do
//
//     final createArticleBaseImageRequest = createArticleBaseImageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_article_base_image_request.freezed.dart';
part 'create_article_base_image_request.g.dart';

CreateArticleBaseImageRequest createArticleBaseImageRequestFromJson(String str) => CreateArticleBaseImageRequest.fromJson(json.decode(str));

String createArticleBaseImageRequestToJson(CreateArticleBaseImageRequest data) => json.encode(data.toJson());

@freezed
class CreateArticleBaseImageRequest with _$CreateArticleBaseImageRequest {
    const factory CreateArticleBaseImageRequest({
        @JsonKey(name: "article")
        Article? article,
    }) = _CreateArticleBaseImageRequest;

    factory CreateArticleBaseImageRequest.fromJson(Map<String, dynamic> json) => _$CreateArticleBaseImageRequestFromJson(json);
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
        @JsonKey(name: "image")
        Image? image,
    }) = _Article;

    factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}

@freezed
class Image with _$Image {
    const factory Image({
        @JsonKey(name: "attachment")
        String? attachment,
    }) = _Image;

    factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
