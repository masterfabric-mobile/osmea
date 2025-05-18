// To parse this JSON data, do
//
//     final updateArticleRequest = updateArticleRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_article_request.freezed.dart';
part 'update_article_request.g.dart';

UpdateArticleRequest updateArticleRequestFromJson(String str) => UpdateArticleRequest.fromJson(json.decode(str));

String updateArticleRequestToJson(UpdateArticleRequest data) => json.encode(data.toJson());

@freezed
class UpdateArticleRequest with _$UpdateArticleRequest {
    const factory UpdateArticleRequest({
        @JsonKey(name: "article")
        required Article article,
    }) = _UpdateArticleRequest;

    factory UpdateArticleRequest.fromJson(Map<String, dynamic> json) => _$UpdateArticleRequestFromJson(json);
}

@freezed
class Article with _$Article {
    const factory Article({
        @JsonKey(name: "id")
        required int id,
        @JsonKey(name: "metafields")
        required List<Metafield> metafields,
    }) = _Article;

    factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "value")
        required String value,
        @JsonKey(name: "type")
        required String type,
        @JsonKey(name: "namespace")
        required String namespace,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
