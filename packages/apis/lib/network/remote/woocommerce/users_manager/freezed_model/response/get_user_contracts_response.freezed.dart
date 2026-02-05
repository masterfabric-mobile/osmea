// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_contracts_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserContractsResponse _$GetUserContractsResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserContractsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserContractsResponse {
  @JsonKey(name: 'contracts')
  List<UserContractDetail> get contracts => throw _privateConstructorUsedError;
  @JsonKey(name: 'pagination')
  PaginationInfo get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserContractsResponseCopyWith<GetUserContractsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserContractsResponseCopyWith<$Res> {
  factory $GetUserContractsResponseCopyWith(GetUserContractsResponse value,
          $Res Function(GetUserContractsResponse) then) =
      _$GetUserContractsResponseCopyWithImpl<$Res, GetUserContractsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'contracts') List<UserContractDetail> contracts,
      @JsonKey(name: 'pagination') PaginationInfo pagination});

  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$GetUserContractsResponseCopyWithImpl<$Res,
        $Val extends GetUserContractsResponse>
    implements $GetUserContractsResponseCopyWith<$Res> {
  _$GetUserContractsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contracts = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      contracts: null == contracts
          ? _value.contracts
          : contracts // ignore: cast_nullable_to_non_nullable
              as List<UserContractDetail>,
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
abstract class _$$GetUserContractsResponseImplCopyWith<$Res>
    implements $GetUserContractsResponseCopyWith<$Res> {
  factory _$$GetUserContractsResponseImplCopyWith(
          _$GetUserContractsResponseImpl value,
          $Res Function(_$GetUserContractsResponseImpl) then) =
      __$$GetUserContractsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'contracts') List<UserContractDetail> contracts,
      @JsonKey(name: 'pagination') PaginationInfo pagination});

  @override
  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$GetUserContractsResponseImplCopyWithImpl<$Res>
    extends _$GetUserContractsResponseCopyWithImpl<$Res,
        _$GetUserContractsResponseImpl>
    implements _$$GetUserContractsResponseImplCopyWith<$Res> {
  __$$GetUserContractsResponseImplCopyWithImpl(
      _$GetUserContractsResponseImpl _value,
      $Res Function(_$GetUserContractsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contracts = null,
    Object? pagination = null,
  }) {
    return _then(_$GetUserContractsResponseImpl(
      contracts: null == contracts
          ? _value._contracts
          : contracts // ignore: cast_nullable_to_non_nullable
              as List<UserContractDetail>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserContractsResponseImpl implements _GetUserContractsResponse {
  const _$GetUserContractsResponseImpl(
      {@JsonKey(name: 'contracts')
      required final List<UserContractDetail> contracts,
      @JsonKey(name: 'pagination') required this.pagination})
      : _contracts = contracts;

  factory _$GetUserContractsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserContractsResponseImplFromJson(json);

  final List<UserContractDetail> _contracts;
  @override
  @JsonKey(name: 'contracts')
  List<UserContractDetail> get contracts {
    if (_contracts is EqualUnmodifiableListView) return _contracts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contracts);
  }

  @override
  @JsonKey(name: 'pagination')
  final PaginationInfo pagination;

  @override
  String toString() {
    return 'GetUserContractsResponse(contracts: $contracts, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserContractsResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._contracts, _contracts) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_contracts), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserContractsResponseImplCopyWith<_$GetUserContractsResponseImpl>
      get copyWith => __$$GetUserContractsResponseImplCopyWithImpl<
          _$GetUserContractsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserContractsResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserContractsResponse implements GetUserContractsResponse {
  const factory _GetUserContractsResponse(
          {@JsonKey(name: 'contracts')
          required final List<UserContractDetail> contracts,
          @JsonKey(name: 'pagination')
          required final PaginationInfo pagination}) =
      _$GetUserContractsResponseImpl;

  factory _GetUserContractsResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserContractsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'contracts')
  List<UserContractDetail> get contracts;
  @override
  @JsonKey(name: 'pagination')
  PaginationInfo get pagination;
  @override
  @JsonKey(ignore: true)
  _$$GetUserContractsResponseImplCopyWith<_$GetUserContractsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserContractDetail _$UserContractDetailFromJson(Map<String, dynamic> json) {
  return _UserContractDetail.fromJson(json);
}

/// @nodoc
mixin _$UserContractDetail {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_type')
  String get contractType => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_title')
  String get contractTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_content')
  String? get contractContent => throw _privateConstructorUsedError;
  @JsonKey(name: 'signature_data')
  Map<String, dynamic>? get signatureData => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_address')
  String? get ipAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_agent')
  String? get userAgent => throw _privateConstructorUsedError;
  @JsonKey(name: 'signed_at')
  String get signedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserContractDetailCopyWith<UserContractDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserContractDetailCopyWith<$Res> {
  factory $UserContractDetailCopyWith(
          UserContractDetail value, $Res Function(UserContractDetail) then) =
      _$UserContractDetailCopyWithImpl<$Res, UserContractDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'contract_type') String contractType,
      @JsonKey(name: 'contract_title') String contractTitle,
      @JsonKey(name: 'contract_content') String? contractContent,
      @JsonKey(name: 'signature_data') Map<String, dynamic>? signatureData,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'signed_at') String signedAt});
}

/// @nodoc
class _$UserContractDetailCopyWithImpl<$Res, $Val extends UserContractDetail>
    implements $UserContractDetailCopyWith<$Res> {
  _$UserContractDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contractType = null,
    Object? contractTitle = null,
    Object? contractContent = freezed,
    Object? signatureData = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? signedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      contractType: null == contractType
          ? _value.contractType
          : contractType // ignore: cast_nullable_to_non_nullable
              as String,
      contractTitle: null == contractTitle
          ? _value.contractTitle
          : contractTitle // ignore: cast_nullable_to_non_nullable
              as String,
      contractContent: freezed == contractContent
          ? _value.contractContent
          : contractContent // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureData: freezed == signatureData
          ? _value.signatureData
          : signatureData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      signedAt: null == signedAt
          ? _value.signedAt
          : signedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserContractDetailImplCopyWith<$Res>
    implements $UserContractDetailCopyWith<$Res> {
  factory _$$UserContractDetailImplCopyWith(_$UserContractDetailImpl value,
          $Res Function(_$UserContractDetailImpl) then) =
      __$$UserContractDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'contract_type') String contractType,
      @JsonKey(name: 'contract_title') String contractTitle,
      @JsonKey(name: 'contract_content') String? contractContent,
      @JsonKey(name: 'signature_data') Map<String, dynamic>? signatureData,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'signed_at') String signedAt});
}

