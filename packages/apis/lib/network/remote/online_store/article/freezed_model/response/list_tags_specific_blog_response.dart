// To parse this JSON data, do
//
//     final listTagsSpecificBlogResponse = listTagsSpecificBlogResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_tags_specific_blog_response.freezed.dart';
part 'list_tags_specific_blog_response.g.dart';

ListTagsSpecificBlogResponse listTagsSpecificBlogResponseFromJson(String str) => ListTagsSpecificBlogResponse.fromJson(json.decode(str));

String listTagsSpecificBlogResponseToJson(ListTagsSpecificBlogResponse data) => json.encode(data.toJson());

@freezed
class ListTagsSpecificBlogResponse with _$ListTagsSpecificBlogResponse {
    const factory ListTagsSpecificBlogResponse({
        @JsonKey(name: "tags")
        List<String>? tags,
    }) = _ListTagsSpecificBlogResponse;

    factory ListTagsSpecificBlogResponse.fromJson(Map<String, dynamic> json) => _$ListTagsSpecificBlogResponseFromJson(json);
}
