// To parse this JSON data, do
//
//     final disableGiftCardRequest = disableGiftCardRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'disable_gift_card_request.freezed.dart';
part 'disable_gift_card_request.g.dart';

DisableGiftCardRequest disableGiftCardRequestFromJson(String str) =>
    DisableGiftCardRequest.fromJson(json.decode(str));

String disableGiftCardRequestToJson(DisableGiftCardRequest data) =>
    json.encode(data.toJson());

@freezed
class DisableGiftCardRequest with _$DisableGiftCardRequest {
  const factory DisableGiftCardRequest({
    @JsonKey(name: "gift_card") GiftCard? giftCard,
  }) = _DisableGiftCardRequest;

  factory DisableGiftCardRequest.fromJson(Map<String, dynamic> json) =>
      _$DisableGiftCardRequestFromJson(json);
}

@freezed
class GiftCard with _$GiftCard {
  const factory GiftCard({
    @JsonKey(name: "disabled_at") String? disabledAt,
    @JsonKey(name: "template_suffix") String? templateSuffix,
    @JsonKey(name: "initial_value") String? initialValue,
    @JsonKey(name: "balance") String? balance,
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "line_item_id") dynamic lineItemId,
    @JsonKey(name: "api_client_id") int? apiClientId,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "customer_id") dynamic customerId,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "expires_on") dynamic expiresOn,
    @JsonKey(name: "last_characters") String? lastCharacters,
    @JsonKey(name: "order_id") dynamic orderId,
  }) = _GiftCard;

  factory GiftCard.fromJson(Map<String, dynamic> json) =>
      _$GiftCardFromJson(json);
}
