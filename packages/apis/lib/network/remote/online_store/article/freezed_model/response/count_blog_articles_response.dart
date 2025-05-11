// To parse this JSON data, do
//
//     final countBlogArticlesResponse = countBlogArticlesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_blog_articles_response.freezed.dart';
part 'count_blog_articles_response.g.dart';

CountBlogArticlesResponse countBlogArticlesResponseFromJson(String str) => CountBlogArticlesResponse.fromJson(json.decode(str));

String countBlogArticlesResponseToJson(CountBlogArticlesResponse data) => json.encode(data.toJson());

@freezed
class CountBlogArticlesResponse with _$CountBlogArticlesResponse {
    const factory CountBlogArticlesResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountBlogArticlesResponse;

    factory CountBlogArticlesResponse.fromJson(Map<String, dynamic> json) => _$CountBlogArticlesResponseFromJson(json);
}
