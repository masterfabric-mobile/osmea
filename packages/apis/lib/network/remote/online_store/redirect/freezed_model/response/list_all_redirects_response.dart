// To parse this JSON data, do
//
//     final listAllRedirectsResponse = listAllRedirectsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_redirects_response.freezed.dart';
part 'list_all_redirects_response.g.dart';

ListAllRedirectsResponse listAllRedirectsResponseFromJson(String str) => ListAllRedirectsResponse.fromJson(json.decode(str));

String listAllRedirectsResponseToJson(ListAllRedirectsResponse data) => json.encode(data.toJson());

@freezed
class ListAllRedirectsResponse with _$ListAllRedirectsResponse {
    const factory ListAllRedirectsResponse({
        @JsonKey(name: "redirects")
        List<Redirect>? redirects,
    }) = _ListAllRedirectsResponse;

    factory ListAllRedirectsResponse.fromJson(Map<String, dynamic> json) => _$ListAllRedirectsResponseFromJson(json);
}

@freezed
class Redirect with _$Redirect {
    const factory Redirect({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "path")
        String? path,
        @JsonKey(name: "target")
        String? target,
    }) = _Redirect;

    factory Redirect.fromJson(Map<String, dynamic> json) => _$RedirectFromJson(json);
}
