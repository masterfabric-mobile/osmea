// To parse this JSON data, do
//
//     final createArticleWithImageRequest = createArticleWithImageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_article_with_image_request.freezed.dart';
part 'create_article_with_image_request.g.dart';

CreateArticleWithImageRequest createArticleWithImageRequestFromJson(String str) => CreateArticleWithImageRequest.fromJson(json.decode(str));

String createArticleWithImageRequestToJson(CreateArticleWithImageRequest data) => json.encode(data.toJson());

@freezed
class CreateArticleWithImageRequest with _$CreateArticleWithImageRequest {
    const factory CreateArticleWithImageRequest({
        @JsonKey(name: "article")
        Article? article,
    }) = _CreateArticleWithImageRequest;

    factory CreateArticleWithImageRequest.fromJson(Map<String, dynamic> json) => _$CreateArticleWithImageRequestFromJson(json);
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
        @JsonKey(name: "src")
        String? src,
        @JsonKey(name: "alt")
        String? alt,
    }) = _Image;

    factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
