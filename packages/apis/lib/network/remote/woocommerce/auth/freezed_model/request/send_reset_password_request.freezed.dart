// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_reset_password_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SendResetPasswordRequest _$SendResetPasswordRequestFromJson(
    Map<String, dynamic> json) {
  return _SendResetPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$SendResetPasswordRequest {
  @JsonKey(name: "email")
  String get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SendResetPasswordRequestCopyWith<SendResetPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendResetPasswordRequestCopyWith<$Res> {
  factory $SendResetPasswordRequestCopyWith(SendResetPasswordRequest value,
          $Res Function(SendResetPasswordRequest) then) =
      _$SendResetPasswordRequestCopyWithImpl<$Res, SendResetPasswordRequest>;
  @useResult
  $Res call({@JsonKey(name: "email") String email});
}

/// @nodoc
class _$SendResetPasswordRequestCopyWithImpl<$Res,
        $Val extends SendResetPasswordRequest>
    implements $SendResetPasswordRequestCopyWith<$Res> {
  _$SendResetPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendResetPasswordRequestImplCopyWith<$Res>
    implements $SendResetPasswordRequestCopyWith<$Res> {
  factory _$$SendResetPasswordRequestImplCopyWith(
          _$SendResetPasswordRequestImpl value,
          $Res Function(_$SendResetPasswordRequestImpl) then) =
      __$$SendResetPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: "email") String email});
}

/// @nodoc
class __$$SendResetPasswordRequestImplCopyWithImpl<$Res>
    extends _$SendResetPasswordRequestCopyWithImpl<$Res,
        _$SendResetPasswordRequestImpl>
    implements _$$SendResetPasswordRequestImplCopyWith<$Res> {
  __$$SendResetPasswordRequestImplCopyWithImpl(
      _$SendResetPasswordRequestImpl _value,
      $Res Function(_$SendResetPasswordRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$SendResetPasswordRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendResetPasswordRequestImpl implements _SendResetPasswordRequest {
  const _$SendResetPasswordRequestImpl(
      {@JsonKey(name: "email") required this.email});

  factory _$SendResetPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendResetPasswordRequestImplFromJson(json);

  @override
  @JsonKey(name: "email")
  final String email;

  @override
  String toString() {
    return 'SendResetPasswordRequest(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendResetPasswordRequestImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SendResetPasswordRequestImplCopyWith<_$SendResetPasswordRequestImpl>
      get copyWith => __$$SendResetPasswordRequestImplCopyWithImpl<
          _$SendResetPasswordRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendResetPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _SendResetPasswordRequest implements SendResetPasswordRequest {
  const factory _SendResetPasswordRequest(
          {@JsonKey(name: "email") required final String email}) =
      _$SendResetPasswordRequestImpl;

  factory _SendResetPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$SendResetPasswordRequestImpl.fromJson;

  @override
  @JsonKey(name: "email")
  String get email;
  @override
  @JsonKey(ignore: true)
  _$$SendResetPasswordRequestImplCopyWith<_$SendResetPasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
