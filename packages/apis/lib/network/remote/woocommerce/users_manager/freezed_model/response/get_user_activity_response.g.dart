// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_activity_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserActivityResponseImpl _$$GetUserActivityResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserActivityResponseImpl(
      activities: (json['activities'] as List<dynamic>)
          .map((e) => UserActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetUserActivityResponseImplToJson(
        _$GetUserActivityResponseImpl instance) =>
    <String, dynamic>{
      'activities': instance.activities.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

_$LogActivityResponseImpl _$$LogActivityResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LogActivityResponseImpl(
      success: json['success'] as bool,
      activityId: (json['activity_id'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$LogActivityResponseImplToJson(
        _$LogActivityResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'activity_id': instance.activityId,
      'message': instance.message,
    };
