import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_comprehensive_request.freezed.dart';
part 'create_order_comprehensive_request.g.dart';

CreateOrderComprehensiveRequest createOrderComprehensiveRequestFromJson(
        String str) =>
    CreateOrderComprehensiveRequest.fromJson(json.decode(str));

String createOrderComprehensiveRequestToJson(
        CreateOrderComprehensiveRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderComprehensiveRequest with _$CreateOrderComprehensiveRequest {
  const factory CreateOrderComprehensiveRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderComprehensiveRequest;

  factory CreateOrderComprehensiveRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderComprehensiveRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "transactions") List<Transaction>? transactions,
    @JsonKey(name: "total_tax") double? totalTax,
    @JsonKey(name: "currency") String? currency,
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
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
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

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @JsonKey(name: "kind") String? kind,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "amount") double? amount,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
