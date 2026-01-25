// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_preferences_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserPreferencesResponseImpl _$$GetUserPreferencesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserPreferencesResponseImpl(
      userId: (json['user_id'] as num).toInt(),
      preferences: (json['preferences'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, UserPreference.fromJson(e as Map<String, dynamic>)),
      ),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$GetUserPreferencesResponseImplToJson(
        _$GetUserPreferencesResponseImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'preferences':
          instance.preferences.map((k, e) => MapEntry(k, e.toJson())),
      'count': instance.count,
    };

_$UpdatePreferencesResponseImpl _$$UpdatePreferencesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdatePreferencesResponseImpl(
      success: json['success'] as bool,
      updated:
          (json['updated'] as List<dynamic>).map((e) => e as String).toList(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$UpdatePreferencesResponseImplToJson(
        _$UpdatePreferencesResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'updated': instance.updated,
      'message': instance.message,
    };
