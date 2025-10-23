// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_product_brand_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RetrieveProductBrandResponseModelImpl
    _$$RetrieveProductBrandResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$RetrieveProductBrandResponseModelImpl(
          id: (json['id'] as num?)?.toInt(),
          name: json['name'] as String?,
          slug: json['slug'] as String?,
          description: json['description'] as String?,
          parent: (json['parent'] as num?)?.toInt(),
          count: (json['count'] as num?)?.toInt(),
          image: json['image'] == null
              ? null
              : Image.fromJson(json['image'] as Map<String, dynamic>),
          reviewCount: (json['review_count'] as num?)?.toInt(),
          permalink: json['permalink'] as String?,
        );

Map<String, dynamic> _$$RetrieveProductBrandResponseModelImplToJson(
    _$RetrieveProductBrandResponseModelImpl instance) {
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
  writeNotNull('image', instance.image?.toJson());
  writeNotNull('review_count', instance.reviewCount);
  writeNotNull('permalink', instance.permalink);
  return val;
}

_$ImageImpl _$$ImageImplFromJson(Map<String, dynamic> json) => _$ImageImpl(
      id: (json['id'] as num?)?.toInt(),
      src: json['src'] as String?,
      thumbnail: json['thumbnail'] as String?,
      srcset: json['srcset'] as String?,
      sizes: json['sizes'] as String?,
      name: json['name'] as String?,
      alt: json['alt'] as String?,
    );

Map<String, dynamic> _$$ImageImplToJson(_$ImageImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('src', instance.src);
  writeNotNull('thumbnail', instance.thumbnail);
  writeNotNull('srcset', instance.srcset);
  writeNotNull('sizes', instance.sizes);
  writeNotNull('name', instance.name);
  writeNotNull('alt', instance.alt);
  return val;
}
