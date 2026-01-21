// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_by_id_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserByIdResponse _$GetUserByIdResponseFromJson(Map<String, dynamic> json) {
  return _GetUserByIdResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserByIdResponse {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'nickname')
  String? get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'roles')
  List<String> get roles => throw _privateConstructorUsedError;
  @JsonKey(name: 'registered_at')
  String get registeredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'metadata_count')
  int get metadataCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserByIdResponseCopyWith<GetUserByIdResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserByIdResponseCopyWith<$Res> {
  factory $GetUserByIdResponseCopyWith(
          GetUserByIdResponse value, $Res Function(GetUserByIdResponse) then) =
      _$GetUserByIdResponseCopyWithImpl<$Res, GetUserByIdResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'nickname') String? nickname,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'registered_at') String registeredAt,
      @JsonKey(name: 'metadata_count') int metadataCount});
}

/// @nodoc
class _$GetUserByIdResponseCopyWithImpl<$Res, $Val extends GetUserByIdResponse>
    implements $GetUserByIdResponseCopyWith<$Res> {
  _$GetUserByIdResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? nickname = freezed,
    Object? roles = null,
    Object? registeredAt = null,
    Object? metadataCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String,
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetUserByIdResponseImplCopyWith<$Res>
    implements $GetUserByIdResponseCopyWith<$Res> {
  factory _$$GetUserByIdResponseImplCopyWith(_$GetUserByIdResponseImpl value,
          $Res Function(_$GetUserByIdResponseImpl) then) =
      __$$GetUserByIdResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'nickname') String? nickname,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'registered_at') String registeredAt,
      @JsonKey(name: 'metadata_count') int metadataCount});
}

/// @nodoc
class __$$GetUserByIdResponseImplCopyWithImpl<$Res>
    extends _$GetUserByIdResponseCopyWithImpl<$Res, _$GetUserByIdResponseImpl>
    implements _$$GetUserByIdResponseImplCopyWith<$Res> {
  __$$GetUserByIdResponseImplCopyWithImpl(_$GetUserByIdResponseImpl _value,
      $Res Function(_$GetUserByIdResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? nickname = freezed,
    Object? roles = null,
    Object? registeredAt = null,
    Object? metadataCount = null,
  }) {
    return _then(_$GetUserByIdResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String,
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserByIdResponseImpl implements _GetUserByIdResponse {
  const _$GetUserByIdResponseImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'display_name') required this.displayName,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'nickname') this.nickname,
      @JsonKey(name: 'roles') required final List<String> roles,
      @JsonKey(name: 'registered_at') required this.registeredAt,
      @JsonKey(name: 'metadata_count') required this.metadataCount})
      : _roles = roles;

  factory _$GetUserByIdResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserByIdResponseImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'username')
  final String username;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'nickname')
  final String? nickname;
  final List<String> _roles;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  @JsonKey(name: 'registered_at')
  final String registeredAt;
  @override
  @JsonKey(name: 'metadata_count')
  final int metadataCount;

  @override
  String toString() {
    return 'GetUserByIdResponse(id: $id, username: $username, email: $email, displayName: $displayName, firstName: $firstName, lastName: $lastName, nickname: $nickname, roles: $roles, registeredAt: $registeredAt, metadataCount: $metadataCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserByIdResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.metadataCount, metadataCount) ||
                other.metadataCount == metadataCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      email,
      displayName,
      firstName,
      lastName,
      nickname,
      const DeepCollectionEquality().hash(_roles),
      registeredAt,
      metadataCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserByIdResponseImplCopyWith<_$GetUserByIdResponseImpl> get copyWith =>
      __$$GetUserByIdResponseImplCopyWithImpl<_$GetUserByIdResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserByIdResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserByIdResponse implements GetUserByIdResponse {
  const factory _GetUserByIdResponse(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'email') required final String email,
          @JsonKey(name: 'display_name') required final String displayName,
          @JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          @JsonKey(name: 'nickname') final String? nickname,
          @JsonKey(name: 'roles') required final List<String> roles,
          @JsonKey(name: 'registered_at') required final String registeredAt,
          @JsonKey(name: 'metadata_count') required final int metadataCount}) =
      _$GetUserByIdResponseImpl;

  factory _GetUserByIdResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserByIdResponseImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'username')
  String get username;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'nickname')
  String? get nickname;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles;
  @override
  @JsonKey(name: 'registered_at')
  String get registeredAt;
  @override
  @JsonKey(name: 'metadata_count')
  int get metadataCount;
  @override
  @JsonKey(ignore: true)
  _$$GetUserByIdResponseImplCopyWith<_$GetUserByIdResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
