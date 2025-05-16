import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_with_tax_lines_request.freezed.dart';
part 'create_order_with_tax_lines_request.g.dart';

CreateOrderWithTaxLinesRequest createOrderWithTaxLinesRequestFromJson(
        String str) =>
    CreateOrderWithTaxLinesRequest.fromJson(json.decode(str));

String createOrderWithTaxLinesRequestToJson(
        CreateOrderWithTaxLinesRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderWithTaxLinesRequest with _$CreateOrderWithTaxLinesRequest {
  const factory CreateOrderWithTaxLinesRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderWithTaxLinesRequest;

  factory CreateOrderWithTaxLinesRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderWithTaxLinesRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") double? price,
    @JsonKey(name: "grams") String? grams,
    @JsonKey(name: "quantity") int? quantity,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class TaxLine with _$TaxLine {
  const factory TaxLine({
    @JsonKey(name: "price") double? price,
    @JsonKey(name: "rate") double? rate,
    @JsonKey(name: "title") String? title,
  }) = _TaxLine;

  factory TaxLine.fromJson(Map<String, dynamic> json) =>
      _$TaxLineFromJson(json);
}
