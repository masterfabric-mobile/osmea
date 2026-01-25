// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserProfileResponse _$GetUserProfileResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserProfileResponse {
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'registered_at')
  String get registeredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'statistics')
  UserProfileStatistics get statistics => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserProfileResponseCopyWith<GetUserProfileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserProfileResponseCopyWith<$Res> {
  factory $GetUserProfileResponseCopyWith(GetUserProfileResponse value,
          $Res Function(GetUserProfileResponse) then) =
      _$GetUserProfileResponseCopyWithImpl<$Res, GetUserProfileResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'registered_at') String registeredAt,
      @JsonKey(name: 'statistics') UserProfileStatistics statistics});

  $UserProfileStatisticsCopyWith<$Res> get statistics;
}

/// @nodoc
class _$GetUserProfileResponseCopyWithImpl<$Res,
        $Val extends GetUserProfileResponse>
    implements $GetUserProfileResponseCopyWith<$Res> {
  _$GetUserProfileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? registeredAt = null,
    Object? statistics = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String,
      statistics: null == statistics
          ? _value.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as UserProfileStatistics,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileStatisticsCopyWith<$Res> get statistics {
    return $UserProfileStatisticsCopyWith<$Res>(_value.statistics, (value) {
      return _then(_value.copyWith(statistics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetUserProfileResponseImplCopyWith<$Res>
    implements $GetUserProfileResponseCopyWith<$Res> {
  factory _$$GetUserProfileResponseImplCopyWith(
          _$GetUserProfileResponseImpl value,
          $Res Function(_$GetUserProfileResponseImpl) then) =
      __$$GetUserProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'registered_at') String registeredAt,
      @JsonKey(name: 'statistics') UserProfileStatistics statistics});

  @override
  $UserProfileStatisticsCopyWith<$Res> get statistics;
}

/// @nodoc
class __$$GetUserProfileResponseImplCopyWithImpl<$Res>
    extends _$GetUserProfileResponseCopyWithImpl<$Res,
        _$GetUserProfileResponseImpl>
    implements _$$GetUserProfileResponseImplCopyWith<$Res> {
  __$$GetUserProfileResponseImplCopyWithImpl(
      _$GetUserProfileResponseImpl _value,
      $Res Function(_$GetUserProfileResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? registeredAt = null,
    Object? statistics = null,
  }) {
    return _then(_$GetUserProfileResponseImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String,
      statistics: null == statistics
          ? _value.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as UserProfileStatistics,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserProfileResponseImpl implements _GetUserProfileResponse {
  const _$GetUserProfileResponseImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'display_name') required this.displayName,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'registered_at') required this.registeredAt,
      @JsonKey(name: 'statistics') required this.statistics});

  factory _$GetUserProfileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserProfileResponseImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final int userId;
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
  @JsonKey(name: 'registered_at')
  final String registeredAt;
  @override
  @JsonKey(name: 'statistics')
  final UserProfileStatistics statistics;

  @override
  String toString() {
    return 'GetUserProfileResponse(userId: $userId, username: $username, email: $email, displayName: $displayName, firstName: $firstName, lastName: $lastName, registeredAt: $registeredAt, statistics: $statistics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserProfileResponseImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, username, email,
      displayName, firstName, lastName, registeredAt, statistics);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserProfileResponseImplCopyWith<_$GetUserProfileResponseImpl>
      get copyWith => __$$GetUserProfileResponseImplCopyWithImpl<
          _$GetUserProfileResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserProfileResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserProfileResponse implements GetUserProfileResponse {
  const factory _GetUserProfileResponse(
          {@JsonKey(name: 'user_id') required final int userId,
          @JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'email') required final String email,
          @JsonKey(name: 'display_name') required final String displayName,
          @JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          @JsonKey(name: 'registered_at') required final String registeredAt,
          @JsonKey(name: 'statistics')
          required final UserProfileStatistics statistics}) =
      _$GetUserProfileResponseImpl;

  factory _GetUserProfileResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserProfileResponseImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  int get userId;
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
  @JsonKey(name: 'registered_at')
  String get registeredAt;
  @override
  @JsonKey(name: 'statistics')
  UserProfileStatistics get statistics;
  @override
  @JsonKey(ignore: true)
  _$$GetUserProfileResponseImplCopyWith<_$GetUserProfileResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserProfileStatistics _$UserProfileStatisticsFromJson(
    Map<String, dynamic> json) {
  return _UserProfileStatistics.fromJson(json);
}

/// @nodoc
mixin _$UserProfileStatistics {
  @JsonKey(name: 'metadata_count')
  int get metadataCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_count')
  int get ordersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'contracts_count')
  int get contractsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileStatisticsCopyWith<UserProfileStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileStatisticsCopyWith<$Res> {
  factory $UserProfileStatisticsCopyWith(UserProfileStatistics value,
          $Res Function(UserProfileStatistics) then) =
      _$UserProfileStatisticsCopyWithImpl<$Res, UserProfileStatistics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'metadata_count') int metadataCount,
      @JsonKey(name: 'orders_count') int ordersCount,
      @JsonKey(name: 'contracts_count') int contractsCount});
}

