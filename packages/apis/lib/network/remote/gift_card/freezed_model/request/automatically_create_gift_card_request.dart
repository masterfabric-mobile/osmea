// To parse this JSON data, do
//
//     final automaticallyCreateGiftCardRequest = automaticallyCreateGiftCardRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'automatically_create_gift_card_request.freezed.dart';
part 'automatically_create_gift_card_request.g.dart';

AutomaticallyCreateGiftCardRequest automaticallyCreateGiftCardRequestFromJson(
        String str) =>
    AutomaticallyCreateGiftCardRequest.fromJson(json.decode(str));

String automaticallyCreateGiftCardRequestToJson(
        AutomaticallyCreateGiftCardRequest data) =>
    json.encode(data.toJson());

@freezed
class AutomaticallyCreateGiftCardRequest
    with _$AutomaticallyCreateGiftCardRequest {
  const factory AutomaticallyCreateGiftCardRequest({
    @JsonKey(name: "gift_card") GiftCard? giftCard,
  }) = _AutomaticallyCreateGiftCardRequest;

  factory AutomaticallyCreateGiftCardRequest.fromJson(
          Map<String, dynamic> json) =>
      _$AutomaticallyCreateGiftCardRequestFromJson(json);
}

@freezed
class GiftCard with _$GiftCard {
  const factory GiftCard({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "balance") String? balance,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "initial_value") String? initialValue,
    @JsonKey(name: "disabled_at") dynamic disabledAt,
    @JsonKey(name: "line_item_id") dynamic lineItemId,
    @JsonKey(name: "api_client_id") int? apiClientId,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "customer_id") dynamic customerId,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "expires_on") dynamic expiresOn,
    @JsonKey(name: "template_suffix") dynamic templateSuffix,
    @JsonKey(name: "last_characters") String? lastCharacters,
    @JsonKey(name: "order_id") dynamic orderId,
    @JsonKey(name: "code") String? code,
  }) = _GiftCard;

  factory GiftCard.fromJson(Map<String, dynamic> json) =>
      _$GiftCardFromJson(json);
}
