// To parse this JSON data, do
//
//     final createRedirectFullUrlRequest = createRedirectFullUrlRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_redirect_full_url_request.freezed.dart';
part 'create_redirect_full_url_request.g.dart';

CreateRedirectFullUrlRequest createRedirectFullUrlRequestFromJson(String str) => CreateRedirectFullUrlRequest.fromJson(json.decode(str));

String createRedirectFullUrlRequestToJson(CreateRedirectFullUrlRequest data) => json.encode(data.toJson());

@freezed
class CreateRedirectFullUrlRequest with _$CreateRedirectFullUrlRequest {
    const factory CreateRedirectFullUrlRequest({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _CreateRedirectFullUrlRequest;

    factory CreateRedirectFullUrlRequest.fromJson(Map<String, dynamic> json) => _$CreateRedirectFullUrlRequestFromJson(json);
}

@freezed
class Redirect with _$Redirect {
    const factory Redirect({
        @JsonKey(name: "path")
        String? path,
        @JsonKey(name: "target")
        String? target,
    }) = _Redirect;

    factory Redirect.fromJson(Map<String, dynamic> json) => _$RedirectFromJson(json);
}
