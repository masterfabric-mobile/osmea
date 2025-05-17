import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_without_order_receipt_request.freezed.dart';
part 'create_order_without_order_receipt_request.g.dart';

CreateOrderWithoutOrderReceiptRequest
    createOrderWithoutOrderReceiptRequestFromJson(String str) =>
        CreateOrderWithoutOrderReceiptRequest.fromJson(json.decode(str));

String createOrderWithoutOrderReceiptRequestToJson(
        CreateOrderWithoutOrderReceiptRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderWithoutOrderReceiptRequest
    with _$CreateOrderWithoutOrderReceiptRequest {
  const factory CreateOrderWithoutOrderReceiptRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderWithoutOrderReceiptRequest;

  factory CreateOrderWithoutOrderReceiptRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateOrderWithoutOrderReceiptRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "fulfillment_status") String? fulfillmentStatus,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
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
