// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserProfileRequestImpl _$$UpdateUserProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateUserProfileRequestImpl(
      email: json['email'] as String?,
      displayName: json['display_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      nickname: json['nickname'] as String?,
      password: json['password'] as String?,
      billing: json['billing'] as Map<String, dynamic>?,
      shipping: json['shipping'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UpdateUserProfileRequestImplToJson(
    _$UpdateUserProfileRequestImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('display_name', instance.displayName);
  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull('nickname', instance.nickname);
  writeNotNull('password', instance.password);
  writeNotNull('billing', instance.billing);
  writeNotNull('shipping', instance.shipping);
  return val;
}
