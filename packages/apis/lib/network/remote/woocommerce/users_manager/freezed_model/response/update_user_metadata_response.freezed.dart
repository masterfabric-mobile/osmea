// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_metadata_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateUserMetadataResponse _$UpdateUserMetadataResponseFromJson(
    Map<String, dynamic> json) {
  return _UpdateUserMetadataResponse.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserMetadataResponse {
  bool get success => throw _privateConstructorUsedError;
  List<String> get updated => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  List<String>? get errors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateUserMetadataResponseCopyWith<UpdateUserMetadataResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserMetadataResponseCopyWith<$Res> {
  factory $UpdateUserMetadataResponseCopyWith(UpdateUserMetadataResponse value,
          $Res Function(UpdateUserMetadataResponse) then) =
      _$UpdateUserMetadataResponseCopyWithImpl<$Res,
          UpdateUserMetadataResponse>;
  @useResult
  $Res call(
      {bool success,
      List<String> updated,
      String? message,
      List<String>? errors});
}

/// @nodoc
class _$UpdateUserMetadataResponseCopyWithImpl<$Res,
        $Val extends UpdateUserMetadataResponse>
    implements $UpdateUserMetadataResponseCopyWith<$Res> {
  _$UpdateUserMetadataResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? updated = null,
    Object? message = freezed,
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
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateUserMetadataResponseImplCopyWith<$Res>
    implements $UpdateUserMetadataResponseCopyWith<$Res> {
  factory _$$UpdateUserMetadataResponseImplCopyWith(
          _$UpdateUserMetadataResponseImpl value,
          $Res Function(_$UpdateUserMetadataResponseImpl) then) =
      __$$UpdateUserMetadataResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      List<String> updated,
      String? message,
      List<String>? errors});
}

/// @nodoc
class __$$UpdateUserMetadataResponseImplCopyWithImpl<$Res>
    extends _$UpdateUserMetadataResponseCopyWithImpl<$Res,
        _$UpdateUserMetadataResponseImpl>
    implements _$$UpdateUserMetadataResponseImplCopyWith<$Res> {
  __$$UpdateUserMetadataResponseImplCopyWithImpl(
      _$UpdateUserMetadataResponseImpl _value,
      $Res Function(_$UpdateUserMetadataResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? updated = null,
    Object? message = freezed,
    Object? errors = freezed,
  }) {
    return _then(_$UpdateUserMetadataResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      updated: null == updated
          ? _value._updated
          : updated // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserMetadataResponseImpl implements _UpdateUserMetadataResponse {
  const _$UpdateUserMetadataResponseImpl(
      {required this.success,
      required final List<String> updated,
      this.message,
      final List<String>? errors})
      : _updated = updated,
        _errors = errors;

  factory _$UpdateUserMetadataResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateUserMetadataResponseImplFromJson(json);

  @override
  final bool success;
  final List<String> _updated;
  @override
  List<String> get updated {
    if (_updated is EqualUnmodifiableListView) return _updated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updated);
  }

  @override
  final String? message;
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
    return 'UpdateUserMetadataResponse(success: $success, updated: $updated, message: $message, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserMetadataResponseImpl &&
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
  _$$UpdateUserMetadataResponseImplCopyWith<_$UpdateUserMetadataResponseImpl>
      get copyWith => __$$UpdateUserMetadataResponseImplCopyWithImpl<
          _$UpdateUserMetadataResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserMetadataResponseImplToJson(
      this,
    );
  }
}

abstract class _UpdateUserMetadataResponse
    implements UpdateUserMetadataResponse {
  const factory _UpdateUserMetadataResponse(
      {required final bool success,
      required final List<String> updated,
      final String? message,
      final List<String>? errors}) = _$UpdateUserMetadataResponseImpl;

  factory _UpdateUserMetadataResponse.fromJson(Map<String, dynamic> json) =
      _$UpdateUserMetadataResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<String> get updated;
  @override
  String? get message;
  @override
  List<String>? get errors;
  @override
  @JsonKey(ignore: true)
  _$$UpdateUserMetadataResponseImplCopyWith<_$UpdateUserMetadataResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
