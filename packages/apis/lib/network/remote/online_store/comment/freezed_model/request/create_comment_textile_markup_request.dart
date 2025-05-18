// To parse this JSON data, do
//
//     final createCommentTextileMarkupRequest = createCommentTextileMarkupRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_comment_textile_markup_request.freezed.dart';
part 'create_comment_textile_markup_request.g.dart';

CreateCommentTextileMarkupRequest createCommentTextileMarkupRequestFromJson(String str) => CreateCommentTextileMarkupRequest.fromJson(json.decode(str));

String createCommentTextileMarkupRequestToJson(CreateCommentTextileMarkupRequest data) => json.encode(data.toJson());

@freezed
class CreateCommentTextileMarkupRequest with _$CreateCommentTextileMarkupRequest {
    const factory CreateCommentTextileMarkupRequest({
        @JsonKey(name: "comment")
        Comment? comment,
    }) = _CreateCommentTextileMarkupRequest;

    factory CreateCommentTextileMarkupRequest.fromJson(Map<String, dynamic> json) => _$CreateCommentTextileMarkupRequestFromJson(json);
}

@freezed
class Comment with _$Comment {
    const factory Comment({
        @JsonKey(name: "body")
        String? body,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "email")
        String? email,
        @JsonKey(name: "ip")
        String? ip,
        @JsonKey(name: "blog_id")
        int? blogId,
        @JsonKey(name: "article_id")
        int? articleId,
    }) = _Comment;

    factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
