// To parse this JSON data, do
//
//     final listMostPopularTagsSpecificBlogResponse = listMostPopularTagsSpecificBlogResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_most_popular_tags_specific_blog_response.freezed.dart';
part 'list_most_popular_tags_specific_blog_response.g.dart';

ListMostPopularTagsSpecificBlogResponse listMostPopularTagsSpecificBlogResponseFromJson(String str) => ListMostPopularTagsSpecificBlogResponse.fromJson(json.decode(str));

String listMostPopularTagsSpecificBlogResponseToJson(ListMostPopularTagsSpecificBlogResponse data) => json.encode(data.toJson());

@freezed
class ListMostPopularTagsSpecificBlogResponse with _$ListMostPopularTagsSpecificBlogResponse {
    const factory ListMostPopularTagsSpecificBlogResponse({
        @JsonKey(name: "tags")
        List<String>? tags,
    }) = _ListMostPopularTagsSpecificBlogResponse;

    factory ListMostPopularTagsSpecificBlogResponse.fromJson(Map<String, dynamic> json) => _$ListMostPopularTagsSpecificBlogResponseFromJson(json);
}
