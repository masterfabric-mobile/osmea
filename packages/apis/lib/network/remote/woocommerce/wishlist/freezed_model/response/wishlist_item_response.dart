import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item_response.freezed.dart';
part 'wishlist_item_response.g.dart';

/// Custom converter to handle string to int conversion
class StringToIntConverter implements JsonConverter<int?, dynamic> {
  const StringToIntConverter();

  @override
  int? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      return int.tryParse(value);
    }
    if (value is num) return value.toInt();
    return null;
  }

  @override
  dynamic toJson(int? value) => value;
}

@freezed
class WishlistItemResponse with _$WishlistItemResponse {
  const factory WishlistItemResponse({
    @StringToIntConverter() int? id,
    @JsonKey(name: 'product_id') @StringToIntConverter() int? productId,
    @JsonKey(name: 'group_id') @StringToIntConverter() int? groupId,
    @JsonKey(name: 'user_id') @StringToIntConverter() int? userId,
    @StringToIntConverter() int? quantity,
    @JsonKey(name: 'variation_id') @StringToIntConverter() int? variationId,
    @JsonKey(name: 'added_at') String? addedAt,
    Map<String, dynamic>? metadata,
    // Product details from API (direct format)
    String? name, // API format
    String? price, // API format
    String? image, // API format
    String? link, // API format
    // Product details (legacy format)
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'product_slug') String? productSlug,
    @JsonKey(name: 'product_price') String? productPrice,
    @JsonKey(name: 'product_image') String? productImage,
    @JsonKey(name: 'product_status') String? productStatus,
  }) = _WishlistItemResponse;

  factory WishlistItemResponse.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemResponseFromJson(json);
}
