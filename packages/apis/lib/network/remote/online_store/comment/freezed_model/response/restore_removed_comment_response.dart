// To parse this JSON data, do
//
//     final restoreRemovedCommentResponse = restoreRemovedCommentResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'restore_removed_comment_response.freezed.dart';
part 'restore_removed_comment_response.g.dart';

RestoreRemovedCommentResponse restoreRemovedCommentResponseFromJson(String str) => RestoreRemovedCommentResponse.fromJson(json.decode(str));

String restoreRemovedCommentResponseToJson(RestoreRemovedCommentResponse data) => json.encode(data.toJson());

@freezed
class RestoreRemovedCommentResponse with _$RestoreRemovedCommentResponse {
    const factory RestoreRemovedCommentResponse({
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
    }) = _RestoreRemovedCommentResponse;

    factory RestoreRemovedCommentResponse.fromJson(Map<String, dynamic> json) => _$RestoreRemovedCommentResponseFromJson(json);
}
