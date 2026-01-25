// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_contract_signature_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateContractSignatureRequest _$CreateContractSignatureRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateContractSignatureRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateContractSignatureRequest {
  @JsonKey(name: 'contract_type')
  String get contractType => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_title')
  String get contractTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_content')
  String? get contractContent => throw _privateConstructorUsedError;
  @JsonKey(name: 'signature_data')
  Map<String, dynamic> get signatureData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateContractSignatureRequestCopyWith<CreateContractSignatureRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateContractSignatureRequestCopyWith<$Res> {
  factory $CreateContractSignatureRequestCopyWith(
          CreateContractSignatureRequest value,
          $Res Function(CreateContractSignatureRequest) then) =
      _$CreateContractSignatureRequestCopyWithImpl<$Res,
          CreateContractSignatureRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'contract_type') String contractType,
      @JsonKey(name: 'contract_title') String contractTitle,
      @JsonKey(name: 'contract_content') String? contractContent,
      @JsonKey(name: 'signature_data') Map<String, dynamic> signatureData});
}

/// @nodoc
class _$CreateContractSignatureRequestCopyWithImpl<$Res,
        $Val extends CreateContractSignatureRequest>
    implements $CreateContractSignatureRequestCopyWith<$Res> {
  _$CreateContractSignatureRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractType = null,
    Object? contractTitle = null,
    Object? contractContent = freezed,
    Object? signatureData = null,
  }) {
    return _then(_value.copyWith(
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
      signatureData: null == signatureData
          ? _value.signatureData
          : signatureData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateContractSignatureRequestImplCopyWith<$Res>
    implements $CreateContractSignatureRequestCopyWith<$Res> {
  factory _$$CreateContractSignatureRequestImplCopyWith(
          _$CreateContractSignatureRequestImpl value,
          $Res Function(_$CreateContractSignatureRequestImpl) then) =
      __$$CreateContractSignatureRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'contract_type') String contractType,
      @JsonKey(name: 'contract_title') String contractTitle,
      @JsonKey(name: 'contract_content') String? contractContent,
      @JsonKey(name: 'signature_data') Map<String, dynamic> signatureData});
}

/// @nodoc
class __$$CreateContractSignatureRequestImplCopyWithImpl<$Res>
    extends _$CreateContractSignatureRequestCopyWithImpl<$Res,
        _$CreateContractSignatureRequestImpl>
    implements _$$CreateContractSignatureRequestImplCopyWith<$Res> {
  __$$CreateContractSignatureRequestImplCopyWithImpl(
      _$CreateContractSignatureRequestImpl _value,
      $Res Function(_$CreateContractSignatureRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractType = null,
    Object? contractTitle = null,
    Object? contractContent = freezed,
    Object? signatureData = null,
  }) {
    return _then(_$CreateContractSignatureRequestImpl(
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
      signatureData: null == signatureData
          ? _value._signatureData
          : signatureData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateContractSignatureRequestImpl
    implements _CreateContractSignatureRequest {
  const _$CreateContractSignatureRequestImpl(
      {@JsonKey(name: 'contract_type') required this.contractType,
      @JsonKey(name: 'contract_title') required this.contractTitle,
      @JsonKey(name: 'contract_content') this.contractContent,
      @JsonKey(name: 'signature_data')
      required final Map<String, dynamic> signatureData})
      : _signatureData = signatureData;

  factory _$CreateContractSignatureRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateContractSignatureRequestImplFromJson(json);

  @override
  @JsonKey(name: 'contract_type')
  final String contractType;
  @override
  @JsonKey(name: 'contract_title')
  final String contractTitle;
  @override
  @JsonKey(name: 'contract_content')
  final String? contractContent;
  final Map<String, dynamic> _signatureData;
  @override
  @JsonKey(name: 'signature_data')
  Map<String, dynamic> get signatureData {
    if (_signatureData is EqualUnmodifiableMapView) return _signatureData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_signatureData);
  }

  @override
  String toString() {
    return 'CreateContractSignatureRequest(contractType: $contractType, contractTitle: $contractTitle, contractContent: $contractContent, signatureData: $signatureData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateContractSignatureRequestImpl &&
            (identical(other.contractType, contractType) ||
                other.contractType == contractType) &&
            (identical(other.contractTitle, contractTitle) ||
                other.contractTitle == contractTitle) &&
            (identical(other.contractContent, contractContent) ||
                other.contractContent == contractContent) &&
            const DeepCollectionEquality()
                .equals(other._signatureData, _signatureData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, contractType, contractTitle,
      contractContent, const DeepCollectionEquality().hash(_signatureData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateContractSignatureRequestImplCopyWith<
          _$CreateContractSignatureRequestImpl>
      get copyWith => __$$CreateContractSignatureRequestImplCopyWithImpl<
          _$CreateContractSignatureRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateContractSignatureRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateContractSignatureRequest
    implements CreateContractSignatureRequest {
  const factory _CreateContractSignatureRequest(
          {@JsonKey(name: 'contract_type') required final String contractType,
          @JsonKey(name: 'contract_title') required final String contractTitle,
          @JsonKey(name: 'contract_content') final String? contractContent,
          @JsonKey(name: 'signature_data')
          required final Map<String, dynamic> signatureData}) =
      _$CreateContractSignatureRequestImpl;

  factory _CreateContractSignatureRequest.fromJson(Map<String, dynamic> json) =
      _$CreateContractSignatureRequestImpl.fromJson;

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
  Map<String, dynamic> get signatureData;
  @override
  @JsonKey(ignore: true)
  _$$CreateContractSignatureRequestImplCopyWith<
          _$CreateContractSignatureRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
