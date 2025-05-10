import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_draft_order_complete_request.freezed.dart';
part 'update_draft_order_complete_request.g.dart';

UpdateDraftOrderCompleteRequest updateDraftOrderCompleteRequestFromJson(
        String str) =>
    UpdateDraftOrderCompleteRequest.fromJson(json.decode(str));

String updateDraftOrderCompleteRequestToJson(
        UpdateDraftOrderCompleteRequest data) =>
    json.encode(data.toJson());

@freezed
class UpdateDraftOrderCompleteRequest with _$UpdateDraftOrderCompleteRequest {
  const factory UpdateDraftOrderCompleteRequest({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _UpdateDraftOrderCompleteRequest;

  factory UpdateDraftOrderCompleteRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateDraftOrderCompleteRequestFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "invoice_sent_at") String? invoiceSentAt,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "completed_at") String? completedAt,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "shipping_address") IngAddress? shippingAddress,
    @JsonKey(name: "billing_address") IngAddress? billingAddress,
    @JsonKey(name: "applied_discount") AppliedDiscount? appliedDiscount,
    @JsonKey(name: "shipping_line") ShippingLine? shippingLine,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "note_attributes") List<NoteAttribute>? noteAttributes,
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
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "value_type") String? valueType,
  }) = _AppliedDiscount;

  factory AppliedDiscount.fromJson(Map<String, dynamic> json) =>
      _$AppliedDiscountFromJson(json);
}

@freezed
class IngAddress with _$IngAddress {
  const factory IngAddress({
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "city") String? city,
    @JsonKey(name: "zip") String? zip,
    @JsonKey(name: "province") String? province,
    @JsonKey(name: "country") String? country,
    @JsonKey(name: "last_name") String? lastName,
  }) = _IngAddress;

  factory IngAddress.fromJson(Map<String, dynamic> json) =>
      _$IngAddressFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "last_name") String? lastName,
    @JsonKey(name: "phone") String? phone,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "product_id") int? productId,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "variant_title") String? variantTitle,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "applied_discount") AppliedDiscount? appliedDiscount,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class NoteAttribute with _$NoteAttribute {
  const factory NoteAttribute({
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "value") String? value,
  }) = _NoteAttribute;

  factory NoteAttribute.fromJson(Map<String, dynamic> json) =>
      _$NoteAttributeFromJson(json);
}

@freezed
class ShippingLine with _$ShippingLine {
  const factory ShippingLine({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "custom") bool? custom,
  }) = _ShippingLine;

  factory ShippingLine.fromJson(Map<String, dynamic> json) =>
      _$ShippingLineFromJson(json);
}
