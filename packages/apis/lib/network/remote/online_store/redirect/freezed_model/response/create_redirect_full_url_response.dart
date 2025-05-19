// To parse this JSON data, do
//
//     final createRedirectFullUrlResponse = createRedirectFullUrlResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_redirect_full_url_response.freezed.dart';
part 'create_redirect_full_url_response.g.dart';

CreateRedirectFullUrlResponse createRedirectFullUrlResponseFromJson(String str) => CreateRedirectFullUrlResponse.fromJson(json.decode(str));

String createRedirectFullUrlResponseToJson(CreateRedirectFullUrlResponse data) => json.encode(data.toJson());

@freezed
class CreateRedirectFullUrlResponse with _$CreateRedirectFullUrlResponse {
    const factory CreateRedirectFullUrlResponse({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _CreateRedirectFullUrlResponse;

    factory CreateRedirectFullUrlResponse.fromJson(Map<String, dynamic> json) => _$CreateRedirectFullUrlResponseFromJson(json);
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
