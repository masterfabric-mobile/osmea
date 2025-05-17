import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_with_product_id_request.freezed.dart';
part 'create_order_with_product_id_request.g.dart';

CreateOrderWithProductIdRequest createOrderWithProductIdRequestFromJson(
        String str) =>
    CreateOrderWithProductIdRequest.fromJson(json.decode(str));

String createOrderWithProductIdRequestToJson(
        CreateOrderWithProductIdRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderWithProductIdRequest with _$CreateOrderWithProductIdRequest {
  const factory CreateOrderWithProductIdRequest({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderWithProductIdRequest;

  factory CreateOrderWithProductIdRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderWithProductIdRequestFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
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
