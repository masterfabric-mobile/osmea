// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_user_metadata_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeleteUserMetadataResponse _$DeleteUserMetadataResponseFromJson(
    Map<String, dynamic> json) {
  return _DeleteUserMetadataResponse.fromJson(json);
}

/// @nodoc
mixin _$DeleteUserMetadataResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeleteUserMetadataResponseCopyWith<DeleteUserMetadataResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteUserMetadataResponseCopyWith<$Res> {
  factory $DeleteUserMetadataResponseCopyWith(DeleteUserMetadataResponse value,
          $Res Function(DeleteUserMetadataResponse) then) =
      _$DeleteUserMetadataResponseCopyWithImpl<$Res,
          DeleteUserMetadataResponse>;
  @useResult
  $Res call({bool success, String? message});
}

/// @nodoc
class _$DeleteUserMetadataResponseCopyWithImpl<$Res,
        $Val extends DeleteUserMetadataResponse>
    implements $DeleteUserMetadataResponseCopyWith<$Res> {
  _$DeleteUserMetadataResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeleteUserMetadataResponseImplCopyWith<$Res>
    implements $DeleteUserMetadataResponseCopyWith<$Res> {
  factory _$$DeleteUserMetadataResponseImplCopyWith(
          _$DeleteUserMetadataResponseImpl value,
          $Res Function(_$DeleteUserMetadataResponseImpl) then) =
      __$$DeleteUserMetadataResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? message});
}

/// @nodoc
class __$$DeleteUserMetadataResponseImplCopyWithImpl<$Res>
    extends _$DeleteUserMetadataResponseCopyWithImpl<$Res,
        _$DeleteUserMetadataResponseImpl>
    implements _$$DeleteUserMetadataResponseImplCopyWith<$Res> {
  __$$DeleteUserMetadataResponseImplCopyWithImpl(
      _$DeleteUserMetadataResponseImpl _value,
      $Res Function(_$DeleteUserMetadataResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_$DeleteUserMetadataResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeleteUserMetadataResponseImpl implements _DeleteUserMetadataResponse {
  const _$DeleteUserMetadataResponseImpl({required this.success, this.message});

  factory _$DeleteUserMetadataResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$DeleteUserMetadataResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? message;

  @override
  String toString() {
    return 'DeleteUserMetadataResponse(success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteUserMetadataResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteUserMetadataResponseImplCopyWith<_$DeleteUserMetadataResponseImpl>
      get copyWith => __$$DeleteUserMetadataResponseImplCopyWithImpl<
          _$DeleteUserMetadataResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeleteUserMetadataResponseImplToJson(
      this,
    );
  }
}

abstract class _DeleteUserMetadataResponse
    implements DeleteUserMetadataResponse {
  const factory _DeleteUserMetadataResponse(
      {required final bool success,
      final String? message}) = _$DeleteUserMetadataResponseImpl;

  factory _DeleteUserMetadataResponse.fromJson(Map<String, dynamic> json) =
      _$DeleteUserMetadataResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$DeleteUserMetadataResponseImplCopyWith<_$DeleteUserMetadataResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
