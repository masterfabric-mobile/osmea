// To parse this JSON data, do
//
//     final addMetafieldToPageRequest = addMetafieldToPageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'add_metafield_to_page_request.freezed.dart';
part 'add_metafield_to_page_request.g.dart';

AddMetafieldToPageRequest addMetafieldToPageRequestFromJson(String str) => AddMetafieldToPageRequest.fromJson(json.decode(str));

String addMetafieldToPageRequestToJson(AddMetafieldToPageRequest data) => json.encode(data.toJson());

@freezed
class AddMetafieldToPageRequest with _$AddMetafieldToPageRequest {
    const factory AddMetafieldToPageRequest({
        @JsonKey(name: "page")
        Page? page,
    }) = _AddMetafieldToPageRequest;

    factory AddMetafieldToPageRequest.fromJson(Map<String, dynamic> json) => _$AddMetafieldToPageRequestFromJson(json);
}

@freezed
class Page with _$Page {
    const factory Page({
        @JsonKey(name: "id")
        int? id,
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
