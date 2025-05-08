import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_draft_order_with_discount_request.freezed.dart';
part 'create_draft_order_with_discount_request.g.dart';

CreateDraftOrderWithDiscountRequest createDraftOrderWithDiscountRequestFromJson(
        String str) =>
    CreateDraftOrderWithDiscountRequest.fromJson(json.decode(str));

String createDraftOrderWithDiscountRequestToJson(
        CreateDraftOrderWithDiscountRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateDraftOrderWithDiscountRequest
    with _$CreateDraftOrderWithDiscountRequest {
  const factory CreateDraftOrderWithDiscountRequest({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _CreateDraftOrderWithDiscountRequest;

  factory CreateDraftOrderWithDiscountRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateDraftOrderWithDiscountRequestFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "applied_discount") AppliedDiscount? appliedDiscount,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "use_customer_default_address")
    bool? useCustomerDefaultAddress,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class AppliedDiscount with _$AppliedDiscount {
  const factory AppliedDiscount({
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "value_type") String? valueType,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "title") String? title,
  }) = _AppliedDiscount;

  factory AppliedDiscount.fromJson(Map<String, dynamic> json) =>
      _$AppliedDiscountFromJson(json);
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
