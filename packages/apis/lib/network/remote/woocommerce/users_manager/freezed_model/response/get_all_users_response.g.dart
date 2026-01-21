// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetAllUsersResponseImpl _$$GetAllUsersResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetAllUsersResponseImpl(
      users: (json['users'] as List<dynamic>)
          .map((e) => UserListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetAllUsersResponseImplToJson(
        _$GetAllUsersResponseImpl instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

_$UserListItemImpl _$$UserListItemImplFromJson(Map<String, dynamic> json) =>
    _$UserListItemImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      registeredAt: json['registered_at'] as String,
      metadataCount: (json['metadata_count'] as num).toInt(),
    );

Map<String, dynamic> _$$UserListItemImplToJson(_$UserListItemImpl instance) {
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
  val['roles'] = instance.roles;
  val['registered_at'] = instance.registeredAt;
  val['metadata_count'] = instance.metadataCount;
  return val;
}

_$PaginationInfoImpl _$$PaginationInfoImplFromJson(Map<String, dynamic> json) =>
    _$PaginationInfoImpl(
      total: (json['total'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$$PaginationInfoImplToJson(
        _$PaginationInfoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
    };
