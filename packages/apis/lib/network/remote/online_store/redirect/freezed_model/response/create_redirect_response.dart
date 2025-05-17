// To parse this JSON data, do
//
//     final createRedirectResponse = createRedirectResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_redirect_response.freezed.dart';
part 'create_redirect_response.g.dart';

CreateRedirectResponse createRedirectResponseFromJson(String str) => CreateRedirectResponse.fromJson(json.decode(str));

String createRedirectResponseToJson(CreateRedirectResponse data) => json.encode(data.toJson());

@freezed
class CreateRedirectResponse with _$CreateRedirectResponse {
    const factory CreateRedirectResponse({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _CreateRedirectResponse;

    factory CreateRedirectResponse.fromJson(Map<String, dynamic> json) => _$CreateRedirectResponseFromJson(json);
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
