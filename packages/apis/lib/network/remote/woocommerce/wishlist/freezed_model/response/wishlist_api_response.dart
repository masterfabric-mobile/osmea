import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_api_response.freezed.dart';
part 'wishlist_api_response.g.dart';

/// Generic API response wrapper for wishlist operations
@Freezed(genericArgumentFactories: true)
class WishlistApiResponse<T> with _$WishlistApiResponse<T> {
  const factory WishlistApiResponse({
    bool? success,
    String? message,
    T? data,
    @JsonKey(name: 'error_code') String? errorCode,
    List<String>? errors,
  }) = _WishlistApiResponse<T>;

  factory WishlistApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$WishlistApiResponseFromJson(json, fromJsonT);
}

/// Paginated response wrapper for wishlist data
/// Supports API format: {items: [...], pagination: {...}}
@Freezed(genericArgumentFactories: true)
class WishlistPaginatedResponse<T> with _$WishlistPaginatedResponse<T> {
  const factory WishlistPaginatedResponse({
    bool? success,
    String? message,
    List<T>? data,
    @JsonKey(name: 'items') List<T>? items, // API format
    @JsonKey(name: 'pagination')
    WishlistPaginationInfo? pagination, // API format
    @JsonKey(name: 'current_page') @StringToIntConverter() int? currentPage,
    @JsonKey(name: 'per_page') @StringToIntConverter() int? perPage,
    @JsonKey(name: 'total_items') @StringToIntConverter() int? totalItems,
    @JsonKey(name: 'total_pages') @StringToIntConverter() int? totalPages,
    @JsonKey(name: 'error_code') String? errorCode,
    List<String>? errors,
  }) = _WishlistPaginatedResponse<T>;

  factory WishlistPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$WishlistPaginatedResponseFromJson(json, fromJsonT);
}

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

/// Pagination info from API response
@freezed
class WishlistPaginationInfo with _$WishlistPaginationInfo {
  const factory WishlistPaginationInfo({
    @StringToIntConverter() int? total,
    @JsonKey(name: 'per_page') @StringToIntConverter() int? perPage,
    @StringToIntConverter() int? current,
    @StringToIntConverter() int? pages,
  }) = _WishlistPaginationInfo;

  factory WishlistPaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$WishlistPaginationInfoFromJson(json);
}
