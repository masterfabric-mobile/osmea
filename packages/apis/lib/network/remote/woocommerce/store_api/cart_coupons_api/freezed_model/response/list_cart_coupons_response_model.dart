// To parse this JSON data, do
//
//     final listCartCouponsResponseModel = listCartCouponsResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_cart_coupons_response_model.freezed.dart';
part 'list_cart_coupons_response_model.g.dart';

List<ListCartCouponsResponseModel> listCartCouponsResponseModelFromJson(
        String str) =>
    List<ListCartCouponsResponseModel>.from(
        json.decode(str).map((x) => ListCartCouponsResponseModel.fromJson(x)));

String listCartCouponsResponseModelToJson(
        List<ListCartCouponsResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
class ListCartCouponsResponseModel with _$ListCartCouponsResponseModel {
  const factory ListCartCouponsResponseModel({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "totals") Totals? totals,
    @JsonKey(name: "_links") Links? links,
  }) = _ListCartCouponsResponseModel;

  factory ListCartCouponsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ListCartCouponsResponseModelFromJson(json);
}

@freezed
class Links with _$Links {
  const factory Links({
    @JsonKey(name: "self") List<Collection>? self,
    @JsonKey(name: "collection") List<Collection>? collection,
  }) = _Links;

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
}

@freezed
class Collection with _$Collection {
  const factory Collection({
    @JsonKey(name: "href") String? href,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
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
