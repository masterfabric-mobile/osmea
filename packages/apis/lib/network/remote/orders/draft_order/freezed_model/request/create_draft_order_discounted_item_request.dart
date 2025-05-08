import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_draft_order_discounted_item_request.freezed.dart';
part 'create_draft_order_discounted_item_request.g.dart';

CreateDraftOrderDiscountedItemRequest
    createDraftOrderDiscountedItemRequestFromJson(String str) =>
        CreateDraftOrderDiscountedItemRequest.fromJson(json.decode(str));

String createDraftOrderDiscountedItemRequestToJson(
        CreateDraftOrderDiscountedItemRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateDraftOrderDiscountedItemRequest
    with _$CreateDraftOrderDiscountedItemRequest {
  const factory CreateDraftOrderDiscountedItemRequest({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _CreateDraftOrderDiscountedItemRequest;

  factory CreateDraftOrderDiscountedItemRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateDraftOrderDiscountedItemRequestFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "applied_discount") AppliedDiscount? appliedDiscount,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
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
