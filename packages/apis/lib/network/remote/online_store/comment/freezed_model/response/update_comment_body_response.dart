// To parse this JSON data, do
//
//     final updateCommentBodyResponse = updateCommentBodyResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_comment_body_response.freezed.dart';
part 'update_comment_body_response.g.dart';

UpdateCommentBodyResponse updateCommentBodyResponseFromJson(String str) => UpdateCommentBodyResponse.fromJson(json.decode(str));

String updateCommentBodyResponseToJson(UpdateCommentBodyResponse data) => json.encode(data.toJson());

@freezed
class UpdateCommentBodyResponse with _$UpdateCommentBodyResponse {
    const factory UpdateCommentBodyResponse({
        @JsonKey(name: "comment")
        Comment? comment,
    }) = _UpdateCommentBodyResponse;

    factory UpdateCommentBodyResponse.fromJson(Map<String, dynamic> json) => _$UpdateCommentBodyResponseFromJson(json);
}

@freezed
class Comment with _$Comment {
    const factory Comment({
        @JsonKey(name: "body")
        String? body,
        @JsonKey(name: "published_at")
        String? publishedAt,
        @JsonKey(name: "id")
        int? id,
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
    }) = _Comment;

    factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
