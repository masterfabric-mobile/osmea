// To parse this JSON data, do
//
//     final metafieldExistingBlogRequest = metafieldExistingBlogRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'metafield_existing_blog_request.freezed.dart';
part 'metafield_existing_blog_request.g.dart';

MetafieldExistingBlogRequest metafieldExistingBlogRequestFromJson(String str) => MetafieldExistingBlogRequest.fromJson(json.decode(str));

String metafieldExistingBlogRequestToJson(MetafieldExistingBlogRequest data) => json.encode(data.toJson());

@freezed
class MetafieldExistingBlogRequest with _$MetafieldExistingBlogRequest {
    const factory MetafieldExistingBlogRequest({
        @JsonKey(name: "blog")
        Blog? blog,
    }) = _MetafieldExistingBlogRequest;

    factory MetafieldExistingBlogRequest.fromJson(Map<String, dynamic> json) => _$MetafieldExistingBlogRequestFromJson(json);
}

@freezed
class Blog with _$Blog {
    const factory Blog({
        @JsonKey(name: "id")
        int? id,
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
