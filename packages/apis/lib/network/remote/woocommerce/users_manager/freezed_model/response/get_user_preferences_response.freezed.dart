// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_preferences_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserPreferencesResponse _$GetUserPreferencesResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserPreferencesResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserPreferencesResponse {
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences')
  Map<String, UserPreference> get preferences =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  int get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserPreferencesResponseCopyWith<GetUserPreferencesResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserPreferencesResponseCopyWith<$Res> {
  factory $GetUserPreferencesResponseCopyWith(GetUserPreferencesResponse value,
          $Res Function(GetUserPreferencesResponse) then) =
      _$GetUserPreferencesResponseCopyWithImpl<$Res,
          GetUserPreferencesResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'preferences') Map<String, UserPreference> preferences,
      @JsonKey(name: 'count') int count});
}

/// @nodoc
class _$GetUserPreferencesResponseCopyWithImpl<$Res,
        $Val extends GetUserPreferencesResponse>
    implements $GetUserPreferencesResponseCopyWith<$Res> {
  _$GetUserPreferencesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferences = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, UserPreference>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetUserPreferencesResponseImplCopyWith<$Res>
    implements $GetUserPreferencesResponseCopyWith<$Res> {
  factory _$$GetUserPreferencesResponseImplCopyWith(
          _$GetUserPreferencesResponseImpl value,
          $Res Function(_$GetUserPreferencesResponseImpl) then) =
      __$$GetUserPreferencesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'preferences') Map<String, UserPreference> preferences,
      @JsonKey(name: 'count') int count});
}

/// @nodoc
class __$$GetUserPreferencesResponseImplCopyWithImpl<$Res>
    extends _$GetUserPreferencesResponseCopyWithImpl<$Res,
        _$GetUserPreferencesResponseImpl>
    implements _$$GetUserPreferencesResponseImplCopyWith<$Res> {
  __$$GetUserPreferencesResponseImplCopyWithImpl(
      _$GetUserPreferencesResponseImpl _value,
      $Res Function(_$GetUserPreferencesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? preferences = null,
    Object? count = null,
  }) {
    return _then(_$GetUserPreferencesResponseImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, UserPreference>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserPreferencesResponseImpl implements _GetUserPreferencesResponse {
  const _$GetUserPreferencesResponseImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'preferences')
      required final Map<String, UserPreference> preferences,
      @JsonKey(name: 'count') required this.count})
      : _preferences = preferences;

  factory _$GetUserPreferencesResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetUserPreferencesResponseImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final int userId;
  final Map<String, UserPreference> _preferences;
  @override
  @JsonKey(name: 'preferences')
  Map<String, UserPreference> get preferences {
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preferences);
  }

  @override
  @JsonKey(name: 'count')
  final int count;

  @override
  String toString() {
    return 'GetUserPreferencesResponse(userId: $userId, preferences: $preferences, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserPreferencesResponseImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId,
      const DeepCollectionEquality().hash(_preferences), count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserPreferencesResponseImplCopyWith<_$GetUserPreferencesResponseImpl>
      get copyWith => __$$GetUserPreferencesResponseImplCopyWithImpl<
          _$GetUserPreferencesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserPreferencesResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserPreferencesResponse
    implements GetUserPreferencesResponse {
  const factory _GetUserPreferencesResponse(
          {@JsonKey(name: 'user_id') required final int userId,
          @JsonKey(name: 'preferences')
          required final Map<String, UserPreference> preferences,
          @JsonKey(name: 'count') required final int count}) =
      _$GetUserPreferencesResponseImpl;

  factory _GetUserPreferencesResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserPreferencesResponseImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'preferences')
  Map<String, UserPreference> get preferences;
  @override
  @JsonKey(name: 'count')
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$GetUserPreferencesResponseImplCopyWith<_$GetUserPreferencesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdatePreferencesResponse _$UpdatePreferencesResponseFromJson(
    Map<String, dynamic> json) {
  return _UpdatePreferencesResponse.fromJson(json);
}

/// @nodoc
mixin _$UpdatePreferencesResponse {
  @JsonKey(name: 'success')
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  List<String> get updated => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdatePreferencesResponseCopyWith<UpdatePreferencesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePreferencesResponseCopyWith<$Res> {
  factory $UpdatePreferencesResponseCopyWith(UpdatePreferencesResponse value,
          $Res Function(UpdatePreferencesResponse) then) =
      _$UpdatePreferencesResponseCopyWithImpl<$Res, UpdatePreferencesResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'updated') List<String> updated,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class _$UpdatePreferencesResponseCopyWithImpl<$Res,
        $Val extends UpdatePreferencesResponse>
    implements $UpdatePreferencesResponseCopyWith<$Res> {
  _$UpdatePreferencesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? updated = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePreferencesResponseImplCopyWith<$Res>
    implements $UpdatePreferencesResponseCopyWith<$Res> {
  factory _$$UpdatePreferencesResponseImplCopyWith(
          _$UpdatePreferencesResponseImpl value,
          $Res Function(_$UpdatePreferencesResponseImpl) then) =
      __$$UpdatePreferencesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'updated') List<String> updated,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class __$$UpdatePreferencesResponseImplCopyWithImpl<$Res>
    extends _$UpdatePreferencesResponseCopyWithImpl<$Res,
        _$UpdatePreferencesResponseImpl>
    implements _$$UpdatePreferencesResponseImplCopyWith<$Res> {
  __$$UpdatePreferencesResponseImplCopyWithImpl(
      _$UpdatePreferencesResponseImpl _value,
      $Res Function(_$UpdatePreferencesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? updated = null,
    Object? message = null,
  }) {
    return _then(_$UpdatePreferencesResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      updated: null == updated
          ? _value._updated
          : updated // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePreferencesResponseImpl implements _UpdatePreferencesResponse {
  const _$UpdatePreferencesResponseImpl(
      {@JsonKey(name: 'success') required this.success,
      @JsonKey(name: 'updated') required final List<String> updated,
      @JsonKey(name: 'message') required this.message})
      : _updated = updated;

  factory _$UpdatePreferencesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePreferencesResponseImplFromJson(json);

  @override
  @JsonKey(name: 'success')
  final bool success;
  final List<String> _updated;
  @override
  @JsonKey(name: 'updated')
  List<String> get updated {
    if (_updated is EqualUnmodifiableListView) return _updated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updated);
  }

  @override
  @JsonKey(name: 'message')
  final String message;

  @override
  String toString() {
    return 'UpdatePreferencesResponse(success: $success, updated: $updated, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePreferencesResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._updated, _updated) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success,
      const DeepCollectionEquality().hash(_updated), message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePreferencesResponseImplCopyWith<_$UpdatePreferencesResponseImpl>
      get copyWith => __$$UpdatePreferencesResponseImplCopyWithImpl<
          _$UpdatePreferencesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePreferencesResponseImplToJson(
      this,
    );
  }
}

abstract class _UpdatePreferencesResponse implements UpdatePreferencesResponse {
  const factory _UpdatePreferencesResponse(
          {@JsonKey(name: 'success') required final bool success,
          @JsonKey(name: 'updated') required final List<String> updated,
          @JsonKey(name: 'message') required final String message}) =
      _$UpdatePreferencesResponseImpl;

  factory _UpdatePreferencesResponse.fromJson(Map<String, dynamic> json) =
      _$UpdatePreferencesResponseImpl.fromJson;

  @override
  @JsonKey(name: 'success')
  bool get success;
  @override
  @JsonKey(name: 'updated')
  List<String> get updated;
  @override
  @JsonKey(name: 'message')
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$UpdatePreferencesResponseImplCopyWith<_$UpdatePreferencesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
