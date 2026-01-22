// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_user_activity_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogUserActivityRequestImpl _$$LogUserActivityRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$LogUserActivityRequestImpl(
      activityType: json['activity_type'] as String,
      activityDescription: json['activity_description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LogUserActivityRequestImplToJson(
    _$LogUserActivityRequestImpl instance) {
  final val = <String, dynamic>{
    'activity_type': instance.activityType,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('activity_description', instance.activityDescription);
  writeNotNull('metadata', instance.metadata);
  return val;
}
