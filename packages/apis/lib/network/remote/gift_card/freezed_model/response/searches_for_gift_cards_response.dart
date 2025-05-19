// To parse this JSON data, do
//
//     final searchesForGiftCardResponse = searchesForGiftCardResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'searches_for_gift_cards_response.freezed.dart';
part 'searches_for_gift_cards_response.g.dart';

SearchesForGiftCardResponse searchesForGiftCardResponseFromJson(String str) =>
    SearchesForGiftCardResponse.fromJson(json.decode(str));

String searchesForGiftCardResponseToJson(SearchesForGiftCardResponse data) =>
    json.encode(data.toJson());

@freezed
class SearchesForGiftCardResponse with _$SearchesForGiftCardResponse {
  const factory SearchesForGiftCardResponse({
    @JsonKey(name: "gift_cards") List<GiftCard>? giftCards,
  }) = _SearchesForGiftCardResponse;

  factory SearchesForGiftCardResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchesForGiftCardResponseFromJson(json);
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
    @JsonKey(name: "disabled_at") String? disabledAt,
    @JsonKey(name: "line_item_id") dynamic lineItemId,
    @JsonKey(name: "api_client_id") int? apiClientId,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "customer_id") dynamic customerId,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "expires_on") dynamic expiresOn,
    @JsonKey(name: "template_suffix") String? templateSuffix,
    @JsonKey(name: "last_characters") String? lastCharacters,
    @JsonKey(name: "order_id") dynamic orderId,
  }) = _GiftCard;

  factory GiftCard.fromJson(Map<String, dynamic> json) =>
      _$GiftCardFromJson(json);
}
