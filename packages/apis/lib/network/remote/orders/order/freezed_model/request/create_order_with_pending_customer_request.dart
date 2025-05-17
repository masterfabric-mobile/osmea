import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_with_pending_customer_request.freezed.dart';
part 'create_order_with_pending_customer_request.g.dart';

CreateOrderWithPendingCustomerRequest
    createOrderWithPendingCustomerRequestFromJson(String str) =>
        CreateOrderWithPendingCustomerRequest.fromJson(json.decode(str));

String createOrderWithPendingCustomerRequestToJson(
        CreateOrderWithPendingCustomerRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderWithPendingCustomerRequest
    with _$CreateOrderWithPendingCustomerRequest {
  const factory CreateOrderWithPendingCustomerRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderWithPendingCustomerRequest;

  factory CreateOrderWithPendingCustomerRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateOrderWithPendingCustomerRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "financial_status") String? financialStatus,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "last_name") String? lastName,
    @JsonKey(name: "phone") String? phone,
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
