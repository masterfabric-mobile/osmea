// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateUserProfileResponse _$UpdateUserProfileResponseFromJson(
    Map<String, dynamic> json) {
  return _UpdateUserProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserProfileResponse {
  @JsonKey(name: 'success')
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  List<String> get updated => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'errors')
  List<String>? get errors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateUserProfileResponseCopyWith<UpdateUserProfileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserProfileResponseCopyWith<$Res> {
  factory $UpdateUserProfileResponseCopyWith(UpdateUserProfileResponse value,
          $Res Function(UpdateUserProfileResponse) then) =
      _$UpdateUserProfileResponseCopyWithImpl<$Res, UpdateUserProfileResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'updated') List<String> updated,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'errors') List<String>? errors});
}

/// @nodoc
class _$UpdateUserProfileResponseCopyWithImpl<$Res,
        $Val extends UpdateUserProfileResponse>
    implements $UpdateUserProfileResponseCopyWith<$Res> {
  _$UpdateUserProfileResponseCopyWithImpl(this._value, this._then);

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
    Object? errors = freezed,
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
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateUserProfileResponseImplCopyWith<$Res>
    implements $UpdateUserProfileResponseCopyWith<$Res> {
  factory _$$UpdateUserProfileResponseImplCopyWith(
          _$UpdateUserProfileResponseImpl value,
          $Res Function(_$UpdateUserProfileResponseImpl) then) =
      __$$UpdateUserProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'updated') List<String> updated,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'errors') List<String>? errors});
}

/// @nodoc
class __$$UpdateUserProfileResponseImplCopyWithImpl<$Res>
    extends _$UpdateUserProfileResponseCopyWithImpl<$Res,
        _$UpdateUserProfileResponseImpl>
    implements _$$UpdateUserProfileResponseImplCopyWith<$Res> {
  __$$UpdateUserProfileResponseImplCopyWithImpl(
      _$UpdateUserProfileResponseImpl _value,
      $Res Function(_$UpdateUserProfileResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? updated = null,
    Object? message = null,
    Object? errors = freezed,
  }) {
    return _then(_$UpdateUserProfileResponseImpl(
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
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserProfileResponseImpl implements _UpdateUserProfileResponse {
  const _$UpdateUserProfileResponseImpl(
      {@JsonKey(name: 'success') required this.success,
      @JsonKey(name: 'updated') required final List<String> updated,
      @JsonKey(name: 'message') required this.message,
      @JsonKey(name: 'errors') final List<String>? errors})
      : _updated = updated,
        _errors = errors;

  factory _$UpdateUserProfileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateUserProfileResponseImplFromJson(json);

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
  final List<String>? _errors;
  @override
  @JsonKey(name: 'errors')
  List<String>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UpdateUserProfileResponse(success: $success, updated: $updated, message: $message, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserProfileResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._updated, _updated) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      const DeepCollectionEquality().hash(_updated),
      message,
      const DeepCollectionEquality().hash(_errors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserProfileResponseImplCopyWith<_$UpdateUserProfileResponseImpl>
      get copyWith => __$$UpdateUserProfileResponseImplCopyWithImpl<
          _$UpdateUserProfileResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserProfileResponseImplToJson(
      this,
    );
  }
}

abstract class _UpdateUserProfileResponse implements UpdateUserProfileResponse {
  const factory _UpdateUserProfileResponse(
          {@JsonKey(name: 'success') required final bool success,
          @JsonKey(name: 'updated') required final List<String> updated,
          @JsonKey(name: 'message') required final String message,
          @JsonKey(name: 'errors') final List<String>? errors}) =
      _$UpdateUserProfileResponseImpl;

  factory _UpdateUserProfileResponse.fromJson(Map<String, dynamic> json) =
      _$UpdateUserProfileResponseImpl.fromJson;

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
  @JsonKey(name: 'errors')
  List<String>? get errors;
  @override
  @JsonKey(ignore: true)
  _$$UpdateUserProfileResponseImplCopyWith<_$UpdateUserProfileResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
