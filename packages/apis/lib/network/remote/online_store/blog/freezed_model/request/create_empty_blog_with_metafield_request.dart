// To parse this JSON data, do
//
//     final createEmptyBlogWithMetafieldRequest = createEmptyBlogWithMetafieldRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_empty_blog_with_metafield_request.freezed.dart';
part 'create_empty_blog_with_metafield_request.g.dart';

CreateEmptyBlogWithMetafieldRequest createEmptyBlogWithMetafieldRequestFromJson(String str) => CreateEmptyBlogWithMetafieldRequest.fromJson(json.decode(str));

String createEmptyBlogWithMetafieldRequestToJson(CreateEmptyBlogWithMetafieldRequest data) => json.encode(data.toJson());

@freezed
class CreateEmptyBlogWithMetafieldRequest with _$CreateEmptyBlogWithMetafieldRequest {
    const factory CreateEmptyBlogWithMetafieldRequest({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _CreateEmptyBlogWithMetafieldRequest;

    factory CreateEmptyBlogWithMetafieldRequest.fromJson(Map<String, dynamic> json) => _$CreateEmptyBlogWithMetafieldRequestFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "metafields")
        List<Metafield>? metafields,
    }) = _Blog;

    factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "key")
        String? key,
        @JsonKey(name: "value")
        String? value,
        @JsonKey(name: "type")
        String? type,
        @JsonKey(name: "namespace")
        String? namespace,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
