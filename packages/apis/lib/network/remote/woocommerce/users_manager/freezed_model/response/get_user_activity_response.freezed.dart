// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_activity_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserActivityResponse _$GetUserActivityResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserActivityResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserActivityResponse {
  @JsonKey(name: 'activities')
  List<UserActivity> get activities => throw _privateConstructorUsedError;
  @JsonKey(name: 'pagination')
  PaginationInfo get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserActivityResponseCopyWith<GetUserActivityResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserActivityResponseCopyWith<$Res> {
  factory $GetUserActivityResponseCopyWith(GetUserActivityResponse value,
          $Res Function(GetUserActivityResponse) then) =
      _$GetUserActivityResponseCopyWithImpl<$Res, GetUserActivityResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'activities') List<UserActivity> activities,
      @JsonKey(name: 'pagination') PaginationInfo pagination});

  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$GetUserActivityResponseCopyWithImpl<$Res,
        $Val extends GetUserActivityResponse>
    implements $GetUserActivityResponseCopyWith<$Res> {
  _$GetUserActivityResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<UserActivity>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res> get pagination {
    return $PaginationInfoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetUserActivityResponseImplCopyWith<$Res>
    implements $GetUserActivityResponseCopyWith<$Res> {
  factory _$$GetUserActivityResponseImplCopyWith(
          _$GetUserActivityResponseImpl value,
          $Res Function(_$GetUserActivityResponseImpl) then) =
      __$$GetUserActivityResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'activities') List<UserActivity> activities,
      @JsonKey(name: 'pagination') PaginationInfo pagination});

  @override
  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$GetUserActivityResponseImplCopyWithImpl<$Res>
    extends _$GetUserActivityResponseCopyWithImpl<$Res,
        _$GetUserActivityResponseImpl>
    implements _$$GetUserActivityResponseImplCopyWith<$Res> {
  __$$GetUserActivityResponseImplCopyWithImpl(
      _$GetUserActivityResponseImpl _value,
      $Res Function(_$GetUserActivityResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? pagination = null,
  }) {
    return _then(_$GetUserActivityResponseImpl(
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<UserActivity>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserActivityResponseImpl implements _GetUserActivityResponse {
  const _$GetUserActivityResponseImpl(
      {@JsonKey(name: 'activities')
      required final List<UserActivity> activities,
      @JsonKey(name: 'pagination') required this.pagination})
      : _activities = activities;

  factory _$GetUserActivityResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserActivityResponseImplFromJson(json);

  final List<UserActivity> _activities;
  @override
  @JsonKey(name: 'activities')
  List<UserActivity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  @JsonKey(name: 'pagination')
  final PaginationInfo pagination;

  @override
  String toString() {
    return 'GetUserActivityResponse(activities: $activities, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserActivityResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_activities), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserActivityResponseImplCopyWith<_$GetUserActivityResponseImpl>
      get copyWith => __$$GetUserActivityResponseImplCopyWithImpl<
          _$GetUserActivityResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserActivityResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserActivityResponse implements GetUserActivityResponse {
  const factory _GetUserActivityResponse(
          {@JsonKey(name: 'activities')
          required final List<UserActivity> activities,
          @JsonKey(name: 'pagination')
          required final PaginationInfo pagination}) =
      _$GetUserActivityResponseImpl;

  factory _GetUserActivityResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserActivityResponseImpl.fromJson;

  @override
  @JsonKey(name: 'activities')
  List<UserActivity> get activities;
  @override
  @JsonKey(name: 'pagination')
  PaginationInfo get pagination;
  @override
  @JsonKey(ignore: true)
  _$$GetUserActivityResponseImplCopyWith<_$GetUserActivityResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LogActivityResponse _$LogActivityResponseFromJson(Map<String, dynamic> json) {
  return _LogActivityResponse.fromJson(json);
}

/// @nodoc
mixin _$LogActivityResponse {
  @JsonKey(name: 'success')
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_id')
  int get activityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LogActivityResponseCopyWith<LogActivityResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogActivityResponseCopyWith<$Res> {
  factory $LogActivityResponseCopyWith(
          LogActivityResponse value, $Res Function(LogActivityResponse) then) =
      _$LogActivityResponseCopyWithImpl<$Res, LogActivityResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'activity_id') int activityId,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class _$LogActivityResponseCopyWithImpl<$Res, $Val extends LogActivityResponse>
    implements $LogActivityResponseCopyWith<$Res> {
  _$LogActivityResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? activityId = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogActivityResponseImplCopyWith<$Res>
    implements $LogActivityResponseCopyWith<$Res> {
  factory _$$LogActivityResponseImplCopyWith(_$LogActivityResponseImpl value,
          $Res Function(_$LogActivityResponseImpl) then) =
      __$$LogActivityResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'activity_id') int activityId,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class __$$LogActivityResponseImplCopyWithImpl<$Res>
    extends _$LogActivityResponseCopyWithImpl<$Res, _$LogActivityResponseImpl>
    implements _$$LogActivityResponseImplCopyWith<$Res> {
  __$$LogActivityResponseImplCopyWithImpl(_$LogActivityResponseImpl _value,
      $Res Function(_$LogActivityResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? activityId = null,
    Object? message = null,
  }) {
    return _then(_$LogActivityResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LogActivityResponseImpl implements _LogActivityResponse {
  const _$LogActivityResponseImpl(
      {@JsonKey(name: 'success') required this.success,
      @JsonKey(name: 'activity_id') required this.activityId,
      @JsonKey(name: 'message') required this.message});

  factory _$LogActivityResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogActivityResponseImplFromJson(json);

  @override
  @JsonKey(name: 'success')
  final bool success;
  @override
  @JsonKey(name: 'activity_id')
  final int activityId;
  @override
  @JsonKey(name: 'message')
  final String message;

  @override
  String toString() {
    return 'LogActivityResponse(success: $success, activityId: $activityId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogActivityResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, activityId, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LogActivityResponseImplCopyWith<_$LogActivityResponseImpl> get copyWith =>
      __$$LogActivityResponseImplCopyWithImpl<_$LogActivityResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogActivityResponseImplToJson(
      this,
    );
  }
}

abstract class _LogActivityResponse implements LogActivityResponse {
  const factory _LogActivityResponse(
          {@JsonKey(name: 'success') required final bool success,
          @JsonKey(name: 'activity_id') required final int activityId,
          @JsonKey(name: 'message') required final String message}) =
      _$LogActivityResponseImpl;

  factory _LogActivityResponse.fromJson(Map<String, dynamic> json) =
      _$LogActivityResponseImpl.fromJson;

  @override
  @JsonKey(name: 'success')
  bool get success;
  @override
  @JsonKey(name: 'activity_id')
  int get activityId;
  @override
  @JsonKey(name: 'message')
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$LogActivityResponseImplCopyWith<_$LogActivityResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
