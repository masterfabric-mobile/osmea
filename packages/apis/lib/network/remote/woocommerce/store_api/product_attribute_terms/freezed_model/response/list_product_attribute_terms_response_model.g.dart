// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_product_attribute_terms_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListProductAttributeTermsResponseModelImpl
    _$$ListProductAttributeTermsResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$ListProductAttributeTermsResponseModelImpl(
          id: (json['id'] as num?)?.toInt(),
          name: json['name'] as String?,
          slug: json['slug'] as String?,
          description: json['description'] as String?,
          parent: (json['parent'] as num?)?.toInt(),
          count: (json['count'] as num?)?.toInt(),
        );

Map<String, dynamic> _$$ListProductAttributeTermsResponseModelImplToJson(
    _$ListProductAttributeTermsResponseModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('slug', instance.slug);
  writeNotNull('description', instance.description);
  writeNotNull('parent', instance.parent);
  writeNotNull('count', instance.count);
  return val;
}
