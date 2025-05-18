// To parse this JSON data, do
//
//     final createCommentTextileMarkupResponse = createCommentTextileMarkupResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_comment_textile_markup_response.freezed.dart';
part 'create_comment_textile_markup_response.g.dart';

CreateCommentTextileMarkupResponse createCommentTextileMarkupResponseFromJson(String str) => CreateCommentTextileMarkupResponse.fromJson(json.decode(str));

String createCommentTextileMarkupResponseToJson(CreateCommentTextileMarkupResponse data) => json.encode(data.toJson());

@freezed
class CreateCommentTextileMarkupResponse with _$CreateCommentTextileMarkupResponse {
    const factory CreateCommentTextileMarkupResponse({
        @JsonKey(name: "comment")
        Comment? comment,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateCommentTextileMarkupResponse;

    factory CreateCommentTextileMarkupResponse.fromJson(Map<String, dynamic> json) => _$CreateCommentTextileMarkupResponseFromJson(json);
}

@freezed
class Comment with _$Comment {
    const factory Comment({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "body")
        String? body,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "status")
        String? status,
        @JsonKey(name: "article_id")
        int? articleId,
        @JsonKey(name: "blog_id")
        int? blogId,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "user_agent")
        dynamic userAgent,
        @JsonKey(name: "published_at")
        dynamic publishedAt,
    }) = _Comment;

    factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "author")
        List<String>? author,
        @JsonKey(name: "body")
        List<String>? body,
        @JsonKey(name: "email")
        List<String>? email,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
