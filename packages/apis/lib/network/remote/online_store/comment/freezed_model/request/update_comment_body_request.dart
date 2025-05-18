// To parse this JSON data, do
//
//     final updateCommentBodyRequest = updateCommentBodyRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_comment_body_request.freezed.dart';
part 'update_comment_body_request.g.dart';

UpdateCommentBodyRequest updateCommentBodyRequestFromJson(String str) => UpdateCommentBodyRequest.fromJson(json.decode(str));

String updateCommentBodyRequestToJson(UpdateCommentBodyRequest data) => json.encode(data.toJson());

@freezed
class UpdateCommentBodyRequest with _$UpdateCommentBodyRequest {
    const factory UpdateCommentBodyRequest({
        @JsonKey(name: "comment")
        Comment? comment,
    }) = _UpdateCommentBodyRequest;

    factory UpdateCommentBodyRequest.fromJson(Map<String, dynamic> json) => _$UpdateCommentBodyRequestFromJson(json);
}

@freezed
class Comment with _$Comment {
    const factory Comment({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "body")
        String? body,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "email")
        String? email,
        @JsonKey(name: "published_at")
        String? publishedAt,
    }) = _Comment;

    factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
