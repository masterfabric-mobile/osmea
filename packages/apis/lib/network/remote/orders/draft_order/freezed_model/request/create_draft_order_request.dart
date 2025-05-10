import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_draft_order_request.freezed.dart';
part 'create_draft_order_request.g.dart';

CreateDraftOrderRequest createDraftOrderRequestFromJson(String str) =>
    CreateDraftOrderRequest.fromJson(json.decode(str));

String createDraftOrderRequestToJson(CreateDraftOrderRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateDraftOrderRequest with _$CreateDraftOrderRequest {
  const factory CreateDraftOrderRequest({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _CreateDraftOrderRequest;

  factory CreateDraftOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDraftOrderRequestFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "allow_discount_codes_in_checkout?")
    bool? allowDiscountCodesInCheckout,
    @JsonKey(name: "b2b?") bool? b2B,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "total_price") String? totalPrice,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "total_tax") String? totalTax,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "product_id") int? productId,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "vendor") String? vendor,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "requires_shipping") bool? requiresShipping,
    @JsonKey(name: "taxable") bool? taxable,
    @JsonKey(name: "gift_card") bool? giftCard,
    @JsonKey(name: "fulfillment_service") String? fulfillmentService,
    @JsonKey(name: "grams") int? grams,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "custom") bool? custom,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "name") String? name,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class TaxLine with _$TaxLine {
  const factory TaxLine({
    @JsonKey(name: "rate") double? rate,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
  }) = _TaxLine;

  factory TaxLine.fromJson(Map<String, dynamic> json) =>
      _$TaxLineFromJson(json);
}
