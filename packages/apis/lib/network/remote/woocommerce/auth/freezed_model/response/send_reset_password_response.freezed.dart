// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_reset_password_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SendResetPasswordResponse _$SendResetPasswordResponseFromJson(
    Map<String, dynamic> json) {
  return _SendResetPasswordResponse.fromJson(json);
}

/// @nodoc
mixin _$SendResetPasswordResponse {
  @JsonKey(name: "success")
  bool? get success => throw _privateConstructorUsedError;
  @JsonKey(name: "message")
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SendResetPasswordResponseCopyWith<SendResetPasswordResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendResetPasswordResponseCopyWith<$Res> {
  factory $SendResetPasswordResponseCopyWith(SendResetPasswordResponse value,
          $Res Function(SendResetPasswordResponse) then) =
      _$SendResetPasswordResponseCopyWithImpl<$Res, SendResetPasswordResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "success") bool? success,
      @JsonKey(name: "message") String? message});
}

/// @nodoc
class _$SendResetPasswordResponseCopyWithImpl<$Res,
        $Val extends SendResetPasswordResponse>
    implements $SendResetPasswordResponseCopyWith<$Res> {
  _$SendResetPasswordResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendResetPasswordResponseImplCopyWith<$Res>
    implements $SendResetPasswordResponseCopyWith<$Res> {
  factory _$$SendResetPasswordResponseImplCopyWith(
          _$SendResetPasswordResponseImpl value,
          $Res Function(_$SendResetPasswordResponseImpl) then) =
      __$$SendResetPasswordResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "success") bool? success,
      @JsonKey(name: "message") String? message});
}

/// @nodoc
class __$$SendResetPasswordResponseImplCopyWithImpl<$Res>
    extends _$SendResetPasswordResponseCopyWithImpl<$Res,
        _$SendResetPasswordResponseImpl>
    implements _$$SendResetPasswordResponseImplCopyWith<$Res> {
  __$$SendResetPasswordResponseImplCopyWithImpl(
      _$SendResetPasswordResponseImpl _value,
      $Res Function(_$SendResetPasswordResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
  }) {
    return _then(_$SendResetPasswordResponseImpl(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendResetPasswordResponseImpl implements _SendResetPasswordResponse {
  const _$SendResetPasswordResponseImpl(
      {@JsonKey(name: "success") this.success,
      @JsonKey(name: "message") this.message});

  factory _$SendResetPasswordResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendResetPasswordResponseImplFromJson(json);

  @override
  @JsonKey(name: "success")
  final bool? success;
  @override
  @JsonKey(name: "message")
  final String? message;

  @override
  String toString() {
    return 'SendResetPasswordResponse(success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendResetPasswordResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SendResetPasswordResponseImplCopyWith<_$SendResetPasswordResponseImpl>
      get copyWith => __$$SendResetPasswordResponseImplCopyWithImpl<
          _$SendResetPasswordResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendResetPasswordResponseImplToJson(
      this,
    );
  }
}

abstract class _SendResetPasswordResponse implements SendResetPasswordResponse {
  const factory _SendResetPasswordResponse(
          {@JsonKey(name: "success") final bool? success,
          @JsonKey(name: "message") final String? message}) =
      _$SendResetPasswordResponseImpl;

  factory _SendResetPasswordResponse.fromJson(Map<String, dynamic> json) =
      _$SendResetPasswordResponseImpl.fromJson;

  @override
  @JsonKey(name: "success")
  bool? get success;
  @override
  @JsonKey(name: "message")
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$SendResetPasswordResponseImplCopyWith<_$SendResetPasswordResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
