// To parse this JSON data, do
//
//     final updateRedirectPathAndTargetRequest = updateRedirectPathAndTargetRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_redirect_path_and_target_request.freezed.dart';
part 'update_redirect_path_and_target_request.g.dart';

UpdateRedirectPathAndTargetRequest updateRedirectPathAndTargetRequestFromJson(String str) => UpdateRedirectPathAndTargetRequest.fromJson(json.decode(str));

String updateRedirectPathAndTargetRequestToJson(UpdateRedirectPathAndTargetRequest data) => json.encode(data.toJson());

@freezed
class UpdateRedirectPathAndTargetRequest with _$UpdateRedirectPathAndTargetRequest {
    const factory UpdateRedirectPathAndTargetRequest({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _UpdateRedirectPathAndTargetRequest;

    factory UpdateRedirectPathAndTargetRequest.fromJson(Map<String, dynamic> json) => _$UpdateRedirectPathAndTargetRequestFromJson(json);
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
