// To parse this JSON data, do
//
//     final updateRedirectPathAndTargetResponse = updateRedirectPathAndTargetResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_redirect_path_and_target_response.freezed.dart';
part 'update_redirect_path_and_target_response.g.dart';

UpdateRedirectPathAndTargetResponse updateRedirectPathAndTargetResponseFromJson(String str) => UpdateRedirectPathAndTargetResponse.fromJson(json.decode(str));

String updateRedirectPathAndTargetResponseToJson(UpdateRedirectPathAndTargetResponse data) => json.encode(data.toJson());

@freezed
class UpdateRedirectPathAndTargetResponse with _$UpdateRedirectPathAndTargetResponse {
    const factory UpdateRedirectPathAndTargetResponse({
        @JsonKey(name: "redirect")
        Redirect? redirect,
    }) = _UpdateRedirectPathAndTargetResponse;

    factory UpdateRedirectPathAndTargetResponse.fromJson(Map<String, dynamic> json) => _$UpdateRedirectPathAndTargetResponseFromJson(json);
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
