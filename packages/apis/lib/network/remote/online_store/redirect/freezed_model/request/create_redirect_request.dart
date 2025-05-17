// To parse this JSON data, do
//
//     final createRedirectRequest = createRedirectRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_redirect_request.freezed.dart';
part 'create_redirect_request.g.dart';

CreateRedirectRequest createRedirectRequestFromJson(String str) => CreateRedirectRequest.fromJson(json.decode(str));

String createRedirectRequestToJson(CreateRedirectRequest data) => json.encode(data.toJson());

@freezed
class CreateRedirectRequest with _$CreateRedirectRequest {
    const factory CreateRedirectRequest({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _CreateRedirectRequest;

    factory CreateRedirectRequest.fromJson(Map<String, dynamic> json) => _$CreateRedirectRequestFromJson(json);
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
