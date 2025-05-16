// To parse this JSON data, do
//
//     final getSingleCommentResponse = getSingleCommentResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_single_comment_response.freezed.dart';
part 'get_single_comment_response.g.dart';

GetSingleCommentResponse getSingleCommentResponseFromJson(String str) => GetSingleCommentResponse.fromJson(json.decode(str));

String getSingleCommentResponseToJson(GetSingleCommentResponse data) => json.encode(data.toJson());

@freezed
class GetSingleCommentResponse with _$GetSingleCommentResponse {
    const factory GetSingleCommentResponse({
        @JsonKey(name: "comment")
        Comment? comment,
    }) = _GetSingleCommentResponse;

    factory GetSingleCommentResponse.fromJson(Map<String, dynamic> json) => _$GetSingleCommentResponseFromJson(json);
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
