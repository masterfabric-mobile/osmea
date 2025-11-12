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
      name: json['name'] as String?,
      price: json['price'] as String?,
      image: json['image'] as String?,
      link: json['link'] as String?,
      productName: json['product_name'] as String?,
      productSlug: json['product_slug'] as String?,
      productPrice: json['product_price'] as String?,
      productImage: json['product_image'] as String?,
      productStatus: json['product_status'] as String?,
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
  writeNotNull('name', instance.name);
  writeNotNull('price', instance.price);
  writeNotNull('image', instance.image);
  writeNotNull('link', instance.link);
  writeNotNull('product_name', instance.productName);
  writeNotNull('product_slug', instance.productSlug);
  writeNotNull('product_price', instance.productPrice);
  writeNotNull('product_image', instance.productImage);
  writeNotNull('product_status', instance.productStatus);
  return val;
}
