// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_product_attribute_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RetrieveProductAttributeResponseModelImpl
    _$$RetrieveProductAttributeResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$RetrieveProductAttributeResponseModelImpl(
          id: (json['id'] as num?)?.toInt(),
          name: json['name'] as String?,
          taxonomy: json['taxonomy'] as String?,
          type: json['type'] as String?,
          order: json['order'] as String?,
          hasArchives: json['has_archives'] as bool?,
          count: (json['count'] as num?)?.toInt(),
        );

Map<String, dynamic> _$$RetrieveProductAttributeResponseModelImplToJson(
    _$RetrieveProductAttributeResponseModelImpl instance) {
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
