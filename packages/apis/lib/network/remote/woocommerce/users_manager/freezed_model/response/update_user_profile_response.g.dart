// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserProfileResponseImpl _$$UpdateUserProfileResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateUserProfileResponseImpl(
      success: json['success'] as bool,
      updated:
          (json['updated'] as List<dynamic>).map((e) => e as String).toList(),
      message: json['message'] as String,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$UpdateUserProfileResponseImplToJson(
    _$UpdateUserProfileResponseImpl instance) {
  final val = <String, dynamic>{
    'success': instance.success,
    'updated': instance.updated,
    'message': instance.message,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('errors', instance.errors);
  return val;
}
