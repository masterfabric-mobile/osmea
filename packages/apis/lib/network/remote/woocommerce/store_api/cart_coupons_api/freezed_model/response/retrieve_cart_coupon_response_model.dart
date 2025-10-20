// To parse this JSON data, do
//
//     final retrieveCartCouponResponseModel = retrieveCartCouponResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieve_cart_coupon_response_model.freezed.dart';
part 'retrieve_cart_coupon_response_model.g.dart';

RetrieveCartCouponResponseModel retrieveCartCouponResponseModelFromJson(
        String str) =>
    RetrieveCartCouponResponseModel.fromJson(json.decode(str));

String retrieveCartCouponResponseModelToJson(
        RetrieveCartCouponResponseModel data) =>
    json.encode(data.toJson());

@freezed
class RetrieveCartCouponResponseModel with _$RetrieveCartCouponResponseModel {
  const factory RetrieveCartCouponResponseModel({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "totals") Totals? totals,
  }) = _RetrieveCartCouponResponseModel;

  factory RetrieveCartCouponResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RetrieveCartCouponResponseModelFromJson(json);
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
