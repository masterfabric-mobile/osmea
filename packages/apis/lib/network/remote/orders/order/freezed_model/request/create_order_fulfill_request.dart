import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_fulfill_request.freezed.dart';
part 'create_order_fulfill_request.g.dart';

CreateOrderFulfillRequest createOrderFulfillRequestFromJson(String str) =>
    CreateOrderFulfillRequest.fromJson(json.decode(str));

String createOrderFulfillRequestToJson(CreateOrderFulfillRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderFulfillRequest with _$CreateOrderFulfillRequest {
  const factory CreateOrderFulfillRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderFulfillRequest;

  factory CreateOrderFulfillRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderFulfillRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "fulfillment_status") String? fulfillmentStatus,
    @JsonKey(name: "fulfillments") List<Fulfillment>? fulfillments,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class Fulfillment with _$Fulfillment {
  const factory Fulfillment({
    @JsonKey(name: "location_id") int? locationId,
  }) = _Fulfillment;

  factory Fulfillment.fromJson(Map<String, dynamic> json) =>
      _$FulfillmentFromJson(json);
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
