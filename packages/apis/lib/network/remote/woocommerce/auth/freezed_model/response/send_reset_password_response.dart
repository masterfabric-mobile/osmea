// To parse this JSON data, do
//
//     final sendResetPasswordResponse = sendResetPasswordResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'send_reset_password_response.freezed.dart';
part 'send_reset_password_response.g.dart';

SendResetPasswordResponse sendResetPasswordResponseFromJson(String str) => SendResetPasswordResponse.fromJson(json.decode(str));

String sendResetPasswordResponseToJson(SendResetPasswordResponse data) => json.encode(data.toJson());

@freezed
class SendResetPasswordResponse with _$SendResetPasswordResponse {
    const factory SendResetPasswordResponse({
        @JsonKey(name: "success")
        bool? success,
        @JsonKey(name: "message")
        String? message,
    }) = _SendResetPasswordResponse;

    factory SendResetPasswordResponse.fromJson(Map<String, dynamic> json) => _$SendResetPasswordResponseFromJson(json);
}
