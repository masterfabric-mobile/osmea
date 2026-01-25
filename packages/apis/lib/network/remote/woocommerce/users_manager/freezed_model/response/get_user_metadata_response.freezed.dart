// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_metadata_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserMetadataResponse _$GetUserMetadataResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserMetadataResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserMetadataResponse {
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'metadata')
  Map<String, UserMetadataItem> get metadata =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  int get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserMetadataResponseCopyWith<GetUserMetadataResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserMetadataResponseCopyWith<$Res> {
  factory $GetUserMetadataResponseCopyWith(GetUserMetadataResponse value,
          $Res Function(GetUserMetadataResponse) then) =
      _$GetUserMetadataResponseCopyWithImpl<$Res, GetUserMetadataResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'metadata') Map<String, UserMetadataItem> metadata,
      @JsonKey(name: 'count') int count});
}

/// @nodoc
class _$GetUserMetadataResponseCopyWithImpl<$Res,
        $Val extends GetUserMetadataResponse>
    implements $GetUserMetadataResponseCopyWith<$Res> {
  _$GetUserMetadataResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? metadata = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, UserMetadataItem>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetUserMetadataResponseImplCopyWith<$Res>
    implements $GetUserMetadataResponseCopyWith<$Res> {
  factory _$$GetUserMetadataResponseImplCopyWith(
          _$GetUserMetadataResponseImpl value,
          $Res Function(_$GetUserMetadataResponseImpl) then) =
      __$$GetUserMetadataResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'metadata') Map<String, UserMetadataItem> metadata,
      @JsonKey(name: 'count') int count});
}

/// @nodoc
class __$$GetUserMetadataResponseImplCopyWithImpl<$Res>
    extends _$GetUserMetadataResponseCopyWithImpl<$Res,
        _$GetUserMetadataResponseImpl>
    implements _$$GetUserMetadataResponseImplCopyWith<$Res> {
  __$$GetUserMetadataResponseImplCopyWithImpl(
      _$GetUserMetadataResponseImpl _value,
      $Res Function(_$GetUserMetadataResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? metadata = null,
    Object? count = null,
  }) {
    return _then(_$GetUserMetadataResponseImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, UserMetadataItem>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserMetadataResponseImpl implements _GetUserMetadataResponse {
  const _$GetUserMetadataResponseImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'metadata')
      required final Map<String, UserMetadataItem> metadata,
      @JsonKey(name: 'count') required this.count})
      : _metadata = metadata;

  factory _$GetUserMetadataResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserMetadataResponseImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final int userId;
  final Map<String, UserMetadataItem> _metadata;
  @override
  @JsonKey(name: 'metadata')
  Map<String, UserMetadataItem> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @JsonKey(name: 'count')
  final int count;

  @override
  String toString() {
    return 'GetUserMetadataResponse(userId: $userId, metadata: $metadata, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserMetadataResponseImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId,
      const DeepCollectionEquality().hash(_metadata), count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserMetadataResponseImplCopyWith<_$GetUserMetadataResponseImpl>
      get copyWith => __$$GetUserMetadataResponseImplCopyWithImpl<
          _$GetUserMetadataResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserMetadataResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserMetadataResponse implements GetUserMetadataResponse {
  const factory _GetUserMetadataResponse(
          {@JsonKey(name: 'user_id') required final int userId,
          @JsonKey(name: 'metadata')
          required final Map<String, UserMetadataItem> metadata,
          @JsonKey(name: 'count') required final int count}) =
      _$GetUserMetadataResponseImpl;

  factory _GetUserMetadataResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserMetadataResponseImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'metadata')
  Map<String, UserMetadataItem> get metadata;
  @override
  @JsonKey(name: 'count')
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$GetUserMetadataResponseImplCopyWith<_$GetUserMetadataResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserMetadataItem _$UserMetadataItemFromJson(Map<String, dynamic> json) {
  return _UserMetadataItem.fromJson(json);
}

/// @nodoc
mixin _$UserMetadataItem {
  @JsonKey(name: 'value')
  dynamic get value => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserMetadataItemCopyWith<UserMetadataItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMetadataItemCopyWith<$Res> {
  factory $UserMetadataItemCopyWith(
          UserMetadataItem value, $Res Function(UserMetadataItem) then) =
      _$UserMetadataItemCopyWithImpl<$Res, UserMetadataItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'value') dynamic value,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$UserMetadataItemCopyWithImpl<$Res, $Val extends UserMetadataItem>
    implements $UserMetadataItemCopyWith<$Res> {
  _$UserMetadataItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserMetadataItemImplCopyWith<$Res>
    implements $UserMetadataItemCopyWith<$Res> {
  factory _$$UserMetadataItemImplCopyWith(_$UserMetadataItemImpl value,
          $Res Function(_$UserMetadataItemImpl) then) =
      __$$UserMetadataItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'value') dynamic value,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$UserMetadataItemImplCopyWithImpl<$Res>
    extends _$UserMetadataItemCopyWithImpl<$Res, _$UserMetadataItemImpl>
    implements _$$UserMetadataItemImplCopyWith<$Res> {
  __$$UserMetadataItemImplCopyWithImpl(_$UserMetadataItemImpl _value,
      $Res Function(_$UserMetadataItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserMetadataItemImpl(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMetadataItemImpl implements _UserMetadataItem {
  const _$UserMetadataItemImpl(
      {@JsonKey(name: 'value') required this.value,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$UserMetadataItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMetadataItemImplFromJson(json);

  @override
  @JsonKey(name: 'value')
  final dynamic value;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'UserMetadataItem(value: $value, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMetadataItemImpl &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(value), updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMetadataItemImplCopyWith<_$UserMetadataItemImpl> get copyWith =>
      __$$UserMetadataItemImplCopyWithImpl<_$UserMetadataItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMetadataItemImplToJson(
      this,
    );
  }
}

abstract class _UserMetadataItem implements UserMetadataItem {
  const factory _UserMetadataItem(
          {@JsonKey(name: 'value') required final dynamic value,
          @JsonKey(name: 'updated_at') final String? updatedAt}) =
      _$UserMetadataItemImpl;

  factory _UserMetadataItem.fromJson(Map<String, dynamic> json) =
      _$UserMetadataItemImpl.fromJson;

  @override
  @JsonKey(name: 'value')
  dynamic get value;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserMetadataItemImplCopyWith<_$UserMetadataItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
