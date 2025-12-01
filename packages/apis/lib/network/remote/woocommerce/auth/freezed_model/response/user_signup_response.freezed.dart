// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_signup_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserSignUpResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message =>
      throw _privateConstructorUsedError; // Made nullable as server sometimes doesn't send message
  UserSignUpData? get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserSignUpResponseCopyWith<UserSignUpResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSignUpResponseCopyWith<$Res> {
  factory $UserSignUpResponseCopyWith(
          UserSignUpResponse value, $Res Function(UserSignUpResponse) then) =
      _$UserSignUpResponseCopyWithImpl<$Res, UserSignUpResponse>;
  @useResult
  $Res call(
      {bool success,
      String? message,
      UserSignUpData? data,
      String? error,
      Map<String, dynamic>? metadata});

  $UserSignUpDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$UserSignUpResponseCopyWithImpl<$Res, $Val extends UserSignUpResponse>
    implements $UserSignUpResponseCopyWith<$Res> {
  _$UserSignUpResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? data = freezed,
    Object? error = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserSignUpData?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSignUpDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $UserSignUpDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSignUpResponseImplCopyWith<$Res>
    implements $UserSignUpResponseCopyWith<$Res> {
  factory _$$UserSignUpResponseImplCopyWith(_$UserSignUpResponseImpl value,
          $Res Function(_$UserSignUpResponseImpl) then) =
      __$$UserSignUpResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? message,
      UserSignUpData? data,
      String? error,
      Map<String, dynamic>? metadata});

  @override
  $UserSignUpDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$UserSignUpResponseImplCopyWithImpl<$Res>
    extends _$UserSignUpResponseCopyWithImpl<$Res, _$UserSignUpResponseImpl>
    implements _$$UserSignUpResponseImplCopyWith<$Res> {
  __$$UserSignUpResponseImplCopyWithImpl(_$UserSignUpResponseImpl _value,
      $Res Function(_$UserSignUpResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? data = freezed,
    Object? error = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UserSignUpResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserSignUpData?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$UserSignUpResponseImpl implements _UserSignUpResponse {
  const _$UserSignUpResponseImpl(
      {required this.success,
      this.message,
      this.data,
      this.error,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  @override
  final bool success;
  @override
  final String? message;
// Made nullable as server sometimes doesn't send message
  @override
  final UserSignUpData? data;
  @override
  final String? error;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserSignUpResponse(success: $success, message: $message, data: $data, error: $error, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSignUpResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, success, message, data, error,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSignUpResponseImplCopyWith<_$UserSignUpResponseImpl> get copyWith =>
      __$$UserSignUpResponseImplCopyWithImpl<_$UserSignUpResponseImpl>(
          this, _$identity);
}

abstract class _UserSignUpResponse implements UserSignUpResponse {
  const factory _UserSignUpResponse(
      {required final bool success,
      final String? message,
      final UserSignUpData? data,
      final String? error,
      final Map<String, dynamic>? metadata}) = _$UserSignUpResponseImpl;

  @override
  bool get success;
  @override
  String? get message;
  @override // Made nullable as server sometimes doesn't send message
  UserSignUpData? get data;
  @override
  String? get error;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UserSignUpResponseImplCopyWith<_$UserSignUpResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSignUpData _$UserSignUpDataFromJson(Map<String, dynamic> json) {
  return _UserSignUpData.fromJson(json);
}

/// @nodoc
mixin _$UserSignUpData {
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get company => throw _privateConstructorUsedError;
  bool? get requiresVerification => throw _privateConstructorUsedError;
  String? get verificationToken => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSignUpDataCopyWith<UserSignUpData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSignUpDataCopyWith<$Res> {
  factory $UserSignUpDataCopyWith(
          UserSignUpData value, $Res Function(UserSignUpData) then) =
      _$UserSignUpDataCopyWithImpl<$Res, UserSignUpData>;
  @useResult
  $Res call(
      {String userId,
      String email,
      String firstName,
      String lastName,
      String? phone,
      String? company,
      bool? requiresVerification,
      String? verificationToken,
      DateTime? createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UserSignUpDataCopyWithImpl<$Res, $Val extends UserSignUpData>
    implements $UserSignUpDataCopyWith<$Res> {
  _$UserSignUpDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? company = freezed,
    Object? requiresVerification = freezed,
    Object? verificationToken = freezed,
    Object? createdAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresVerification: freezed == requiresVerification
          ? _value.requiresVerification
          : requiresVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      verificationToken: freezed == verificationToken
          ? _value.verificationToken
          : verificationToken // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSignUpDataImplCopyWith<$Res>
    implements $UserSignUpDataCopyWith<$Res> {
  factory _$$UserSignUpDataImplCopyWith(_$UserSignUpDataImpl value,
          $Res Function(_$UserSignUpDataImpl) then) =
      __$$UserSignUpDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String email,
      String firstName,
      String lastName,
      String? phone,
      String? company,
      bool? requiresVerification,
      String? verificationToken,
      DateTime? createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UserSignUpDataImplCopyWithImpl<$Res>
    extends _$UserSignUpDataCopyWithImpl<$Res, _$UserSignUpDataImpl>
    implements _$$UserSignUpDataImplCopyWith<$Res> {
  __$$UserSignUpDataImplCopyWithImpl(
      _$UserSignUpDataImpl _value, $Res Function(_$UserSignUpDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? company = freezed,
    Object? requiresVerification = freezed,
    Object? verificationToken = freezed,
    Object? createdAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UserSignUpDataImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresVerification: freezed == requiresVerification
          ? _value.requiresVerification
          : requiresVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      verificationToken: freezed == verificationToken
          ? _value.verificationToken
          : verificationToken // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSignUpDataImpl implements _UserSignUpData {
  const _$UserSignUpDataImpl(
      {required this.userId,
      required this.email,
      required this.firstName,
      required this.lastName,
      this.phone,
      this.company,
      this.requiresVerification,
      this.verificationToken,
      this.createdAt,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$UserSignUpDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSignUpDataImplFromJson(json);

  @override
  final String userId;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? phone;
  @override
  final String? company;
  @override
  final bool? requiresVerification;
  @override
  final String? verificationToken;
  @override
  final DateTime? createdAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserSignUpData(userId: $userId, email: $email, firstName: $firstName, lastName: $lastName, phone: $phone, company: $company, requiresVerification: $requiresVerification, verificationToken: $verificationToken, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSignUpDataImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.requiresVerification, requiresVerification) ||
                other.requiresVerification == requiresVerification) &&
            (identical(other.verificationToken, verificationToken) ||
                other.verificationToken == verificationToken) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      email,
      firstName,
      lastName,
      phone,
      company,
      requiresVerification,
      verificationToken,
      createdAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSignUpDataImplCopyWith<_$UserSignUpDataImpl> get copyWith =>
      __$$UserSignUpDataImplCopyWithImpl<_$UserSignUpDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSignUpDataImplToJson(
      this,
    );
  }
}

abstract class _UserSignUpData implements UserSignUpData {
  const factory _UserSignUpData(
      {required final String userId,
      required final String email,
      required final String firstName,
      required final String lastName,
      final String? phone,
      final String? company,
      final bool? requiresVerification,
      final String? verificationToken,
      final DateTime? createdAt,
      final Map<String, dynamic>? metadata}) = _$UserSignUpDataImpl;

  factory _UserSignUpData.fromJson(Map<String, dynamic> json) =
      _$UserSignUpDataImpl.fromJson;

  @override
  String get userId;
  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get phone;
  @override
  String? get company;
  @override
  bool? get requiresVerification;
  @override
  String? get verificationToken;
  @override
  DateTime? get createdAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UserSignUpDataImplCopyWith<_$UserSignUpDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
