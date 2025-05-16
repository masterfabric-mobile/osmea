// To parse this JSON data, do
//
//     final markCommentAsSpamResponse = markCommentAsSpamResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'mark_comment_as_spam_response.freezed.dart';
part 'mark_comment_as_spam_response.g.dart';

MarkCommentAsSpamResponse markCommentAsSpamResponseFromJson(String str) => MarkCommentAsSpamResponse.fromJson(json.decode(str));

String markCommentAsSpamResponseToJson(MarkCommentAsSpamResponse data) => json.encode(data.toJson());

@freezed
class MarkCommentAsSpamResponse with _$MarkCommentAsSpamResponse {
    const factory MarkCommentAsSpamResponse({
        @JsonKey(name: "published_at")
        dynamic publishedAt,
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
    }) = _MarkCommentAsSpamResponse;

    factory MarkCommentAsSpamResponse.fromJson(Map<String, dynamic> json) => _$MarkCommentAsSpamResponseFromJson(json);
}