/// @nodoc
class _$UserProfileStatisticsCopyWithImpl<$Res,
        $Val extends UserProfileStatistics>
    implements $UserProfileStatisticsCopyWith<$Res> {
  _$UserProfileStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadataCount = null,
    Object? ordersCount = null,
    Object? contractsCount = null,
  }) {
    return _then(_value.copyWith(
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
      ordersCount: null == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int,
      contractsCount: null == contractsCount
          ? _value.contractsCount
          : contractsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileStatisticsImplCopyWith<$Res>
    implements $UserProfileStatisticsCopyWith<$Res> {
  factory _$$UserProfileStatisticsImplCopyWith(
          _$UserProfileStatisticsImpl value,
          $Res Function(_$UserProfileStatisticsImpl) then) =
      __$$UserProfileStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'metadata_count') int metadataCount,
      @JsonKey(name: 'orders_count') int ordersCount,
      @JsonKey(name: 'contracts_count') int contractsCount});
}

/// @nodoc
class __$$UserProfileStatisticsImplCopyWithImpl<$Res>
    extends _$UserProfileStatisticsCopyWithImpl<$Res,
        _$UserProfileStatisticsImpl>
    implements _$$UserProfileStatisticsImplCopyWith<$Res> {
  __$$UserProfileStatisticsImplCopyWithImpl(_$UserProfileStatisticsImpl _value,
      $Res Function(_$UserProfileStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadataCount = null,
    Object? ordersCount = null,
    Object? contractsCount = null,
  }) {
    return _then(_$UserProfileStatisticsImpl(
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
      ordersCount: null == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int,
      contractsCount: null == contractsCount
          ? _value.contractsCount
          : contractsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileStatisticsImpl implements _UserProfileStatistics {
  const _$UserProfileStatisticsImpl(
      {@JsonKey(name: 'metadata_count') required this.metadataCount,
      @JsonKey(name: 'orders_count') required this.ordersCount,
      @JsonKey(name: 'contracts_count') required this.contractsCount});

  factory _$UserProfileStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'metadata_count')
  final int metadataCount;
  @override
  @JsonKey(name: 'orders_count')
  final int ordersCount;
  @override
  @JsonKey(name: 'contracts_count')
  final int contractsCount;

  @override
  String toString() {
    return 'UserProfileStatistics(metadataCount: $metadataCount, ordersCount: $ordersCount, contractsCount: $contractsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileStatisticsImpl &&
            (identical(other.metadataCount, metadataCount) ||
                other.metadataCount == metadataCount) &&
            (identical(other.ordersCount, ordersCount) ||
                other.ordersCount == ordersCount) &&
            (identical(other.contractsCount, contractsCount) ||
                other.contractsCount == contractsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, metadataCount, ordersCount, contractsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileStatisticsImplCopyWith<_$UserProfileStatisticsImpl>
      get copyWith => __$$UserProfileStatisticsImplCopyWithImpl<
          _$UserProfileStatisticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileStatisticsImplToJson(
      this,
    );
  }
}

abstract class _UserProfileStatistics implements UserProfileStatistics {
  const factory _UserProfileStatistics(
      {@JsonKey(name: 'metadata_count') required final int metadataCount,
      @JsonKey(name: 'orders_count') required final int ordersCount,
      @JsonKey(name: 'contracts_count')
      required final int contractsCount}) = _$UserProfileStatisticsImpl;

  factory _UserProfileStatistics.fromJson(Map<String, dynamic> json) =
      _$UserProfileStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'metadata_count')
  int get metadataCount;
  @override
  @JsonKey(name: 'orders_count')
  int get ordersCount;
  @override
  @JsonKey(name: 'contracts_count')
  int get contractsCount;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileStatisticsImplCopyWith<_$UserProfileStatisticsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
