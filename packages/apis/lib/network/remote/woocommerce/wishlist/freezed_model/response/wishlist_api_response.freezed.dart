// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WishlistApiResponse<T> _$WishlistApiResponseFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _WishlistApiResponse<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$WishlistApiResponse<T> {
  bool? get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  T? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_code')
  String? get errorCode => throw _privateConstructorUsedError;
  List<String>? get errors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WishlistApiResponseCopyWith<T, WishlistApiResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistApiResponseCopyWith<T, $Res> {
  factory $WishlistApiResponseCopyWith(WishlistApiResponse<T> value,
          $Res Function(WishlistApiResponse<T>) then) =
      _$WishlistApiResponseCopyWithImpl<T, $Res, WishlistApiResponse<T>>;
  @useResult
  $Res call(
      {bool? success,
      String? message,
      T? data,
      @JsonKey(name: 'error_code') String? errorCode,
      List<String>? errors});
}

/// @nodoc
class _$WishlistApiResponseCopyWithImpl<T, $Res,
        $Val extends WishlistApiResponse<T>>
    implements $WishlistApiResponseCopyWith<T, $Res> {
  _$WishlistApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
    Object? data = freezed,
    Object? errorCode = freezed,
    Object? errors = freezed,
  }) {
    return _then(_value.copyWith(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishlistApiResponseImplCopyWith<T, $Res>
    implements $WishlistApiResponseCopyWith<T, $Res> {
  factory _$$WishlistApiResponseImplCopyWith(_$WishlistApiResponseImpl<T> value,
          $Res Function(_$WishlistApiResponseImpl<T>) then) =
      __$$WishlistApiResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {bool? success,
      String? message,
      T? data,
      @JsonKey(name: 'error_code') String? errorCode,
      List<String>? errors});
}

/// @nodoc
class __$$WishlistApiResponseImplCopyWithImpl<T, $Res>
    extends _$WishlistApiResponseCopyWithImpl<T, $Res,
        _$WishlistApiResponseImpl<T>>
    implements _$$WishlistApiResponseImplCopyWith<T, $Res> {
  __$$WishlistApiResponseImplCopyWithImpl(_$WishlistApiResponseImpl<T> _value,
      $Res Function(_$WishlistApiResponseImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
    Object? data = freezed,
    Object? errorCode = freezed,
    Object? errors = freezed,
  }) {
    return _then(_$WishlistApiResponseImpl<T>(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$WishlistApiResponseImpl<T> implements _WishlistApiResponse<T> {
  const _$WishlistApiResponseImpl(
      {this.success,
      this.message,
      this.data,
      @JsonKey(name: 'error_code') this.errorCode,
      final List<String>? errors})
      : _errors = errors;

  factory _$WishlistApiResponseImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$WishlistApiResponseImplFromJson(json, fromJsonT);

  @override
  final bool? success;
  @override
  final String? message;
  @override
  final T? data;
  @override
  @JsonKey(name: 'error_code')
  final String? errorCode;
  final List<String>? _errors;
  @override
  List<String>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WishlistApiResponse<$T>(success: $success, message: $message, data: $data, errorCode: $errorCode, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistApiResponseImpl<T> &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      const DeepCollectionEquality().hash(data),
      errorCode,
      const DeepCollectionEquality().hash(_errors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistApiResponseImplCopyWith<T, _$WishlistApiResponseImpl<T>>
      get copyWith => __$$WishlistApiResponseImplCopyWithImpl<T,
          _$WishlistApiResponseImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$WishlistApiResponseImplToJson<T>(this, toJsonT);
  }
}

abstract class _WishlistApiResponse<T> implements WishlistApiResponse<T> {
  const factory _WishlistApiResponse(
      {final bool? success,
      final String? message,
      final T? data,
      @JsonKey(name: 'error_code') final String? errorCode,
      final List<String>? errors}) = _$WishlistApiResponseImpl<T>;

  factory _WishlistApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$WishlistApiResponseImpl<T>.fromJson;

  @override
  bool? get success;
  @override
  String? get message;
  @override
  T? get data;
  @override
  @JsonKey(name: 'error_code')
  String? get errorCode;
  @override
  List<String>? get errors;
  @override
  @JsonKey(ignore: true)
  _$$WishlistApiResponseImplCopyWith<T, _$WishlistApiResponseImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

WishlistPaginatedResponse<T> _$WishlistPaginatedResponseFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _WishlistPaginatedResponse<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$WishlistPaginatedResponse<T> {
  bool? get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  List<T>? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'items')
  List<T>? get items => throw _privateConstructorUsedError; // API format
  @JsonKey(name: 'pagination')
  WishlistPaginationInfo? get pagination =>
      throw _privateConstructorUsedError; // API format
  @JsonKey(name: 'current_page')
  @StringToIntConverter()
  int? get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  @StringToIntConverter()
  int? get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items')
  @StringToIntConverter()
  int? get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  @StringToIntConverter()
  int? get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_code')
  String? get errorCode => throw _privateConstructorUsedError;
  List<String>? get errors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WishlistPaginatedResponseCopyWith<T, WishlistPaginatedResponse<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistPaginatedResponseCopyWith<T, $Res> {
  factory $WishlistPaginatedResponseCopyWith(WishlistPaginatedResponse<T> value,
          $Res Function(WishlistPaginatedResponse<T>) then) =
      _$WishlistPaginatedResponseCopyWithImpl<T, $Res,
          WishlistPaginatedResponse<T>>;
  @useResult
  $Res call(
      {bool? success,
      String? message,
      List<T>? data,
      @JsonKey(name: 'items') List<T>? items,
      @JsonKey(name: 'pagination') WishlistPaginationInfo? pagination,
      @JsonKey(name: 'current_page') @StringToIntConverter() int? currentPage,
      @JsonKey(name: 'per_page') @StringToIntConverter() int? perPage,
      @JsonKey(name: 'total_items') @StringToIntConverter() int? totalItems,
      @JsonKey(name: 'total_pages') @StringToIntConverter() int? totalPages,
      @JsonKey(name: 'error_code') String? errorCode,
      List<String>? errors});

  $WishlistPaginationInfoCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$WishlistPaginatedResponseCopyWithImpl<T, $Res,
        $Val extends WishlistPaginatedResponse<T>>
    implements $WishlistPaginatedResponseCopyWith<T, $Res> {
  _$WishlistPaginatedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
    Object? data = freezed,
    Object? items = freezed,
    Object? pagination = freezed,
    Object? currentPage = freezed,
    Object? perPage = freezed,
    Object? totalItems = freezed,
    Object? totalPages = freezed,
    Object? errorCode = freezed,
    Object? errors = freezed,
  }) {
    return _then(_value.copyWith(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as WishlistPaginationInfo?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalItems: freezed == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WishlistPaginationInfoCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $WishlistPaginationInfoCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WishlistPaginatedResponseImplCopyWith<T, $Res>
    implements $WishlistPaginatedResponseCopyWith<T, $Res> {
  factory _$$WishlistPaginatedResponseImplCopyWith(
          _$WishlistPaginatedResponseImpl<T> value,
          $Res Function(_$WishlistPaginatedResponseImpl<T>) then) =
      __$$WishlistPaginatedResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {bool? success,
      String? message,
      List<T>? data,
      @JsonKey(name: 'items') List<T>? items,
      @JsonKey(name: 'pagination') WishlistPaginationInfo? pagination,
      @JsonKey(name: 'current_page') @StringToIntConverter() int? currentPage,
      @JsonKey(name: 'per_page') @StringToIntConverter() int? perPage,
      @JsonKey(name: 'total_items') @StringToIntConverter() int? totalItems,
      @JsonKey(name: 'total_pages') @StringToIntConverter() int? totalPages,
      @JsonKey(name: 'error_code') String? errorCode,
      List<String>? errors});

  @override
  $WishlistPaginationInfoCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$WishlistPaginatedResponseImplCopyWithImpl<T, $Res>
    extends _$WishlistPaginatedResponseCopyWithImpl<T, $Res,
        _$WishlistPaginatedResponseImpl<T>>
    implements _$$WishlistPaginatedResponseImplCopyWith<T, $Res> {
  __$$WishlistPaginatedResponseImplCopyWithImpl(
      _$WishlistPaginatedResponseImpl<T> _value,
      $Res Function(_$WishlistPaginatedResponseImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
    Object? data = freezed,
    Object? items = freezed,
    Object? pagination = freezed,
    Object? currentPage = freezed,
    Object? perPage = freezed,
    Object? totalItems = freezed,
    Object? totalPages = freezed,
    Object? errorCode = freezed,
    Object? errors = freezed,
  }) {
    return _then(_$WishlistPaginatedResponseImpl<T>(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as WishlistPaginationInfo?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalItems: freezed == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$WishlistPaginatedResponseImpl<T>
    implements _WishlistPaginatedResponse<T> {
  const _$WishlistPaginatedResponseImpl(
      {this.success,
      this.message,
      final List<T>? data,
      @JsonKey(name: 'items') final List<T>? items,
      @JsonKey(name: 'pagination') this.pagination,
      @JsonKey(name: 'current_page') @StringToIntConverter() this.currentPage,
      @JsonKey(name: 'per_page') @StringToIntConverter() this.perPage,
      @JsonKey(name: 'total_items') @StringToIntConverter() this.totalItems,
      @JsonKey(name: 'total_pages') @StringToIntConverter() this.totalPages,
      @JsonKey(name: 'error_code') this.errorCode,
      final List<String>? errors})
      : _data = data,
        _items = items,
        _errors = errors;

  factory _$WishlistPaginatedResponseImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$WishlistPaginatedResponseImplFromJson(json, fromJsonT);

  @override
  final bool? success;
  @override
  final String? message;
  final List<T>? _data;
  @override
  List<T>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<T>? _items;
  @override
  @JsonKey(name: 'items')
  List<T>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// API format
  @override
  @JsonKey(name: 'pagination')
  final WishlistPaginationInfo? pagination;
// API format
  @override
  @JsonKey(name: 'current_page')
  @StringToIntConverter()
  final int? currentPage;
  @override
  @JsonKey(name: 'per_page')
  @StringToIntConverter()
  final int? perPage;
  @override
  @JsonKey(name: 'total_items')
  @StringToIntConverter()
  final int? totalItems;
  @override
  @JsonKey(name: 'total_pages')
  @StringToIntConverter()
  final int? totalPages;
  @override
  @JsonKey(name: 'error_code')
  final String? errorCode;
  final List<String>? _errors;
  @override
  List<String>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WishlistPaginatedResponse<$T>(success: $success, message: $message, data: $data, items: $items, pagination: $pagination, currentPage: $currentPage, perPage: $perPage, totalItems: $totalItems, totalPages: $totalPages, errorCode: $errorCode, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistPaginatedResponseImpl<T> &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(_items),
      pagination,
      currentPage,
      perPage,
      totalItems,
      totalPages,
      errorCode,
      const DeepCollectionEquality().hash(_errors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistPaginatedResponseImplCopyWith<T,
          _$WishlistPaginatedResponseImpl<T>>
      get copyWith => __$$WishlistPaginatedResponseImplCopyWithImpl<T,
          _$WishlistPaginatedResponseImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$WishlistPaginatedResponseImplToJson<T>(this, toJsonT);
  }
}

abstract class _WishlistPaginatedResponse<T>
    implements WishlistPaginatedResponse<T> {
  const factory _WishlistPaginatedResponse(
      {final bool? success,
      final String? message,
      final List<T>? data,
      @JsonKey(name: 'items') final List<T>? items,
      @JsonKey(name: 'pagination') final WishlistPaginationInfo? pagination,
      @JsonKey(name: 'current_page')
      @StringToIntConverter()
      final int? currentPage,
      @JsonKey(name: 'per_page') @StringToIntConverter() final int? perPage,
      @JsonKey(name: 'total_items')
      @StringToIntConverter()
      final int? totalItems,
      @JsonKey(name: 'total_pages')
      @StringToIntConverter()
      final int? totalPages,
      @JsonKey(name: 'error_code') final String? errorCode,
      final List<String>? errors}) = _$WishlistPaginatedResponseImpl<T>;

  factory _WishlistPaginatedResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$WishlistPaginatedResponseImpl<T>.fromJson;

  @override
  bool? get success;
  @override
  String? get message;
  @override
  List<T>? get data;
  @override
  @JsonKey(name: 'items')
  List<T>? get items;
  @override // API format
  @JsonKey(name: 'pagination')
  WishlistPaginationInfo? get pagination;
  @override // API format
  @JsonKey(name: 'current_page')
  @StringToIntConverter()
  int? get currentPage;
  @override
  @JsonKey(name: 'per_page')
  @StringToIntConverter()
  int? get perPage;
  @override
  @JsonKey(name: 'total_items')
  @StringToIntConverter()
  int? get totalItems;
  @override
  @JsonKey(name: 'total_pages')
  @StringToIntConverter()
  int? get totalPages;
  @override
  @JsonKey(name: 'error_code')
  String? get errorCode;
  @override
  List<String>? get errors;
  @override
  @JsonKey(ignore: true)
  _$$WishlistPaginatedResponseImplCopyWith<T,
          _$WishlistPaginatedResponseImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

WishlistPaginationInfo _$WishlistPaginationInfoFromJson(
    Map<String, dynamic> json) {
  return _WishlistPaginationInfo.fromJson(json);
}

/// @nodoc
mixin _$WishlistPaginationInfo {
  @StringToIntConverter()
  int? get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  @StringToIntConverter()
  int? get perPage => throw _privateConstructorUsedError;
  @StringToIntConverter()
  int? get current => throw _privateConstructorUsedError;
  @StringToIntConverter()
  int? get pages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WishlistPaginationInfoCopyWith<WishlistPaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistPaginationInfoCopyWith<$Res> {
  factory $WishlistPaginationInfoCopyWith(WishlistPaginationInfo value,
          $Res Function(WishlistPaginationInfo) then) =
      _$WishlistPaginationInfoCopyWithImpl<$Res, WishlistPaginationInfo>;
  @useResult
  $Res call(
      {@StringToIntConverter() int? total,
      @JsonKey(name: 'per_page') @StringToIntConverter() int? perPage,
      @StringToIntConverter() int? current,
      @StringToIntConverter() int? pages});
}

/// @nodoc
class _$WishlistPaginationInfoCopyWithImpl<$Res,
        $Val extends WishlistPaginationInfo>
    implements $WishlistPaginationInfoCopyWith<$Res> {
  _$WishlistPaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = freezed,
    Object? perPage = freezed,
    Object? current = freezed,
    Object? pages = freezed,
  }) {
    return _then(_value.copyWith(
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      current: freezed == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int?,
      pages: freezed == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishlistPaginationInfoImplCopyWith<$Res>
    implements $WishlistPaginationInfoCopyWith<$Res> {
  factory _$$WishlistPaginationInfoImplCopyWith(
          _$WishlistPaginationInfoImpl value,
          $Res Function(_$WishlistPaginationInfoImpl) then) =
      __$$WishlistPaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@StringToIntConverter() int? total,
      @JsonKey(name: 'per_page') @StringToIntConverter() int? perPage,
      @StringToIntConverter() int? current,
      @StringToIntConverter() int? pages});
}

/// @nodoc
class __$$WishlistPaginationInfoImplCopyWithImpl<$Res>
    extends _$WishlistPaginationInfoCopyWithImpl<$Res,
        _$WishlistPaginationInfoImpl>
    implements _$$WishlistPaginationInfoImplCopyWith<$Res> {
  __$$WishlistPaginationInfoImplCopyWithImpl(
      _$WishlistPaginationInfoImpl _value,
      $Res Function(_$WishlistPaginationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = freezed,
    Object? perPage = freezed,
    Object? current = freezed,
    Object? pages = freezed,
  }) {
    return _then(_$WishlistPaginationInfoImpl(
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      current: freezed == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int?,
      pages: freezed == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WishlistPaginationInfoImpl implements _WishlistPaginationInfo {
  const _$WishlistPaginationInfoImpl(
      {@StringToIntConverter() this.total,
      @JsonKey(name: 'per_page') @StringToIntConverter() this.perPage,
      @StringToIntConverter() this.current,
      @StringToIntConverter() this.pages});

  factory _$WishlistPaginationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistPaginationInfoImplFromJson(json);

  @override
  @StringToIntConverter()
  final int? total;
  @override
  @JsonKey(name: 'per_page')
  @StringToIntConverter()
  final int? perPage;
  @override
  @StringToIntConverter()
  final int? current;
  @override
  @StringToIntConverter()
  final int? pages;

  @override
  String toString() {
    return 'WishlistPaginationInfo(total: $total, perPage: $perPage, current: $current, pages: $pages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistPaginationInfoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.pages, pages) || other.pages == pages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, total, perPage, current, pages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistPaginationInfoImplCopyWith<_$WishlistPaginationInfoImpl>
      get copyWith => __$$WishlistPaginationInfoImplCopyWithImpl<
          _$WishlistPaginationInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistPaginationInfoImplToJson(
      this,
    );
  }
}

abstract class _WishlistPaginationInfo implements WishlistPaginationInfo {
  const factory _WishlistPaginationInfo(
      {@StringToIntConverter() final int? total,
      @JsonKey(name: 'per_page') @StringToIntConverter() final int? perPage,
      @StringToIntConverter() final int? current,
      @StringToIntConverter() final int? pages}) = _$WishlistPaginationInfoImpl;

  factory _WishlistPaginationInfo.fromJson(Map<String, dynamic> json) =
      _$WishlistPaginationInfoImpl.fromJson;

  @override
  @StringToIntConverter()
  int? get total;
  @override
  @JsonKey(name: 'per_page')
  @StringToIntConverter()
  int? get perPage;
  @override
  @StringToIntConverter()
  int? get current;
  @override
  @StringToIntConverter()
  int? get pages;
  @override
  @JsonKey(ignore: true)
  _$$WishlistPaginationInfoImplCopyWith<_$WishlistPaginationInfoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
