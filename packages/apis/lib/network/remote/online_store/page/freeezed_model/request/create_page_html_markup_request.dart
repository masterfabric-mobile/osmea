// To parse this JSON data, do
//
//     final createPageHtmlMarkupRequest = createPageHtmlMarkupRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_page_html_markup_request.freezed.dart';
part 'create_page_html_markup_request.g.dart';

CreatePageHtmlMarkupRequest createPageHtmlMarkupRequestFromJson(String str) => CreatePageHtmlMarkupRequest.fromJson(json.decode(str));

String createPageHtmlMarkupRequestToJson(CreatePageHtmlMarkupRequest data) => json.encode(data.toJson());

@freezed
class CreatePageHtmlMarkupRequest with _$CreatePageHtmlMarkupRequest {
    const factory CreatePageHtmlMarkupRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _CreatePageHtmlMarkupRequest;

    factory CreatePageHtmlMarkupRequest.fromJson(Map<String, dynamic> json) => _$CreatePageHtmlMarkupRequestFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "body_html")
        String? bodyHtml,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
