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
    _$RetrieveCartCouponResponseModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('type', instance.type);
  writeNotNull('totals', instance.totals?.toJson());
  return val;
}

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

Map<String, dynamic> _$$TotalsImplToJson(_$TotalsImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('currency_code', instance.currencyCode);
  writeNotNull('currency_symbol', instance.currencySymbol);
  writeNotNull('currency_minor_unit', instance.currencyMinorUnit);
  writeNotNull('currency_decimal_separator', instance.currencyDecimalSeparator);
  writeNotNull(
      'currency_thousand_separator', instance.currencyThousandSeparator);
  writeNotNull('currency_prefix', instance.currencyPrefix);
  writeNotNull('currency_suffix', instance.currencySuffix);
  writeNotNull('total_discount', instance.totalDiscount);
  writeNotNull('total_discount_tax', instance.totalDiscountTax);
  return val;
}
