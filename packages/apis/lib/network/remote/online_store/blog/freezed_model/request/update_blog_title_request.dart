// To parse this JSON data, do
//
//     final updateBlogTitleRequest = updateBlogTitleRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_blog_title_request.freezed.dart';
part 'update_blog_title_request.g.dart';

UpdateBlogTitleRequest updateBlogTitleRequestFromJson(String str) => UpdateBlogTitleRequest.fromJson(json.decode(str));

String updateBlogTitleRequestToJson(UpdateBlogTitleRequest data) => json.encode(data.toJson());

@freezed
class UpdateBlogTitleRequest with _$UpdateBlogTitleRequest {
    const factory UpdateBlogTitleRequest({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _UpdateBlogTitleRequest;

    factory UpdateBlogTitleRequest.fromJson(Map<String, dynamic> json) => _$UpdateBlogTitleRequestFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "title")
        String? title,
    }) = _Blog;

    factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
}
