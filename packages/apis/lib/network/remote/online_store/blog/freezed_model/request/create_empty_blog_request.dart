// To parse this JSON data, do
//
//     final createEmptyBlogRequest = createEmptyBlogRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_empty_blog_request.freezed.dart';
part 'create_empty_blog_request.g.dart';

CreateEmptyBlogRequest createEmptyBlogRequestFromJson(String str) => CreateEmptyBlogRequest.fromJson(json.decode(str));

String createEmptyBlogRequestToJson(CreateEmptyBlogRequest data) => json.encode(data.toJson());

@freezed
class CreateEmptyBlogRequest with _$CreateEmptyBlogRequest {
    const factory CreateEmptyBlogRequest({
        @JsonKey(name: "blog")
        required Blog blog,
    }) = _CreateEmptyBlogRequest;

    factory CreateEmptyBlogRequest.fromJson(Map<String, dynamic> json) => _$CreateEmptyBlogRequestFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "title")
        required String title,
    }) = _Blog;

    factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
}
