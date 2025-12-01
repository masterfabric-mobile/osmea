// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_signup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSignUpDataImpl _$$UserSignUpDataImplFromJson(Map<String, dynamic> json) =>
    _$UserSignUpDataImpl(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String?,
      company: json['company'] as String?,
      requiresVerification: json['requires_verification'] as bool?,
      verificationToken: json['verification_token'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserSignUpDataImplToJson(
    _$UserSignUpDataImpl instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'email': instance.email,
    'first_name': instance.firstName,
    'last_name': instance.lastName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('phone', instance.phone);
  writeNotNull('company', instance.company);
  writeNotNull('requires_verification', instance.requiresVerification);
  writeNotNull('verification_token', instance.verificationToken);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('metadata', instance.metadata);
  return val;
}
