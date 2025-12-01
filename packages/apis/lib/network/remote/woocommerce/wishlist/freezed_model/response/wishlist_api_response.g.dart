// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistApiResponseImpl<T> _$$WishlistApiResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$WishlistApiResponseImpl<T>(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      errorCode: json['error_code'] as String?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$WishlistApiResponseImplToJson<T>(
  _$WishlistApiResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('success', instance.success);
  writeNotNull('message', instance.message);
  writeNotNull('data', _$nullableGenericToJson(instance.data, toJsonT));
  writeNotNull('error_code', instance.errorCode);
  writeNotNull('errors', instance.errors);
  return val;
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

_$WishlistPaginatedResponseImpl<T> _$$WishlistPaginatedResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$WishlistPaginatedResponseImpl<T>(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
      items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList(),
      pagination: json['pagination'] == null
          ? null
          : WishlistPaginationInfo.fromJson(
              json['pagination'] as Map<String, dynamic>),
      currentPage: const StringToIntConverter().fromJson(json['current_page']),
      perPage: const StringToIntConverter().fromJson(json['per_page']),
      totalItems: const StringToIntConverter().fromJson(json['total_items']),
      totalPages: const StringToIntConverter().fromJson(json['total_pages']),
      errorCode: json['error_code'] as String?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$WishlistPaginatedResponseImplToJson<T>(
  _$WishlistPaginatedResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('success', instance.success);
  writeNotNull('message', instance.message);
  writeNotNull('data', instance.data?.map(toJsonT).toList());
  writeNotNull('items', instance.items?.map(toJsonT).toList());
  writeNotNull('pagination', instance.pagination?.toJson());
  writeNotNull('current_page',
      const StringToIntConverter().toJson(instance.currentPage));
  writeNotNull(
      'per_page', const StringToIntConverter().toJson(instance.perPage));
  writeNotNull(
      'total_items', const StringToIntConverter().toJson(instance.totalItems));
  writeNotNull(
      'total_pages', const StringToIntConverter().toJson(instance.totalPages));
  writeNotNull('error_code', instance.errorCode);
  writeNotNull('errors', instance.errors);
  return val;
}

_$WishlistPaginationInfoImpl _$$WishlistPaginationInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$WishlistPaginationInfoImpl(
      total: const StringToIntConverter().fromJson(json['total']),
      perPage: const StringToIntConverter().fromJson(json['per_page']),
      current: const StringToIntConverter().fromJson(json['current']),
      pages: const StringToIntConverter().fromJson(json['pages']),
    );

Map<String, dynamic> _$$WishlistPaginationInfoImplToJson(
    _$WishlistPaginationInfoImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('total', const StringToIntConverter().toJson(instance.total));
  writeNotNull(
      'per_page', const StringToIntConverter().toJson(instance.perPage));
  writeNotNull(
      'current', const StringToIntConverter().toJson(instance.current));
  writeNotNull('pages', const StringToIntConverter().toJson(instance.pages));
  return val;
}
