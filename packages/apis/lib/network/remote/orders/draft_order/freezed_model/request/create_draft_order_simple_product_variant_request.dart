import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_draft_order_simple_product_variant_request.freezed.dart';
part 'create_draft_order_simple_product_variant_request.g.dart';

CreateDraftOrderSimpleProductVariantRequest
    createDraftOrderSimpleProductVariantRequestFromJson(String str) =>
        CreateDraftOrderSimpleProductVariantRequest.fromJson(json.decode(str));

String createDraftOrderSimpleProductVariantRequestToJson(
        CreateDraftOrderSimpleProductVariantRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateDraftOrderSimpleProductVariantRequest
    with _$CreateDraftOrderSimpleProductVariantRequest {
  const factory CreateDraftOrderSimpleProductVariantRequest({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _CreateDraftOrderSimpleProductVariantRequest;

  factory CreateDraftOrderSimpleProductVariantRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateDraftOrderSimpleProductVariantRequestFromJson(json);
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
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "quantity") int? quantity,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}
