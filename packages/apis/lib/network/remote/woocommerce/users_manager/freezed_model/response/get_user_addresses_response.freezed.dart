// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_addresses_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserAddressesResponse _$GetUserAddressesResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserAddressesResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserAddressesResponse {
  @JsonKey(name: 'addresses')
  List<UserAddress> get addresses => throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  int get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserAddressesResponseCopyWith<GetUserAddressesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserAddressesResponseCopyWith<$Res> {
  factory $GetUserAddressesResponseCopyWith(GetUserAddressesResponse value,
          $Res Function(GetUserAddressesResponse) then) =
      _$GetUserAddressesResponseCopyWithImpl<$Res, GetUserAddressesResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'addresses') List<UserAddress> addresses,
      @JsonKey(name: 'count') int count});
}

/// @nodoc
class _$GetUserAddressesResponseCopyWithImpl<$Res,
        $Val extends GetUserAddressesResponse>
    implements $GetUserAddressesResponseCopyWith<$Res> {
  _$GetUserAddressesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addresses = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      addresses: null == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<UserAddress>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetUserAddressesResponseImplCopyWith<$Res>
    implements $GetUserAddressesResponseCopyWith<$Res> {
  factory _$$GetUserAddressesResponseImplCopyWith(
          _$GetUserAddressesResponseImpl value,
          $Res Function(_$GetUserAddressesResponseImpl) then) =
      __$$GetUserAddressesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'addresses') List<UserAddress> addresses,
      @JsonKey(name: 'count') int count});
}

/// @nodoc
class __$$GetUserAddressesResponseImplCopyWithImpl<$Res>
    extends _$GetUserAddressesResponseCopyWithImpl<$Res,
        _$GetUserAddressesResponseImpl>
    implements _$$GetUserAddressesResponseImplCopyWith<$Res> {
  __$$GetUserAddressesResponseImplCopyWithImpl(
      _$GetUserAddressesResponseImpl _value,
      $Res Function(_$GetUserAddressesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addresses = null,
    Object? count = null,
  }) {
    return _then(_$GetUserAddressesResponseImpl(
      addresses: null == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<UserAddress>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserAddressesResponseImpl implements _GetUserAddressesResponse {
  const _$GetUserAddressesResponseImpl(
      {@JsonKey(name: 'addresses') required final List<UserAddress> addresses,
      @JsonKey(name: 'count') required this.count})
      : _addresses = addresses;

  factory _$GetUserAddressesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserAddressesResponseImplFromJson(json);

  final List<UserAddress> _addresses;
  @override
  @JsonKey(name: 'addresses')
  List<UserAddress> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  @JsonKey(name: 'count')
  final int count;

  @override
  String toString() {
    return 'GetUserAddressesResponse(addresses: $addresses, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserAddressesResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_addresses), count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserAddressesResponseImplCopyWith<_$GetUserAddressesResponseImpl>
      get copyWith => __$$GetUserAddressesResponseImplCopyWithImpl<
          _$GetUserAddressesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserAddressesResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserAddressesResponse implements GetUserAddressesResponse {
  const factory _GetUserAddressesResponse(
      {@JsonKey(name: 'addresses') required final List<UserAddress> addresses,
      @JsonKey(name: 'count')
      required final int count}) = _$GetUserAddressesResponseImpl;

  factory _GetUserAddressesResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserAddressesResponseImpl.fromJson;

  @override
  @JsonKey(name: 'addresses')
  List<UserAddress> get addresses;
  @override
  @JsonKey(name: 'count')
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$GetUserAddressesResponseImplCopyWith<_$GetUserAddressesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AddressOperationResponse _$AddressOperationResponseFromJson(
    Map<String, dynamic> json) {
  return _AddressOperationResponse.fromJson(json);
}

/// @nodoc
mixin _$AddressOperationResponse {
  @JsonKey(name: 'success')
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_id')
  int? get addressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressOperationResponseCopyWith<AddressOperationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressOperationResponseCopyWith<$Res> {
  factory $AddressOperationResponseCopyWith(AddressOperationResponse value,
          $Res Function(AddressOperationResponse) then) =
      _$AddressOperationResponseCopyWithImpl<$Res, AddressOperationResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'address_id') int? addressId,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class _$AddressOperationResponseCopyWithImpl<$Res,
        $Val extends AddressOperationResponse>
    implements $AddressOperationResponseCopyWith<$Res> {
  _$AddressOperationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? addressId = freezed,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      addressId: freezed == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as int?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressOperationResponseImplCopyWith<$Res>
    implements $AddressOperationResponseCopyWith<$Res> {
  factory _$$AddressOperationResponseImplCopyWith(
          _$AddressOperationResponseImpl value,
          $Res Function(_$AddressOperationResponseImpl) then) =
      __$$AddressOperationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'address_id') int? addressId,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class __$$AddressOperationResponseImplCopyWithImpl<$Res>
    extends _$AddressOperationResponseCopyWithImpl<$Res,
        _$AddressOperationResponseImpl>
    implements _$$AddressOperationResponseImplCopyWith<$Res> {
  __$$AddressOperationResponseImplCopyWithImpl(
      _$AddressOperationResponseImpl _value,
      $Res Function(_$AddressOperationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? addressId = freezed,
    Object? message = null,
  }) {
    return _then(_$AddressOperationResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      addressId: freezed == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as int?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressOperationResponseImpl implements _AddressOperationResponse {
  const _$AddressOperationResponseImpl(
      {@JsonKey(name: 'success') required this.success,
      @JsonKey(name: 'address_id') this.addressId,
      @JsonKey(name: 'message') required this.message});

  factory _$AddressOperationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressOperationResponseImplFromJson(json);

  @override
  @JsonKey(name: 'success')
  final bool success;
  @override
  @JsonKey(name: 'address_id')
  final int? addressId;
  @override
  @JsonKey(name: 'message')
  final String message;

  @override
  String toString() {
    return 'AddressOperationResponse(success: $success, addressId: $addressId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressOperationResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, addressId, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressOperationResponseImplCopyWith<_$AddressOperationResponseImpl>
      get copyWith => __$$AddressOperationResponseImplCopyWithImpl<
          _$AddressOperationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressOperationResponseImplToJson(
      this,
    );
  }
}

abstract class _AddressOperationResponse implements AddressOperationResponse {
  const factory _AddressOperationResponse(
          {@JsonKey(name: 'success') required final bool success,
          @JsonKey(name: 'address_id') final int? addressId,
          @JsonKey(name: 'message') required final String message}) =
      _$AddressOperationResponseImpl;

  factory _AddressOperationResponse.fromJson(Map<String, dynamic> json) =
      _$AddressOperationResponseImpl.fromJson;

  @override
  @JsonKey(name: 'success')
  bool get success;
  @override
  @JsonKey(name: 'address_id')
  int? get addressId;
  @override
  @JsonKey(name: 'message')
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$AddressOperationResponseImplCopyWith<_$AddressOperationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
