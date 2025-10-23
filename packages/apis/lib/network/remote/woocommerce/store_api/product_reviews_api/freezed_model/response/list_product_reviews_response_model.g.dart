// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_product_reviews_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListProductReviewsResponseModelImpl
    _$$ListProductReviewsResponseModelImplFromJson(Map<String, dynamic> json) =>
        _$ListProductReviewsResponseModelImpl(
          id: (json['id'] as num?)?.toInt(),
          dateCreated: json['date_created'] as String?,
          formattedDateCreated: json['formatted_date_created'] as String?,
          dateCreatedGmt: json['date_created_gmt'] as String?,
          productId: (json['product_id'] as num?)?.toInt(),
          productName: json['product_name'] as String?,
          productPermalink: json['product_permalink'] as String?,
          productImage: json['product_image'] == null
              ? null
              : ProductImage.fromJson(
                  json['product_image'] as Map<String, dynamic>),
          reviewer: json['reviewer'] as String?,
          review: json['review'] as String?,
          rating: (json['rating'] as num?)?.toInt(),
          verified: json['verified'] as bool?,
          reviewerAvatarUrls: json['reviewer_avatar_urls'] == null
              ? null
              : ReviewerAvatarUrls.fromJson(
                  json['reviewer_avatar_urls'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$ListProductReviewsResponseModelImplToJson(
    _$ListProductReviewsResponseModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('date_created', instance.dateCreated);
  writeNotNull('formatted_date_created', instance.formattedDateCreated);
  writeNotNull('date_created_gmt', instance.dateCreatedGmt);
  writeNotNull('product_id', instance.productId);
  writeNotNull('product_name', instance.productName);
  writeNotNull('product_permalink', instance.productPermalink);
  writeNotNull('product_image', instance.productImage?.toJson());
  writeNotNull('reviewer', instance.reviewer);
  writeNotNull('review', instance.review);
  writeNotNull('rating', instance.rating);
  writeNotNull('verified', instance.verified);
  writeNotNull('reviewer_avatar_urls', instance.reviewerAvatarUrls?.toJson());
  return val;
}

_$ProductImageImpl _$$ProductImageImplFromJson(Map<String, dynamic> json) =>
    _$ProductImageImpl(
      id: (json['id'] as num?)?.toInt(),
      src: json['src'] as String?,
      thumbnail: json['thumbnail'] as String?,
      srcset: json['srcset'] as String?,
      sizes: json['sizes'] as String?,
      name: json['name'] as String?,
      alt: json['alt'] as String?,
    );

Map<String, dynamic> _$$ProductImageImplToJson(_$ProductImageImpl instance) {
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

_$ReviewerAvatarUrlsImpl _$$ReviewerAvatarUrlsImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewerAvatarUrlsImpl(
      the24: json['24'] as String?,
      the48: json['48'] as String?,
      the96: json['96'] as String?,
    );

Map<String, dynamic> _$$ReviewerAvatarUrlsImplToJson(
    _$ReviewerAvatarUrlsImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('24', instance.the24);
  writeNotNull('48', instance.the48);
  writeNotNull('96', instance.the96);
  return val;
}
