// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_user_activity_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LogUserActivityRequest _$LogUserActivityRequestFromJson(
    Map<String, dynamic> json) {
  return _LogUserActivityRequest.fromJson(json);
}

/// @nodoc
mixin _$LogUserActivityRequest {
  @JsonKey(name: 'activity_type')
  String get activityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_description')
  String? get activityDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LogUserActivityRequestCopyWith<LogUserActivityRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogUserActivityRequestCopyWith<$Res> {
  factory $LogUserActivityRequestCopyWith(LogUserActivityRequest value,
          $Res Function(LogUserActivityRequest) then) =
      _$LogUserActivityRequestCopyWithImpl<$Res, LogUserActivityRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'activity_type') String activityType,
      @JsonKey(name: 'activity_description') String? activityDescription,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata});
}

/// @nodoc
class _$LogUserActivityRequestCopyWithImpl<$Res,
        $Val extends LogUserActivityRequest>
    implements $LogUserActivityRequestCopyWith<$Res> {
  _$LogUserActivityRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityType = null,
    Object? activityDescription = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      activityDescription: freezed == activityDescription
          ? _value.activityDescription
          : activityDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogUserActivityRequestImplCopyWith<$Res>
    implements $LogUserActivityRequestCopyWith<$Res> {
  factory _$$LogUserActivityRequestImplCopyWith(
          _$LogUserActivityRequestImpl value,
          $Res Function(_$LogUserActivityRequestImpl) then) =
      __$$LogUserActivityRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'activity_type') String activityType,
      @JsonKey(name: 'activity_description') String? activityDescription,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$LogUserActivityRequestImplCopyWithImpl<$Res>
    extends _$LogUserActivityRequestCopyWithImpl<$Res,
        _$LogUserActivityRequestImpl>
    implements _$$LogUserActivityRequestImplCopyWith<$Res> {
  __$$LogUserActivityRequestImplCopyWithImpl(
      _$LogUserActivityRequestImpl _value,
      $Res Function(_$LogUserActivityRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityType = null,
    Object? activityDescription = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$LogUserActivityRequestImpl(
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      activityDescription: freezed == activityDescription
          ? _value.activityDescription
          : activityDescription // ignore: cast_nullable_to_non_nullable
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
class _$LogUserActivityRequestImpl implements _LogUserActivityRequest {
  const _$LogUserActivityRequestImpl(
      {@JsonKey(name: 'activity_type') required this.activityType,
      @JsonKey(name: 'activity_description') this.activityDescription,
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$LogUserActivityRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogUserActivityRequestImplFromJson(json);

  @override
  @JsonKey(name: 'activity_type')
  final String activityType;
  @override
  @JsonKey(name: 'activity_description')
  final String? activityDescription;
  final Map<String, dynamic>? _metadata;
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LogUserActivityRequest(activityType: $activityType, activityDescription: $activityDescription, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogUserActivityRequestImpl &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.activityDescription, activityDescription) ||
                other.activityDescription == activityDescription) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, activityType,
      activityDescription, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LogUserActivityRequestImplCopyWith<_$LogUserActivityRequestImpl>
      get copyWith => __$$LogUserActivityRequestImplCopyWithImpl<
          _$LogUserActivityRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogUserActivityRequestImplToJson(
      this,
    );
  }
}

abstract class _LogUserActivityRequest implements LogUserActivityRequest {
  const factory _LogUserActivityRequest(
      {@JsonKey(name: 'activity_type') required final String activityType,
      @JsonKey(name: 'activity_description') final String? activityDescription,
      @JsonKey(name: 'metadata')
      final Map<String, dynamic>? metadata}) = _$LogUserActivityRequestImpl;

  factory _LogUserActivityRequest.fromJson(Map<String, dynamic> json) =
      _$LogUserActivityRequestImpl.fromJson;

  @override
  @JsonKey(name: 'activity_type')
  String get activityType;
  @override
  @JsonKey(name: 'activity_description')
  String? get activityDescription;
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$LogUserActivityRequestImplCopyWith<_$LogUserActivityRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
