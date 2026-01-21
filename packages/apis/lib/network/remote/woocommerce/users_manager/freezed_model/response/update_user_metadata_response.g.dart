// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_metadata_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserMetadataResponseImpl _$$UpdateUserMetadataResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateUserMetadataResponseImpl(
      success: json['success'] as bool,
      updated:
          (json['updated'] as List<dynamic>).map((e) => e as String).toList(),
      message: json['message'] as String?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$UpdateUserMetadataResponseImplToJson(
    _$UpdateUserMetadataResponseImpl instance) {
  final val = <String, dynamic>{
    'success': instance.success,
    'updated': instance.updated,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  writeNotNull('errors', instance.errors);
  return val;
}
