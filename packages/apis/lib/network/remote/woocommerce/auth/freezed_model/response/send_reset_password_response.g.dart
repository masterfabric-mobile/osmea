// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_reset_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SendResetPasswordResponseImpl _$$SendResetPasswordResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SendResetPasswordResponseImpl(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$SendResetPasswordResponseImplToJson(
    _$SendResetPasswordResponseImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('success', instance.success);
  writeNotNull('message', instance.message);
  return val;
}
