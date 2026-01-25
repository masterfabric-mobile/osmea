// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_metadata_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserMetadataResponseImpl _$$GetUserMetadataResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserMetadataResponseImpl(
      userId: (json['user_id'] as num).toInt(),
      metadata: (json['metadata'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, UserMetadataItem.fromJson(e as Map<String, dynamic>)),
      ),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$GetUserMetadataResponseImplToJson(
        _$GetUserMetadataResponseImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'metadata': instance.metadata.map((k, e) => MapEntry(k, e.toJson())),
      'count': instance.count,
    };

_$UserMetadataItemImpl _$$UserMetadataItemImplFromJson(
        Map<String, dynamic> json) =>
    _$UserMetadataItemImpl(
      value: json['value'],
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$UserMetadataItemImplToJson(
    _$UserMetadataItemImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('value', instance.value);
  writeNotNull('updated_at', instance.updatedAt);
  return val;
}
