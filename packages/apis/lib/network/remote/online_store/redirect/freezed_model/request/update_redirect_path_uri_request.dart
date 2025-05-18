// To parse this JSON data, do
//
//     final updateRedirectPathUriRequest = updateRedirectPathUriRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_redirect_path_uri_request.freezed.dart';
part 'update_redirect_path_uri_request.g.dart';

UpdateRedirectPathUriRequest updateRedirectPathUriRequestFromJson(String str) => UpdateRedirectPathUriRequest.fromJson(json.decode(str));

String updateRedirectPathUriRequestToJson(UpdateRedirectPathUriRequest data) => json.encode(data.toJson());

@freezed
class UpdateRedirectPathUriRequest with _$UpdateRedirectPathUriRequest {
    const factory UpdateRedirectPathUriRequest({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _UpdateRedirectPathUriRequest;

    factory UpdateRedirectPathUriRequest.fromJson(Map<String, dynamic> json) => _$UpdateRedirectPathUriRequestFromJson(json);
}

@freezed
class Redirect with _$Redirect {
    const factory Redirect({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "path")
        String? path,
    }) = _Redirect;

    factory Redirect.fromJson(Map<String, dynamic> json) => _$RedirectFromJson(json);
}
