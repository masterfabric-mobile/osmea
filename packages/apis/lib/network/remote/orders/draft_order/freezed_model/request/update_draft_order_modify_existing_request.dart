import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_draft_order_modify_existing_request.freezed.dart';
part 'update_draft_order_modify_existing_request.g.dart';

UpdateDraftOrderModifyExistingRequest
    updateDraftOrderModifyExistingRequestFromJson(String str) =>
        UpdateDraftOrderModifyExistingRequest.fromJson(json.decode(str));

String updateDraftOrderModifyExistingRequestToJson(
        UpdateDraftOrderModifyExistingRequest data) =>
    json.encode(data.toJson());

@freezed
class UpdateDraftOrderModifyExistingRequest
    with _$UpdateDraftOrderModifyExistingRequest {
  const factory UpdateDraftOrderModifyExistingRequest({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _UpdateDraftOrderModifyExistingRequest;

  factory UpdateDraftOrderModifyExistingRequest.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateDraftOrderModifyExistingRequestFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "shipping_address") ShippingAddress? shippingAddress,
    @JsonKey(name: "applied_discount") AppliedDiscount? appliedDiscount,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class AppliedDiscount with _$AppliedDiscount {
  const factory AppliedDiscount({
    @JsonKey(name: "description") String? description,
  }) = _AppliedDiscount;

  factory AppliedDiscount.fromJson(Map<String, dynamic> json) =>
      _$AppliedDiscountFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "quantity") int? quantity,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class ShippingAddress with _$ShippingAddress {
  const factory ShippingAddress({
    @JsonKey(name: "zip") String? zip,
  }) = _ShippingAddress;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);
}
