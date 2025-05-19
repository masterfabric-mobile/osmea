// To parse this JSON data, do
//
//     final updateBodyHtmlOfPageRequest = updateBodyHtmlOfPageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_body_html_of_page_request.freezed.dart';
part 'update_body_html_of_page_request.g.dart';

UpdateBodyHtmlOfPageRequest updateBodyHtmlOfPageRequestFromJson(String str) => UpdateBodyHtmlOfPageRequest.fromJson(json.decode(str));

String updateBodyHtmlOfPageRequestToJson(UpdateBodyHtmlOfPageRequest data) => json.encode(data.toJson());

@freezed
class UpdateBodyHtmlOfPageRequest with _$UpdateBodyHtmlOfPageRequest {
    const factory UpdateBodyHtmlOfPageRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _UpdateBodyHtmlOfPageRequest;

    factory UpdateBodyHtmlOfPageRequest.fromJson(Map<String, dynamic> json) => _$UpdateBodyHtmlOfPageRequestFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "body_html")
        String? bodyHtml,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
