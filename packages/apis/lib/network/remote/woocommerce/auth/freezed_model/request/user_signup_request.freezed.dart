// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_signup_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserMeta _$UserMetaFromJson(Map<String, dynamic> json) {
  return _UserMeta.fromJson(json);
}

/// @nodoc
mixin _$UserMeta {
  @JsonKey(name: 'accept_terms')
  bool get acceptTerms => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscribe_newsletter')
  bool get subscribeNewsletter => throw _privateConstructorUsedError;

  /// Serializes this UserMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserMetaCopyWith<UserMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMetaCopyWith<$Res> {
  factory $UserMetaCopyWith(UserMeta value, $Res Function(UserMeta) then) =
      _$UserMetaCopyWithImpl<$Res, UserMeta>;
  @useResult
  $Res call(
      {@JsonKey(name: 'accept_terms') bool acceptTerms,
      @JsonKey(name: 'subscribe_newsletter') bool subscribeNewsletter});
}

/// @nodoc
class _$UserMetaCopyWithImpl<$Res, $Val extends UserMeta>
    implements $UserMetaCopyWith<$Res> {
  _$UserMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptTerms = null,
    Object? subscribeNewsletter = null,
  }) {
    return _then(_value.copyWith(
      acceptTerms: null == acceptTerms
          ? _value.acceptTerms
          : acceptTerms // ignore: cast_nullable_to_non_nullable
              as bool,
      subscribeNewsletter: null == subscribeNewsletter
          ? _value.subscribeNewsletter
          : subscribeNewsletter // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserMetaImplCopyWith<$Res>
    implements $UserMetaCopyWith<$Res> {
  factory _$$UserMetaImplCopyWith(
          _$UserMetaImpl value, $Res Function(_$UserMetaImpl) then) =
      __$$UserMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'accept_terms') bool acceptTerms,
      @JsonKey(name: 'subscribe_newsletter') bool subscribeNewsletter});
}

