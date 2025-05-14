// To parse this JSON data, do
//
//     final updateExistingBlogTitleRequest = updateExistingBlogTitleRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_existing_blog_title_request.freezed.dart';
part 'update_existing_blog_title_request.g.dart';

UpdateExistingBlogTitleRequest updateExistingBlogTitleRequestFromJson(String str) => UpdateExistingBlogTitleRequest.fromJson(json.decode(str));

String updateExistingBlogTitleRequestToJson(UpdateExistingBlogTitleRequest data) => json.encode(data.toJson());

@freezed
class UpdateExistingBlogTitleRequest with _$UpdateExistingBlogTitleRequest {
    const factory UpdateExistingBlogTitleRequest({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _UpdateExistingBlogTitleRequest;

    factory UpdateExistingBlogTitleRequest.fromJson(Map<String, dynamic> json) => _$UpdateExistingBlogTitleRequestFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "handle")
        String? handle,
        @JsonKey(name: "commentable")
        String? commentable,
    }) = _Blog;

    factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
}
