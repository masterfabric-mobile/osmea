// To parse this JSON data, do
//
//     final getSingleRedirectResponse = getSingleRedirectResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_single_redirect_response.freezed.dart';
part 'get_single_redirect_response.g.dart';

GetSingleRedirectResponse getSingleRedirectResponseFromJson(String str) => GetSingleRedirectResponse.fromJson(json.decode(str));

String getSingleRedirectResponseToJson(GetSingleRedirectResponse data) => json.encode(data.toJson());

@freezed
class GetSingleRedirectResponse with _$GetSingleRedirectResponse {
    const factory GetSingleRedirectResponse({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _GetSingleRedirectResponse;

    factory GetSingleRedirectResponse.fromJson(Map<String, dynamic> json) => _$GetSingleRedirectResponseFromJson(json);
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
