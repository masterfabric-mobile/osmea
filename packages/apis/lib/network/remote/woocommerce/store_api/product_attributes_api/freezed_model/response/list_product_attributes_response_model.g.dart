// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_product_attributes_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListProductAttributesResponseModelImpl
    _$$ListProductAttributesResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$ListProductAttributesResponseModelImpl(
          id: (json['id'] as num?)?.toInt(),
          name: json['name'] as String?,
          taxonomy: json['taxonomy'] as String?,
          type: json['type'] as String?,
          order: json['order'] as String?,
          hasArchives: json['has_archives'] as bool?,
          count: (json['count'] as num?)?.toInt(),
        );

Map<String, dynamic> _$$ListProductAttributesResponseModelImplToJson(
    _$ListProductAttributesResponseModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('taxonomy', instance.taxonomy);
  writeNotNull('type', instance.type);
  writeNotNull('order', instance.order);
  writeNotNull('has_archives', instance.hasArchives);
  writeNotNull('count', instance.count);
  return val;
}
