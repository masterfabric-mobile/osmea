// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistItemResponseImpl _$$WishlistItemResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WishlistItemResponseImpl(
      id: const StringToIntConverter().fromJson(json['id']),
      productId: const StringToIntConverter().fromJson(json['product_id']),
      groupId: const StringToIntConverter().fromJson(json['group_id']),
      userId: const StringToIntConverter().fromJson(json['user_id']),
      quantity: const StringToIntConverter().fromJson(json['quantity']),
      variationId: const StringToIntConverter().fromJson(json['variation_id']),
      addedAt: json['added_at'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      name: const SafeStringConverter().fromJson(json['name']),
      price: const SafeStringConverter().fromJson(json['price']),
      image: const SafeStringConverter().fromJson(json['image']),
      link: const SafeStringConverter().fromJson(json['link']),
      productName: const SafeStringConverter().fromJson(json['product_name']),
      productSlug: const SafeStringConverter().fromJson(json['product_slug']),
      productPrice: const SafeStringConverter().fromJson(json['product_price']),
      productImage: const SafeStringConverter().fromJson(json['product_image']),
      productStatus:
          const SafeStringConverter().fromJson(json['product_status']),
    );

Map<String, dynamic> _$$WishlistItemResponseImplToJson(
    _$WishlistItemResponseImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', const StringToIntConverter().toJson(instance.id));
  writeNotNull(
      'product_id', const StringToIntConverter().toJson(instance.productId));
  writeNotNull(
      'group_id', const StringToIntConverter().toJson(instance.groupId));
  writeNotNull('user_id', const StringToIntConverter().toJson(instance.userId));
  writeNotNull(
      'quantity', const StringToIntConverter().toJson(instance.quantity));
  writeNotNull('variation_id',
      const StringToIntConverter().toJson(instance.variationId));
  writeNotNull('added_at', instance.addedAt);
  writeNotNull('metadata', instance.metadata);
  writeNotNull('name', const SafeStringConverter().toJson(instance.name));
  writeNotNull('price', const SafeStringConverter().toJson(instance.price));
  writeNotNull('image', const SafeStringConverter().toJson(instance.image));
  writeNotNull('link', const SafeStringConverter().toJson(instance.link));
  writeNotNull(
      'product_name', const SafeStringConverter().toJson(instance.productName));
  writeNotNull(
      'product_slug', const SafeStringConverter().toJson(instance.productSlug));
  writeNotNull('product_price',
      const SafeStringConverter().toJson(instance.productPrice));
  writeNotNull('product_image',
      const SafeStringConverter().toJson(instance.productImage));
  writeNotNull('product_status',
      const SafeStringConverter().toJson(instance.productStatus));
  return val;
}
