// To parse this JSON data, do
//
//     final createPageWithMetafieldRequest = createPageWithMetafieldRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_page_with_metafield_request.freezed.dart';
part 'create_page_with_metafield_request.g.dart';

CreatePageWithMetafieldRequest createPageWithMetafieldRequestFromJson(String str) => CreatePageWithMetafieldRequest.fromJson(json.decode(str));

String createPageWithMetafieldRequestToJson(CreatePageWithMetafieldRequest data) => json.encode(data.toJson());

@freezed
class CreatePageWithMetafieldRequest with _$CreatePageWithMetafieldRequest {
    const factory CreatePageWithMetafieldRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _CreatePageWithMetafieldRequest;

    factory CreatePageWithMetafieldRequest.fromJson(Map<String, dynamic> json) => _$CreatePageWithMetafieldRequestFromJson(json);
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
