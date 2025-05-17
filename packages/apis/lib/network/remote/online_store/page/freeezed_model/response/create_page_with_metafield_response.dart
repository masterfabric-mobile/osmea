// To parse this JSON data, do
//
//     final createPageWithMetafieldResponse = createPageWithMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_page_with_metafield_response.freezed.dart';
part 'create_page_with_metafield_response.g.dart';

CreatePageWithMetafieldResponse createPageWithMetafieldResponseFromJson(String str) => CreatePageWithMetafieldResponse.fromJson(json.decode(str));

String createPageWithMetafieldResponseToJson(CreatePageWithMetafieldResponse data) => json.encode(data.toJson());

@freezed
class CreatePageWithMetafieldResponse with _$CreatePageWithMetafieldResponse {
    const factory CreatePageWithMetafieldResponse({
        @JsonKey(name: "page")
        Page? page,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreatePageWithMetafieldResponse;

    factory CreatePageWithMetafieldResponse.fromJson(Map<String, dynamic> json) => _$CreatePageWithMetafieldResponseFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "title")
        List<String>? title,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "metafields")
        List<Metafield>? metafields,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
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
