// To parse this JSON data, do
//
//     final sendResetPasswordRequest = sendResetPasswordRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'send_reset_password_request.freezed.dart';
part 'send_reset_password_request.g.dart';

SendResetPasswordRequest sendResetPasswordRequestFromJson(String str) => SendResetPasswordRequest.fromJson(json.decode(str));

String sendResetPasswordRequestToJson(SendResetPasswordRequest data) => json.encode(data.toJson());

@freezed
class SendResetPasswordRequest with _$SendResetPasswordRequest {
    const factory SendResetPasswordRequest({
        @JsonKey(name: "email")
        required String email,
    }) = _SendResetPasswordRequest;

    factory SendResetPasswordRequest.fromJson(Map<String, dynamic> json) => _$SendResetPasswordRequestFromJson(json);
}
