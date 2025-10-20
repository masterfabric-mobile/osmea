// To parse this JSON data, do
//
//     final addCartCouponResponseModel = addCartCouponResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'add_cart_coupon_response_model.freezed.dart';
part 'add_cart_coupon_response_model.g.dart';

AddCartCouponResponseModel addCartCouponResponseModelFromJson(String str) =>
    AddCartCouponResponseModel.fromJson(json.decode(str));

String addCartCouponResponseModelToJson(AddCartCouponResponseModel data) =>
    json.encode(data.toJson());

@freezed
class AddCartCouponResponseModel with _$AddCartCouponResponseModel {
  const factory AddCartCouponResponseModel({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "totals") Totals? totals,
  }) = _AddCartCouponResponseModel;

  factory AddCartCouponResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddCartCouponResponseModelFromJson(json);
}

@freezed
class Totals with _$Totals {
  const factory Totals({
    @JsonKey(name: "currency_code") String? currencyCode,
    @JsonKey(name: "currency_symbol") String? currencySymbol,
    @JsonKey(name: "currency_minor_unit") int? currencyMinorUnit,
    @JsonKey(name: "currency_decimal_separator")
    String? currencyDecimalSeparator,
    @JsonKey(name: "currency_thousand_separator")
    String? currencyThousandSeparator,
    @JsonKey(name: "currency_prefix") String? currencyPrefix,
    @JsonKey(name: "currency_suffix") String? currencySuffix,
    @JsonKey(name: "total_discount") String? totalDiscount,
    @JsonKey(name: "total_discount_tax") String? totalDiscountTax,
  }) = _Totals;

  factory Totals.fromJson(Map<String, dynamic> json) => _$TotalsFromJson(json);
}
