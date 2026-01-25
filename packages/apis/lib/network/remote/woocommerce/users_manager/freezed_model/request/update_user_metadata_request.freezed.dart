// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_metadata_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateUserMetadataRequest _$UpdateUserMetadataRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateUserMetadataRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserMetadataRequest {
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateUserMetadataRequestCopyWith<UpdateUserMetadataRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserMetadataRequestCopyWith<$Res> {
  factory $UpdateUserMetadataRequestCopyWith(UpdateUserMetadataRequest value,
          $Res Function(UpdateUserMetadataRequest) then) =
      _$UpdateUserMetadataRequestCopyWithImpl<$Res, UpdateUserMetadataRequest>;
  @useResult
  $Res call({Map<String, dynamic> metadata});
}

/// @nodoc
class _$UpdateUserMetadataRequestCopyWithImpl<$Res,
        $Val extends UpdateUserMetadataRequest>
    implements $UpdateUserMetadataRequestCopyWith<$Res> {
  _$UpdateUserMetadataRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateUserMetadataRequestImplCopyWith<$Res>
    implements $UpdateUserMetadataRequestCopyWith<$Res> {
  factory _$$UpdateUserMetadataRequestImplCopyWith(
          _$UpdateUserMetadataRequestImpl value,
          $Res Function(_$UpdateUserMetadataRequestImpl) then) =
      __$$UpdateUserMetadataRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic> metadata});
}

/// @nodoc
class __$$UpdateUserMetadataRequestImplCopyWithImpl<$Res>
    extends _$UpdateUserMetadataRequestCopyWithImpl<$Res,
        _$UpdateUserMetadataRequestImpl>
    implements _$$UpdateUserMetadataRequestImplCopyWith<$Res> {
  __$$UpdateUserMetadataRequestImplCopyWithImpl(
      _$UpdateUserMetadataRequestImpl _value,
      $Res Function(_$UpdateUserMetadataRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
  }) {
    return _then(_$UpdateUserMetadataRequestImpl(
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserMetadataRequestImpl implements _UpdateUserMetadataRequest {
  const _$UpdateUserMetadataRequestImpl(
      {required final Map<String, dynamic> metadata})
      : _metadata = metadata;

  factory _$UpdateUserMetadataRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateUserMetadataRequestImplFromJson(json);

  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'UpdateUserMetadataRequest(metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserMetadataRequestImpl &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserMetadataRequestImplCopyWith<_$UpdateUserMetadataRequestImpl>
      get copyWith => __$$UpdateUserMetadataRequestImplCopyWithImpl<
          _$UpdateUserMetadataRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserMetadataRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateUserMetadataRequest implements UpdateUserMetadataRequest {
  const factory _UpdateUserMetadataRequest(
          {required final Map<String, dynamic> metadata}) =
      _$UpdateUserMetadataRequestImpl;

  factory _UpdateUserMetadataRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateUserMetadataRequestImpl.fromJson;

  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UpdateUserMetadataRequestImplCopyWith<_$UpdateUserMetadataRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
