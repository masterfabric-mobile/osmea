// To parse this JSON data, do
//
//     final markCommentNotSpamRestoreResponse = markCommentNotSpamRestoreResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'mark_comment_not_spam_restore_response.freezed.dart';
part 'mark_comment_not_spam_restore_response.g.dart';

MarkCommentNotSpamRestoreResponse markCommentNotSpamRestoreResponseFromJson(String str) => MarkCommentNotSpamRestoreResponse.fromJson(json.decode(str));

String markCommentNotSpamRestoreResponseToJson(MarkCommentNotSpamRestoreResponse data) => json.encode(data.toJson());

@freezed
class MarkCommentNotSpamRestoreResponse with _$MarkCommentNotSpamRestoreResponse {
    const factory MarkCommentNotSpamRestoreResponse({
        @JsonKey(name: "published_at")
        String? publishedAt,
        @JsonKey(name: "status")
        String? status,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "body")
        String? body,
        @JsonKey(name: "body_html")
        String? bodyHtml,
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
    }) = _MarkCommentNotSpamRestoreResponse;

    factory MarkCommentNotSpamRestoreResponse.fromJson(Map<String, dynamic> json) => _$MarkCommentNotSpamRestoreResponseFromJson(json);
}
