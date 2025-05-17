// To parse this JSON data, do
//
//     final showHiddenPageRequest = showHiddenPageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'show_hidden_page_request.freezed.dart';
part 'show_hidden_page_request.g.dart';

ShowHiddenPageRequest showHiddenPageRequestFromJson(String str) => ShowHiddenPageRequest.fromJson(json.decode(str));

String showHiddenPageRequestToJson(ShowHiddenPageRequest data) => json.encode(data.toJson());

@freezed
class ShowHiddenPageRequest with _$ShowHiddenPageRequest {
    const factory ShowHiddenPageRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _ShowHiddenPageRequest;

    factory ShowHiddenPageRequest.fromJson(Map<String, dynamic> json) => _$ShowHiddenPageRequestFromJson(json);
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
