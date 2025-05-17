// To parse this JSON data, do
//
//     final updateRedirectPathUriResponse = updateRedirectPathUriResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_redirect_path_uri_response.freezed.dart';
part 'update_redirect_path_uri_response.g.dart';

UpdateRedirectPathUriResponse updateRedirectPathUriResponseFromJson(String str) => UpdateRedirectPathUriResponse.fromJson(json.decode(str));

String updateRedirectPathUriResponseToJson(UpdateRedirectPathUriResponse data) => json.encode(data.toJson());

@freezed
class UpdateRedirectPathUriResponse with _$UpdateRedirectPathUriResponse {
    const factory UpdateRedirectPathUriResponse({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _UpdateRedirectPathUriResponse;

    factory UpdateRedirectPathUriResponse.fromJson(Map<String, dynamic> json) => _$UpdateRedirectPathUriResponseFromJson(json);
}

@freezed
class Redirect with _$Redirect {
    const factory Redirect({
        @JsonKey(name: "path")
        String? path,
        @JsonKey(name: "target")
        String? target,
        @JsonKey(name: "id")
        int? id,
    }) = _Redirect;

    factory Redirect.fromJson(Map<String, dynamic> json) => _$RedirectFromJson(json);
}
