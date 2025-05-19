// To parse this JSON data, do
//
//     final listTagsAllArticlesResponse = listTagsAllArticlesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_tags_all_articles_response.freezed.dart';
part 'list_tags_all_articles_response.g.dart';

ListTagsAllArticlesResponse listTagsAllArticlesResponseFromJson(String str) => ListTagsAllArticlesResponse.fromJson(json.decode(str));

String listTagsAllArticlesResponseToJson(ListTagsAllArticlesResponse data) => json.encode(data.toJson());

@freezed
class ListTagsAllArticlesResponse with _$ListTagsAllArticlesResponse {
    const factory ListTagsAllArticlesResponse({
        @JsonKey(name: "tags")
        List<String>? tags,
    }) = _ListTagsAllArticlesResponse;

    factory ListTagsAllArticlesResponse.fromJson(Map<String, dynamic> json) => _$ListTagsAllArticlesResponseFromJson(json);
}
