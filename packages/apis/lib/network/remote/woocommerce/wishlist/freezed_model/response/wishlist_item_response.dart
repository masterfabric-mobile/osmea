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

/// Custom converter to handle dynamic to String conversion
/// Handles cases where API returns bool, num, or other types instead of String
class SafeStringConverter implements JsonConverter<String?, dynamic> {
  const SafeStringConverter();

  @override
  String? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    return value.toString();
  }

  @override
  dynamic toJson(String? value) => value;
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
    @SafeStringConverter() String? name, // API format
    @SafeStringConverter() String? price, // API format
    @SafeStringConverter() String? image, // API format
    @SafeStringConverter() String? link, // API format
    // Product details (legacy format)
    @JsonKey(name: 'product_name') @SafeStringConverter() String? productName,
    @JsonKey(name: 'product_slug') @SafeStringConverter() String? productSlug,
    @JsonKey(name: 'product_price') @SafeStringConverter() String? productPrice,
    @JsonKey(name: 'product_image') @SafeStringConverter() String? productImage,
    @JsonKey(name: 'product_status') @SafeStringConverter() String? productStatus,
  }) = _WishlistItemResponse;

  factory WishlistItemResponse.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemResponseFromJson(json);
}
