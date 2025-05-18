// To parse this JSON data, do
//
//     final hidePublishedPageRequest = hidePublishedPageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'hide_published_page_request.freezed.dart';
part 'hide_published_page_request.g.dart';

HidePublishedPageRequest hidePublishedPageRequestFromJson(String str) => HidePublishedPageRequest.fromJson(json.decode(str));

String hidePublishedPageRequestToJson(HidePublishedPageRequest data) => json.encode(data.toJson());

@freezed
class HidePublishedPageRequest with _$HidePublishedPageRequest {
    const factory HidePublishedPageRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _HidePublishedPageRequest;

    factory HidePublishedPageRequest.fromJson(Map<String, dynamic> json) => _$HidePublishedPageRequestFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "published")
        bool? published,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
