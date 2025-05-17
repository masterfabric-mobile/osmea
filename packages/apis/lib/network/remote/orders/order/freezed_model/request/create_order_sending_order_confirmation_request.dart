import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_sending_order_confirmation_request.freezed.dart';
part 'create_order_sending_order_confirmation_request.g.dart';

CreateOrderSendingOrderConfirmationRequest
    createOrderSendingOrderConfirmationRequestFromJson(String str) =>
        CreateOrderSendingOrderConfirmationRequest.fromJson(json.decode(str));

String createOrderSendingOrderConfirmationRequestToJson(
        CreateOrderSendingOrderConfirmationRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderSendingOrderConfirmationRequest
    with _$CreateOrderSendingOrderConfirmationRequest {
  const factory CreateOrderSendingOrderConfirmationRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderSendingOrderConfirmationRequest;

  factory CreateOrderSendingOrderConfirmationRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateOrderSendingOrderConfirmationRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "fulfillment_status") String? fulfillmentStatus,
    @JsonKey(name: "send_receipt") bool? sendReceipt,
    @JsonKey(name: "send_fulfillment_receipt") bool? sendFulfillmentReceipt,
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