/// @nodoc
class __$$UserMetaImplCopyWithImpl<$Res>
    extends _$UserMetaCopyWithImpl<$Res, _$UserMetaImpl>
    implements _$$UserMetaImplCopyWith<$Res> {
  __$$UserMetaImplCopyWithImpl(
      _$UserMetaImpl _value, $Res Function(_$UserMetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptTerms = null,
    Object? subscribeNewsletter = null,
  }) {
    return _then(_$UserMetaImpl(
      acceptTerms: null == acceptTerms
          ? _value.acceptTerms
          : acceptTerms // ignore: cast_nullable_to_non_nullable
              as bool,
      subscribeNewsletter: null == subscribeNewsletter
          ? _value.subscribeNewsletter
          : subscribeNewsletter // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMetaImpl implements _UserMeta {
  const _$UserMetaImpl(
      {@JsonKey(name: 'accept_terms') this.acceptTerms = true,
      @JsonKey(name: 'subscribe_newsletter') this.subscribeNewsletter = false});

  factory _$UserMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMetaImplFromJson(json);

  @override
  @JsonKey(name: 'accept_terms')
  final bool acceptTerms;
  @override
  @JsonKey(name: 'subscribe_newsletter')
  final bool subscribeNewsletter;

  @override
  String toString() {
    return 'UserMeta(acceptTerms: $acceptTerms, subscribeNewsletter: $subscribeNewsletter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMetaImpl &&
            (identical(other.acceptTerms, acceptTerms) ||
                other.acceptTerms == acceptTerms) &&
            (identical(other.subscribeNewsletter, subscribeNewsletter) ||
                other.subscribeNewsletter == subscribeNewsletter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, acceptTerms, subscribeNewsletter);

  /// Create a copy of UserMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMetaImplCopyWith<_$UserMetaImpl> get copyWith =>
      __$$UserMetaImplCopyWithImpl<_$UserMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMetaImplToJson(
      this,
    );
  }
}

abstract class _UserMeta implements UserMeta {
  const factory _UserMeta(
      {@JsonKey(name: 'accept_terms') final bool acceptTerms,
      @JsonKey(name: 'subscribe_newsletter')
      final bool subscribeNewsletter}) = _$UserMetaImpl;

  factory _UserMeta.fromJson(Map<String, dynamic> json) =
      _$UserMetaImpl.fromJson;

  @override
  @JsonKey(name: 'accept_terms')
  bool get acceptTerms;
  @override
  @JsonKey(name: 'subscribe_newsletter')
  bool get subscribeNewsletter;

  /// Create a copy of UserMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserMetaImplCopyWith<_$UserMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSignUpRequest _$UserSignUpRequestFromJson(Map<String, dynamic> json) {
  return _UserSignUpRequest.fromJson(json);
}

/// @nodoc
mixin _$UserSignUpRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'AUTH_KEY')
  String get authKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get company => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_meta')
  UserMeta get userMeta => throw _privateConstructorUsedError;
  @JsonKey(name: 'referral_code')
  String? get referralCode => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this UserSignUpRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSignUpRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSignUpRequestCopyWith<UserSignUpRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSignUpRequestCopyWith<$Res> {
  factory $UserSignUpRequestCopyWith(
          UserSignUpRequest value, $Res Function(UserSignUpRequest) then) =
      _$UserSignUpRequestCopyWithImpl<$Res, UserSignUpRequest>;
  @useResult
  $Res call(
      {String email,
      String password,
      @JsonKey(name: 'AUTH_KEY') String authKey,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String? phone,
      String? company,
      @JsonKey(name: 'user_meta') UserMeta userMeta,
      @JsonKey(name: 'referral_code') String? referralCode,
      Map<String, dynamic>? metadata});

  $UserMetaCopyWith<$Res> get userMeta;
}

/// @nodoc
class _$UserSignUpRequestCopyWithImpl<$Res, $Val extends UserSignUpRequest>
    implements $UserSignUpRequestCopyWith<$Res> {
  _$UserSignUpRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSignUpRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? authKey = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? company = freezed,
    Object? userMeta = null,
    Object? referralCode = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      authKey: null == authKey
          ? _value.authKey
          : authKey // ignore: cast_nullable_to_non_nullable
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
      userMeta: null == userMeta
          ? _value.userMeta
          : userMeta // ignore: cast_nullable_to_non_nullable
              as UserMeta,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of UserSignUpRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserMetaCopyWith<$Res> get userMeta {
    return $UserMetaCopyWith<$Res>(_value.userMeta, (value) {
      return _then(_value.copyWith(userMeta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSignUpRequestImplCopyWith<$Res>
    implements $UserSignUpRequestCopyWith<$Res> {
  factory _$$UserSignUpRequestImplCopyWith(_$UserSignUpRequestImpl value,
          $Res Function(_$UserSignUpRequestImpl) then) =
      __$$UserSignUpRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      @JsonKey(name: 'AUTH_KEY') String authKey,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String? phone,
      String? company,
      @JsonKey(name: 'user_meta') UserMeta userMeta,
      @JsonKey(name: 'referral_code') String? referralCode,
      Map<String, dynamic>? metadata});

  @override
  $UserMetaCopyWith<$Res> get userMeta;
}

/// @nodoc
class __$$UserSignUpRequestImplCopyWithImpl<$Res>
    extends _$UserSignUpRequestCopyWithImpl<$Res, _$UserSignUpRequestImpl>
    implements _$$UserSignUpRequestImplCopyWith<$Res> {
  __$$UserSignUpRequestImplCopyWithImpl(_$UserSignUpRequestImpl _value,
      $Res Function(_$UserSignUpRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSignUpRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? authKey = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? company = freezed,
    Object? userMeta = null,
    Object? referralCode = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UserSignUpRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      authKey: null == authKey
          ? _value.authKey
          : authKey // ignore: cast_nullable_to_non_nullable
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
      userMeta: null == userMeta
          ? _value.userMeta
          : userMeta // ignore: cast_nullable_to_non_nullable
              as UserMeta,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSignUpRequestImpl implements _UserSignUpRequest {
  const _$UserSignUpRequestImpl(
      {required this.email,
      required this.password,
      @JsonKey(name: 'AUTH_KEY') required this.authKey,
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      this.phone,
      this.company,
      @JsonKey(name: 'user_meta') required this.userMeta,
      @JsonKey(name: 'referral_code') this.referralCode,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$UserSignUpRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSignUpRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey(name: 'AUTH_KEY')
  final String authKey;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final String? phone;
  @override
  final String? company;
  @override
  @JsonKey(name: 'user_meta')
  final UserMeta userMeta;
  @override
  @JsonKey(name: 'referral_code')
  final String? referralCode;
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
    return 'UserSignUpRequest(email: $email, password: $password, authKey: $authKey, firstName: $firstName, lastName: $lastName, phone: $phone, company: $company, userMeta: $userMeta, referralCode: $referralCode, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSignUpRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.authKey, authKey) || other.authKey == authKey) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.userMeta, userMeta) ||
                other.userMeta == userMeta) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      email,
      password,
      authKey,
      firstName,
      lastName,
      phone,
      company,
      userMeta,
      referralCode,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of UserSignUpRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSignUpRequestImplCopyWith<_$UserSignUpRequestImpl> get copyWith =>
      __$$UserSignUpRequestImplCopyWithImpl<_$UserSignUpRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSignUpRequestImplToJson(
      this,
    );
  }
}

abstract class _UserSignUpRequest implements UserSignUpRequest {
  const factory _UserSignUpRequest(
      {required final String email,
      required final String password,
      @JsonKey(name: 'AUTH_KEY') required final String authKey,
      @JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      final String? phone,
      final String? company,
      @JsonKey(name: 'user_meta') required final UserMeta userMeta,
      @JsonKey(name: 'referral_code') final String? referralCode,
      final Map<String, dynamic>? metadata}) = _$UserSignUpRequestImpl;

  factory _UserSignUpRequest.fromJson(Map<String, dynamic> json) =
      _$UserSignUpRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(name: 'AUTH_KEY')
  String get authKey;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  String? get phone;
  @override
  String? get company;
  @override
  @JsonKey(name: 'user_meta')
  UserMeta get userMeta;
  @override
  @JsonKey(name: 'referral_code')
  String? get referralCode;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of UserSignUpRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSignUpRequestImplCopyWith<_$UserSignUpRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
