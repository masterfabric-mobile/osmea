// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_by_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserByIdResponseImpl _$$GetUserByIdResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserByIdResponseImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      nickname: json['nickname'] as String?,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      registeredAt: json['registered_at'] as String,
      metadataCount: (json['metadata_count'] as num).toInt(),
    );

Map<String, dynamic> _$$GetUserByIdResponseImplToJson(
    _$GetUserByIdResponseImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
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
  writeNotNull('nickname', instance.nickname);
  val['roles'] = instance.roles;
  val['registered_at'] = instance.registeredAt;
  val['metadata_count'] = instance.metadataCount;
  return val;
}
