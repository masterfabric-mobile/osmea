// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_cart_coupon_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RetrieveCartCouponResponseModelImpl
    _$$RetrieveCartCouponResponseModelImplFromJson(Map<String, dynamic> json) =>
        _$RetrieveCartCouponResponseModelImpl(
          code: json['code'] as String?,
          type: json['type'] as String?,
          totals: json['totals'] == null
              ? null
              : Totals.fromJson(json['totals'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$RetrieveCartCouponResponseModelImplToJson(
        _$RetrieveCartCouponResponseModelImpl instance) =>
    <String, dynamic>{
      if (instance.code case final value?) 'code': value,
      if (instance.type case final value?) 'type': value,
      if (instance.totals?.toJson() case final value?) 'totals': value,
    };

_$TotalsImpl _$$TotalsImplFromJson(Map<String, dynamic> json) => _$TotalsImpl(
      currencyCode: json['currency_code'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      currencyMinorUnit: (json['currency_minor_unit'] as num?)?.toInt(),
      currencyDecimalSeparator: json['currency_decimal_separator'] as String?,
      currencyThousandSeparator: json['currency_thousand_separator'] as String?,
      currencyPrefix: json['currency_prefix'] as String?,
      currencySuffix: json['currency_suffix'] as String?,
      totalDiscount: json['total_discount'] as String?,
      totalDiscountTax: json['total_discount_tax'] as String?,
    );

Map<String, dynamic> _$$TotalsImplToJson(_$TotalsImpl instance) =>
    <String, dynamic>{
      if (instance.currencyCode case final value?) 'currency_code': value,
      if (instance.currencySymbol case final value?) 'currency_symbol': value,
      if (instance.currencyMinorUnit case final value?)
        'currency_minor_unit': value,
      if (instance.currencyDecimalSeparator case final value?)
        'currency_decimal_separator': value,
      if (instance.currencyThousandSeparator case final value?)
        'currency_thousand_separator': value,
      if (instance.currencyPrefix case final value?) 'currency_prefix': value,
      if (instance.currencySuffix case final value?) 'currency_suffix': value,
      if (instance.totalDiscount case final value?) 'total_discount': value,
      if (instance.totalDiscountTax case final value?)
        'total_discount_tax': value,
    };
