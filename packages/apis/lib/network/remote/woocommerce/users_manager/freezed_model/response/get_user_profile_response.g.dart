// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserProfileResponseImpl _$$GetUserProfileResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserProfileResponseImpl(
      userId: (json['user_id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      registeredAt: json['registered_at'] as String,
      statistics: UserProfileStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetUserProfileResponseImplToJson(
    _$GetUserProfileResponseImpl instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'username': instance.username,
    'email': instance.email,
    'display_name': instance.displayName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  val['registered_at'] = instance.registeredAt;
  val['statistics'] = instance.statistics.toJson();
  return val;
}

_$UserProfileStatisticsImpl _$$UserProfileStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileStatisticsImpl(
      metadataCount: (json['metadata_count'] as num).toInt(),
      ordersCount: (json['orders_count'] as num).toInt(),
      contractsCount: (json['contracts_count'] as num).toInt(),
    );

Map<String, dynamic> _$$UserProfileStatisticsImplToJson(
        _$UserProfileStatisticsImpl instance) =>
    <String, dynamic>{
      'metadata_count': instance.metadataCount,
      'orders_count': instance.ordersCount,
      'contracts_count': instance.contractsCount,
    };
