import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_partially_paid_request.freezed.dart';
part 'create_order_partially_paid_request.g.dart';

CreateOrderPartiallyPaidRequest createOrderPartiallyPaidRequestFromJson(
        String str) =>
    CreateOrderPartiallyPaidRequest.fromJson(json.decode(str));

String createOrderPartiallyPaidRequestToJson(
        CreateOrderPartiallyPaidRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderPartiallyPaidRequest with _$CreateOrderPartiallyPaidRequest {
  const factory CreateOrderPartiallyPaidRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderPartiallyPaidRequest;

  factory CreateOrderPartiallyPaidRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderPartiallyPaidRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "billing_address") IngAddress? billingAddress,
    @JsonKey(name: "shipping_address") IngAddress? shippingAddress,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "transactions") List<Transaction>? transactions,
    @JsonKey(name: "financial_status") String? financialStatus,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class IngAddress with _$IngAddress {
  const factory IngAddress({
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "last_name") String? lastName,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "city") String? city,
    @JsonKey(name: "province") String? province,
    @JsonKey(name: "country") String? country,
    @JsonKey(name: "zip") String? zip,
  }) = _IngAddress;

  factory IngAddress.fromJson(Map<String, dynamic> json) =>
      _$IngAddressFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "last_name") String? lastName,
    @JsonKey(name: "email") String? email,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "quantity") int? quantity,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class TaxLine with _$TaxLine {
  const factory TaxLine({
    @JsonKey(name: "price") int? price,
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
    @JsonKey(name: "amount") int? amount,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
