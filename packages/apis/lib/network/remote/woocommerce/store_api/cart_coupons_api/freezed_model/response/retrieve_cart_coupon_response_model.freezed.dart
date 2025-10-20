// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retrieve_cart_coupon_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RetrieveCartCouponResponseModel _$RetrieveCartCouponResponseModelFromJson(
    Map<String, dynamic> json) {
  return _RetrieveCartCouponResponseModel.fromJson(json);
}

/// @nodoc
mixin _$RetrieveCartCouponResponseModel {
  @JsonKey(name: "code")
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: "type")
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: "totals")
  Totals? get totals => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RetrieveCartCouponResponseModelCopyWith<RetrieveCartCouponResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RetrieveCartCouponResponseModelCopyWith<$Res> {
  factory $RetrieveCartCouponResponseModelCopyWith(
          RetrieveCartCouponResponseModel value,
          $Res Function(RetrieveCartCouponResponseModel) then) =
      _$RetrieveCartCouponResponseModelCopyWithImpl<$Res,
          RetrieveCartCouponResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "code") String? code,
      @JsonKey(name: "type") String? type,
      @JsonKey(name: "totals") Totals? totals});

  $TotalsCopyWith<$Res>? get totals;
}

/// @nodoc
class _$RetrieveCartCouponResponseModelCopyWithImpl<$Res,
        $Val extends RetrieveCartCouponResponseModel>
    implements $RetrieveCartCouponResponseModelCopyWith<$Res> {
  _$RetrieveCartCouponResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? type = freezed,
    Object? totals = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      totals: freezed == totals
          ? _value.totals
          : totals // ignore: cast_nullable_to_non_nullable
              as Totals?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TotalsCopyWith<$Res>? get totals {
    if (_value.totals == null) {
      return null;
    }

    return $TotalsCopyWith<$Res>(_value.totals!, (value) {
      return _then(_value.copyWith(totals: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RetrieveCartCouponResponseModelImplCopyWith<$Res>
    implements $RetrieveCartCouponResponseModelCopyWith<$Res> {
  factory _$$RetrieveCartCouponResponseModelImplCopyWith(
          _$RetrieveCartCouponResponseModelImpl value,
          $Res Function(_$RetrieveCartCouponResponseModelImpl) then) =
      __$$RetrieveCartCouponResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "code") String? code,
      @JsonKey(name: "type") String? type,
      @JsonKey(name: "totals") Totals? totals});

  @override
  $TotalsCopyWith<$Res>? get totals;
}

/// @nodoc
class __$$RetrieveCartCouponResponseModelImplCopyWithImpl<$Res>
    extends _$RetrieveCartCouponResponseModelCopyWithImpl<$Res,
        _$RetrieveCartCouponResponseModelImpl>
    implements _$$RetrieveCartCouponResponseModelImplCopyWith<$Res> {
  __$$RetrieveCartCouponResponseModelImplCopyWithImpl(
      _$RetrieveCartCouponResponseModelImpl _value,
      $Res Function(_$RetrieveCartCouponResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? type = freezed,
    Object? totals = freezed,
  }) {
    return _then(_$RetrieveCartCouponResponseModelImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      totals: freezed == totals
          ? _value.totals
          : totals // ignore: cast_nullable_to_non_nullable
              as Totals?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RetrieveCartCouponResponseModelImpl
    implements _RetrieveCartCouponResponseModel {
  const _$RetrieveCartCouponResponseModelImpl(
      {@JsonKey(name: "code") this.code,
      @JsonKey(name: "type") this.type,
      @JsonKey(name: "totals") this.totals});

  factory _$RetrieveCartCouponResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RetrieveCartCouponResponseModelImplFromJson(json);

  @override
  @JsonKey(name: "code")
  final String? code;
  @override
  @JsonKey(name: "type")
  final String? type;
  @override
  @JsonKey(name: "totals")
  final Totals? totals;

  @override
  String toString() {
    return 'RetrieveCartCouponResponseModel(code: $code, type: $type, totals: $totals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetrieveCartCouponResponseModelImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.totals, totals) || other.totals == totals));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, type, totals);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RetrieveCartCouponResponseModelImplCopyWith<
          _$RetrieveCartCouponResponseModelImpl>
      get copyWith => __$$RetrieveCartCouponResponseModelImplCopyWithImpl<
          _$RetrieveCartCouponResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RetrieveCartCouponResponseModelImplToJson(
      this,
    );
  }
}

abstract class _RetrieveCartCouponResponseModel
    implements RetrieveCartCouponResponseModel {
  const factory _RetrieveCartCouponResponseModel(
          {@JsonKey(name: "code") final String? code,
          @JsonKey(name: "type") final String? type,
          @JsonKey(name: "totals") final Totals? totals}) =
      _$RetrieveCartCouponResponseModelImpl;

  factory _RetrieveCartCouponResponseModel.fromJson(Map<String, dynamic> json) =
      _$RetrieveCartCouponResponseModelImpl.fromJson;

  @override
  @JsonKey(name: "code")
  String? get code;
  @override
  @JsonKey(name: "type")
  String? get type;
  @override
  @JsonKey(name: "totals")
  Totals? get totals;
  @override
  @JsonKey(ignore: true)
  _$$RetrieveCartCouponResponseModelImplCopyWith<
          _$RetrieveCartCouponResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Totals _$TotalsFromJson(Map<String, dynamic> json) {
  return _Totals.fromJson(json);
}

/// @nodoc
mixin _$Totals {
  @JsonKey(name: "currency_code")
  String? get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_symbol")
  String? get currencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_minor_unit")
  int? get currencyMinorUnit => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_decimal_separator")
  String? get currencyDecimalSeparator => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_thousand_separator")
  String? get currencyThousandSeparator => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_prefix")
  String? get currencyPrefix => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_suffix")
  String? get currencySuffix => throw _privateConstructorUsedError;
  @JsonKey(name: "total_discount")
  String? get totalDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: "total_discount_tax")
  String? get totalDiscountTax => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TotalsCopyWith<Totals> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TotalsCopyWith<$Res> {
  factory $TotalsCopyWith(Totals value, $Res Function(Totals) then) =
      _$TotalsCopyWithImpl<$Res, Totals>;
  @useResult
  $Res call(
      {@JsonKey(name: "currency_code") String? currencyCode,
      @JsonKey(name: "currency_symbol") String? currencySymbol,
      @JsonKey(name: "currency_minor_unit") int? currencyMinorUnit,
      @JsonKey(name: "currency_decimal_separator")
      String? currencyDecimalSeparator,
      @JsonKey(name: "currency_thousand_separator")
      String? currencyThousandSeparator,
      @JsonKey(name: "currency_prefix") String? currencyPrefix,
      @JsonKey(name: "currency_suffix") String? currencySuffix,
      @JsonKey(name: "total_discount") String? totalDiscount,
      @JsonKey(name: "total_discount_tax") String? totalDiscountTax});
}

/// @nodoc
class _$TotalsCopyWithImpl<$Res, $Val extends Totals>
    implements $TotalsCopyWith<$Res> {
  _$TotalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = freezed,
    Object? currencySymbol = freezed,
    Object? currencyMinorUnit = freezed,
    Object? currencyDecimalSeparator = freezed,
    Object? currencyThousandSeparator = freezed,
    Object? currencyPrefix = freezed,
    Object? currencySuffix = freezed,
    Object? totalDiscount = freezed,
    Object? totalDiscountTax = freezed,
  }) {
    return _then(_value.copyWith(
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyMinorUnit: freezed == currencyMinorUnit
          ? _value.currencyMinorUnit
          : currencyMinorUnit // ignore: cast_nullable_to_non_nullable
              as int?,
      currencyDecimalSeparator: freezed == currencyDecimalSeparator
          ? _value.currencyDecimalSeparator
          : currencyDecimalSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyThousandSeparator: freezed == currencyThousandSeparator
          ? _value.currencyThousandSeparator
          : currencyThousandSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyPrefix: freezed == currencyPrefix
          ? _value.currencyPrefix
          : currencyPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySuffix: freezed == currencySuffix
          ? _value.currencySuffix
          : currencySuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDiscount: freezed == totalDiscount
          ? _value.totalDiscount
          : totalDiscount // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDiscountTax: freezed == totalDiscountTax
          ? _value.totalDiscountTax
          : totalDiscountTax // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TotalsImplCopyWith<$Res> implements $TotalsCopyWith<$Res> {
  factory _$$TotalsImplCopyWith(
          _$TotalsImpl value, $Res Function(_$TotalsImpl) then) =
      __$$TotalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "currency_code") String? currencyCode,
      @JsonKey(name: "currency_symbol") String? currencySymbol,
      @JsonKey(name: "currency_minor_unit") int? currencyMinorUnit,
      @JsonKey(name: "currency_decimal_separator")
      String? currencyDecimalSeparator,
      @JsonKey(name: "currency_thousand_separator")
      String? currencyThousandSeparator,
      @JsonKey(name: "currency_prefix") String? currencyPrefix,
      @JsonKey(name: "currency_suffix") String? currencySuffix,
      @JsonKey(name: "total_discount") String? totalDiscount,
      @JsonKey(name: "total_discount_tax") String? totalDiscountTax});
}

/// @nodoc
class __$$TotalsImplCopyWithImpl<$Res>
    extends _$TotalsCopyWithImpl<$Res, _$TotalsImpl>
    implements _$$TotalsImplCopyWith<$Res> {
  __$$TotalsImplCopyWithImpl(
      _$TotalsImpl _value, $Res Function(_$TotalsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = freezed,
    Object? currencySymbol = freezed,
    Object? currencyMinorUnit = freezed,
    Object? currencyDecimalSeparator = freezed,
    Object? currencyThousandSeparator = freezed,
    Object? currencyPrefix = freezed,
    Object? currencySuffix = freezed,
    Object? totalDiscount = freezed,
    Object? totalDiscountTax = freezed,
  }) {
    return _then(_$TotalsImpl(
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyMinorUnit: freezed == currencyMinorUnit
          ? _value.currencyMinorUnit
          : currencyMinorUnit // ignore: cast_nullable_to_non_nullable
              as int?,
      currencyDecimalSeparator: freezed == currencyDecimalSeparator
          ? _value.currencyDecimalSeparator
          : currencyDecimalSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyThousandSeparator: freezed == currencyThousandSeparator
          ? _value.currencyThousandSeparator
          : currencyThousandSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyPrefix: freezed == currencyPrefix
          ? _value.currencyPrefix
          : currencyPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySuffix: freezed == currencySuffix
          ? _value.currencySuffix
          : currencySuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDiscount: freezed == totalDiscount
          ? _value.totalDiscount
          : totalDiscount // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDiscountTax: freezed == totalDiscountTax
          ? _value.totalDiscountTax
          : totalDiscountTax // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TotalsImpl implements _Totals {
  const _$TotalsImpl(
      {@JsonKey(name: "currency_code") this.currencyCode,
      @JsonKey(name: "currency_symbol") this.currencySymbol,
      @JsonKey(name: "currency_minor_unit") this.currencyMinorUnit,
      @JsonKey(name: "currency_decimal_separator")
      this.currencyDecimalSeparator,
      @JsonKey(name: "currency_thousand_separator")
      this.currencyThousandSeparator,
      @JsonKey(name: "currency_prefix") this.currencyPrefix,
      @JsonKey(name: "currency_suffix") this.currencySuffix,
      @JsonKey(name: "total_discount") this.totalDiscount,
      @JsonKey(name: "total_discount_tax") this.totalDiscountTax});

  factory _$TotalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TotalsImplFromJson(json);

  @override
  @JsonKey(name: "currency_code")
  final String? currencyCode;
  @override
  @JsonKey(name: "currency_symbol")
  final String? currencySymbol;
  @override
  @JsonKey(name: "currency_minor_unit")
  final int? currencyMinorUnit;
  @override
  @JsonKey(name: "currency_decimal_separator")
  final String? currencyDecimalSeparator;
  @override
  @JsonKey(name: "currency_thousand_separator")
  final String? currencyThousandSeparator;
  @override
  @JsonKey(name: "currency_prefix")
  final String? currencyPrefix;
  @override
  @JsonKey(name: "currency_suffix")
  final String? currencySuffix;
  @override
  @JsonKey(name: "total_discount")
  final String? totalDiscount;
  @override
  @JsonKey(name: "total_discount_tax")
  final String? totalDiscountTax;

  @override
  String toString() {
    return 'Totals(currencyCode: $currencyCode, currencySymbol: $currencySymbol, currencyMinorUnit: $currencyMinorUnit, currencyDecimalSeparator: $currencyDecimalSeparator, currencyThousandSeparator: $currencyThousandSeparator, currencyPrefix: $currencyPrefix, currencySuffix: $currencySuffix, totalDiscount: $totalDiscount, totalDiscountTax: $totalDiscountTax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TotalsImpl &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyMinorUnit, currencyMinorUnit) ||
                other.currencyMinorUnit == currencyMinorUnit) &&
            (identical(
                    other.currencyDecimalSeparator, currencyDecimalSeparator) ||
                other.currencyDecimalSeparator == currencyDecimalSeparator) &&
            (identical(other.currencyThousandSeparator,
                    currencyThousandSeparator) ||
                other.currencyThousandSeparator == currencyThousandSeparator) &&
            (identical(other.currencyPrefix, currencyPrefix) ||
                other.currencyPrefix == currencyPrefix) &&
            (identical(other.currencySuffix, currencySuffix) ||
                other.currencySuffix == currencySuffix) &&
            (identical(other.totalDiscount, totalDiscount) ||
                other.totalDiscount == totalDiscount) &&
            (identical(other.totalDiscountTax, totalDiscountTax) ||
                other.totalDiscountTax == totalDiscountTax));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currencyCode,
      currencySymbol,
      currencyMinorUnit,
      currencyDecimalSeparator,
      currencyThousandSeparator,
      currencyPrefix,
      currencySuffix,
      totalDiscount,
      totalDiscountTax);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TotalsImplCopyWith<_$TotalsImpl> get copyWith =>
      __$$TotalsImplCopyWithImpl<_$TotalsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TotalsImplToJson(
      this,
    );
  }
}

abstract class _Totals implements Totals {
  const factory _Totals(
      {@JsonKey(name: "currency_code") final String? currencyCode,
      @JsonKey(name: "currency_symbol") final String? currencySymbol,
      @JsonKey(name: "currency_minor_unit") final int? currencyMinorUnit,
      @JsonKey(name: "currency_decimal_separator")
      final String? currencyDecimalSeparator,
      @JsonKey(name: "currency_thousand_separator")
      final String? currencyThousandSeparator,
      @JsonKey(name: "currency_prefix") final String? currencyPrefix,
      @JsonKey(name: "currency_suffix") final String? currencySuffix,
      @JsonKey(name: "total_discount") final String? totalDiscount,
      @JsonKey(name: "total_discount_tax")
      final String? totalDiscountTax}) = _$TotalsImpl;

  factory _Totals.fromJson(Map<String, dynamic> json) = _$TotalsImpl.fromJson;

  @override
  @JsonKey(name: "currency_code")
  String? get currencyCode;
  @override
  @JsonKey(name: "currency_symbol")
  String? get currencySymbol;
  @override
  @JsonKey(name: "currency_minor_unit")
  int? get currencyMinorUnit;
  @override
  @JsonKey(name: "currency_decimal_separator")
  String? get currencyDecimalSeparator;
  @override
  @JsonKey(name: "currency_thousand_separator")
  String? get currencyThousandSeparator;
  @override
  @JsonKey(name: "currency_prefix")
  String? get currencyPrefix;
  @override
  @JsonKey(name: "currency_suffix")
  String? get currencySuffix;
  @override
  @JsonKey(name: "total_discount")
  String? get totalDiscount;
  @override
  @JsonKey(name: "total_discount_tax")
  String? get totalDiscountTax;
  @override
  @JsonKey(ignore: true)
  _$$TotalsImplCopyWith<_$TotalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
