// To parse this JSON data, do
//
//     final updateExistingPageCompletelyRequest = updateExistingPageCompletelyRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_existing_page_completely_request.freezed.dart';
part 'update_existing_page_completely_request.g.dart';

UpdateExistingPageCompletelyRequest updateExistingPageCompletelyRequestFromJson(String str) => UpdateExistingPageCompletelyRequest.fromJson(json.decode(str));

String updateExistingPageCompletelyRequestToJson(UpdateExistingPageCompletelyRequest data) => json.encode(data.toJson());

@freezed
class UpdateExistingPageCompletelyRequest with _$UpdateExistingPageCompletelyRequest {
    const factory UpdateExistingPageCompletelyRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _UpdateExistingPageCompletelyRequest;

    factory UpdateExistingPageCompletelyRequest.fromJson(Map<String, dynamic> json) => _$UpdateExistingPageCompletelyRequestFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "body_html")
        String? bodyHtml,
        @JsonKey(name: "author")
        String? author,
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "handle")
        String? handle,
    }) = _Page;

    factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
