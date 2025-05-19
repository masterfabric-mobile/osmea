// To parse this JSON data, do
//
//     final approveAndPublishCommentResponse = approveAndPublishCommentResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'approve_and_publish_comment_response.freezed.dart';
part 'approve_and_publish_comment_response.g.dart';

ApproveAndPublishCommentResponse approveAndPublishCommentResponseFromJson(String str) => ApproveAndPublishCommentResponse.fromJson(json.decode(str));

String approveAndPublishCommentResponseToJson(ApproveAndPublishCommentResponse data) => json.encode(data.toJson());

@freezed
class ApproveAndPublishCommentResponse with _$ApproveAndPublishCommentResponse {
    const factory ApproveAndPublishCommentResponse({
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
    }) = _ApproveAndPublishCommentResponse;

    factory ApproveAndPublishCommentResponse.fromJson(Map<String, dynamic> json) => _$ApproveAndPublishCommentResponseFromJson(json);
}
