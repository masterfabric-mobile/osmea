// To parse this JSON data, do
//
//     final createUnpublishedPageRequest = createUnpublishedPageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_unpublished_page_request.freezed.dart';
part 'create_unpublished_page_request.g.dart';

CreateUnpublishedPageRequest createUnpublishedPageRequestFromJson(String str) => CreateUnpublishedPageRequest.fromJson(json.decode(str));

String createUnpublishedPageRequestToJson(CreateUnpublishedPageRequest data) => json.encode(data.toJson());

@freezed
class CreateUnpublishedPageRequest with _$CreateUnpublishedPageRequest {
    const factory CreateUnpublishedPageRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _CreateUnpublishedPageRequest;

    factory CreateUnpublishedPageRequest.fromJson(Map<String, dynamic> json) => _$CreateUnpublishedPageRequestFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "published")
        bool? published,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