/// @nodoc
class __$$UserContractDetailImplCopyWithImpl<$Res>
    extends _$UserContractDetailCopyWithImpl<$Res, _$UserContractDetailImpl>
    implements _$$UserContractDetailImplCopyWith<$Res> {
  __$$UserContractDetailImplCopyWithImpl(_$UserContractDetailImpl _value,
      $Res Function(_$UserContractDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contractType = null,
    Object? contractTitle = null,
    Object? contractContent = freezed,
    Object? signatureData = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? signedAt = null,
  }) {
    return _then(_$UserContractDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      contractType: null == contractType
          ? _value.contractType
          : contractType // ignore: cast_nullable_to_non_nullable
              as String,
      contractTitle: null == contractTitle
          ? _value.contractTitle
          : contractTitle // ignore: cast_nullable_to_non_nullable
              as String,
      contractContent: freezed == contractContent
          ? _value.contractContent
          : contractContent // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureData: freezed == signatureData
          ? _value._signatureData
          : signatureData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      signedAt: null == signedAt
          ? _value.signedAt
          : signedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserContractDetailImpl implements _UserContractDetail {
  const _$UserContractDetailImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'contract_type') required this.contractType,
      @JsonKey(name: 'contract_title') required this.contractTitle,
      @JsonKey(name: 'contract_content') this.contractContent,
      @JsonKey(name: 'signature_data')
      final Map<String, dynamic>? signatureData,
      @JsonKey(name: 'ip_address') this.ipAddress,
      @JsonKey(name: 'user_agent') this.userAgent,
      @JsonKey(name: 'signed_at') required this.signedAt})
      : _signatureData = signatureData;

  factory _$UserContractDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserContractDetailImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'contract_type')
  final String contractType;
  @override
  @JsonKey(name: 'contract_title')
  final String contractTitle;
  @override
  @JsonKey(name: 'contract_content')
  final String? contractContent;
  final Map<String, dynamic>? _signatureData;
  @override
  @JsonKey(name: 'signature_data')
  Map<String, dynamic>? get signatureData {
    final value = _signatureData;
    if (value == null) return null;
    if (_signatureData is EqualUnmodifiableMapView) return _signatureData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'ip_address')
  final String? ipAddress;
  @override
  @JsonKey(name: 'user_agent')
  final String? userAgent;
  @override
  @JsonKey(name: 'signed_at')
  final String signedAt;

  @override
  String toString() {
    return 'UserContractDetail(id: $id, contractType: $contractType, contractTitle: $contractTitle, contractContent: $contractContent, signatureData: $signatureData, ipAddress: $ipAddress, userAgent: $userAgent, signedAt: $signedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserContractDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.contractType, contractType) ||
                other.contractType == contractType) &&
            (identical(other.contractTitle, contractTitle) ||
                other.contractTitle == contractTitle) &&
            (identical(other.contractContent, contractContent) ||
                other.contractContent == contractContent) &&
            const DeepCollectionEquality()
                .equals(other._signatureData, _signatureData) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.signedAt, signedAt) ||
                other.signedAt == signedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      contractType,
      contractTitle,
      contractContent,
      const DeepCollectionEquality().hash(_signatureData),
      ipAddress,
      userAgent,
      signedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserContractDetailImplCopyWith<_$UserContractDetailImpl> get copyWith =>
      __$$UserContractDetailImplCopyWithImpl<_$UserContractDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserContractDetailImplToJson(
      this,
    );
  }
}

