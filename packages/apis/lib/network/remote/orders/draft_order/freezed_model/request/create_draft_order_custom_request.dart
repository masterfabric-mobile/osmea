import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_draft_order_custom_request.freezed.dart';
part 'create_draft_order_custom_request.g.dart';

CreateDraftOrderCustomRequest createDraftOrderCustomRequestFromJson(
        String str) =>
    CreateDraftOrderCustomRequest.fromJson(json.decode(str));

String createDraftOrderCustomRequestToJson(
        CreateDraftOrderCustomRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateDraftOrderCustomRequest with _$CreateDraftOrderCustomRequest {
  const factory CreateDraftOrderCustomRequest({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _CreateDraftOrderCustomRequest;

  factory CreateDraftOrderCustomRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDraftOrderCustomRequestFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "use_customer_default_address")
    bool? useCustomerDefaultAddress,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "id") int? id,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "quantity") int? quantity,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}
