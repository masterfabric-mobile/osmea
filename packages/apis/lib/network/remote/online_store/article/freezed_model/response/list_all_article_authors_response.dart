// To parse this JSON data, do
//
//     final listAllArticleAuthorsResponse = listAllArticleAuthorsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_article_authors_response.freezed.dart';
part 'list_all_article_authors_response.g.dart';

ListAllArticleAuthorsResponse listAllArticleAuthorsResponseFromJson(String str) => ListAllArticleAuthorsResponse.fromJson(json.decode(str));

String listAllArticleAuthorsResponseToJson(ListAllArticleAuthorsResponse data) => json.encode(data.toJson());

@freezed
class ListAllArticleAuthorsResponse with _$ListAllArticleAuthorsResponse {
    const factory ListAllArticleAuthorsResponse({
        @JsonKey(name: "authors")
        List<String>? authors,
    }) = _ListAllArticleAuthorsResponse;

    factory ListAllArticleAuthorsResponse.fromJson(Map<String, dynamic> json) => _$ListAllArticleAuthorsResponseFromJson(json);
}