abstract class _UserContractDetail implements UserContractDetail {
  const factory _UserContractDetail(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'contract_type') required final String contractType,
          @JsonKey(name: 'contract_title') required final String contractTitle,
          @JsonKey(name: 'contract_content') final String? contractContent,
          @JsonKey(name: 'signature_data')
          final Map<String, dynamic>? signatureData,
          @JsonKey(name: 'ip_address') final String? ipAddress,
          @JsonKey(name: 'user_agent') final String? userAgent,
          @JsonKey(name: 'signed_at') required final String signedAt}) =
      _$UserContractDetailImpl;

  factory _UserContractDetail.fromJson(Map<String, dynamic> json) =
      _$UserContractDetailImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'contract_type')
  String get contractType;
  @override
  @JsonKey(name: 'contract_title')
  String get contractTitle;
  @override
  @JsonKey(name: 'contract_content')
  String? get contractContent;
  @override
  @JsonKey(name: 'signature_data')
  Map<String, dynamic>? get signatureData;
  @override
  @JsonKey(name: 'ip_address')
  String? get ipAddress;
  @override
  @JsonKey(name: 'user_agent')
  String? get userAgent;
  @override
  @JsonKey(name: 'signed_at')
  String get signedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserContractDetailImplCopyWith<_$UserContractDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateContractSignatureResponse _$CreateContractSignatureResponseFromJson(
    Map<String, dynamic> json) {
  return _CreateContractSignatureResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateContractSignatureResponse {
  @JsonKey(name: 'success')
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_id')
  int get contractId => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateContractSignatureResponseCopyWith<CreateContractSignatureResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateContractSignatureResponseCopyWith<$Res> {
  factory $CreateContractSignatureResponseCopyWith(
          CreateContractSignatureResponse value,
          $Res Function(CreateContractSignatureResponse) then) =
      _$CreateContractSignatureResponseCopyWithImpl<$Res,
          CreateContractSignatureResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'contract_id') int contractId,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class _$CreateContractSignatureResponseCopyWithImpl<$Res,
        $Val extends CreateContractSignatureResponse>
    implements $CreateContractSignatureResponseCopyWith<$Res> {
  _$CreateContractSignatureResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? contractId = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateContractSignatureResponseImplCopyWith<$Res>
    implements $CreateContractSignatureResponseCopyWith<$Res> {
  factory _$$CreateContractSignatureResponseImplCopyWith(
          _$CreateContractSignatureResponseImpl value,
          $Res Function(_$CreateContractSignatureResponseImpl) then) =
      __$$CreateContractSignatureResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'success') bool success,
      @JsonKey(name: 'contract_id') int contractId,
      @JsonKey(name: 'message') String message});
}

/// @nodoc
class __$$CreateContractSignatureResponseImplCopyWithImpl<$Res>
    extends _$CreateContractSignatureResponseCopyWithImpl<$Res,
        _$CreateContractSignatureResponseImpl>
    implements _$$CreateContractSignatureResponseImplCopyWith<$Res> {
  __$$CreateContractSignatureResponseImplCopyWithImpl(
      _$CreateContractSignatureResponseImpl _value,
      $Res Function(_$CreateContractSignatureResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? contractId = null,
    Object? message = null,
  }) {
    return _then(_$CreateContractSignatureResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
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
class _$CreateContractSignatureResponseImpl
    implements _CreateContractSignatureResponse {
  const _$CreateContractSignatureResponseImpl(
      {@JsonKey(name: 'success') required this.success,
      @JsonKey(name: 'contract_id') required this.contractId,
      @JsonKey(name: 'message') required this.message});

  factory _$CreateContractSignatureResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateContractSignatureResponseImplFromJson(json);

  @override
  @JsonKey(name: 'success')
  final bool success;
  @override
  @JsonKey(name: 'contract_id')
  final int contractId;
  @override
  @JsonKey(name: 'message')
  final String message;

  @override
  String toString() {
    return 'CreateContractSignatureResponse(success: $success, contractId: $contractId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateContractSignatureResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, contractId, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateContractSignatureResponseImplCopyWith<
          _$CreateContractSignatureResponseImpl>
      get copyWith => __$$CreateContractSignatureResponseImplCopyWithImpl<
          _$CreateContractSignatureResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateContractSignatureResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateContractSignatureResponse
    implements CreateContractSignatureResponse {
  const factory _CreateContractSignatureResponse(
          {@JsonKey(name: 'success') required final bool success,
          @JsonKey(name: 'contract_id') required final int contractId,
          @JsonKey(name: 'message') required final String message}) =
      _$CreateContractSignatureResponseImpl;

  factory _CreateContractSignatureResponse.fromJson(Map<String, dynamic> json) =
      _$CreateContractSignatureResponseImpl.fromJson;

  @override
  @JsonKey(name: 'success')
  bool get success;
  @override
  @JsonKey(name: 'contract_id')
  int get contractId;
  @override
  @JsonKey(name: 'message')
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$CreateContractSignatureResponseImplCopyWith<
          _$CreateContractSignatureResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
