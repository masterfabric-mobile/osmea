// To parse this JSON data, do
//
//     final listAllCommentsResponse = listAllCommentsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_comments_response.freezed.dart';
part 'list_all_comments_response.g.dart';

ListAllCommentsResponse listAllCommentsResponseFromJson(String str) => ListAllCommentsResponse.fromJson(json.decode(str));

String listAllCommentsResponseToJson(ListAllCommentsResponse data) => json.encode(data.toJson());

@freezed
class ListAllCommentsResponse with _$ListAllCommentsResponse {
    const factory ListAllCommentsResponse({
        @JsonKey(name: "comments")
        List<Comment>? comments,
    }) = _ListAllCommentsResponse;

    factory ListAllCommentsResponse.fromJson(Map<String, dynamic> json) => _$ListAllCommentsResponseFromJson(json);
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
        String? publishedAt,
    }) = _Comment;

    factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
