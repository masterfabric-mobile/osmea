// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_user_metadata_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeleteUserMetadataResponseImpl _$$DeleteUserMetadataResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DeleteUserMetadataResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$DeleteUserMetadataResponseImplToJson(
    _$DeleteUserMetadataResponseImpl instance) {
  final val = <String, dynamic>{
    'success': instance.success,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  return val;
}
