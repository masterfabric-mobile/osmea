// To parse this JSON data, do
//
//     final removeCommentResponse = removeCommentResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'remove_comment_response.freezed.dart';
part 'remove_comment_response.g.dart';

RemoveCommentResponse removeCommentResponseFromJson(String str) => RemoveCommentResponse.fromJson(json.decode(str));

String removeCommentResponseToJson(RemoveCommentResponse data) => json.encode(data.toJson());

@freezed
class RemoveCommentResponse with _$RemoveCommentResponse {
    const factory RemoveCommentResponse({
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
    }) = _RemoveCommentResponse;

    factory RemoveCommentResponse.fromJson(Map<String, dynamic> json) => _$RemoveCommentResponseFromJson(json);
}
