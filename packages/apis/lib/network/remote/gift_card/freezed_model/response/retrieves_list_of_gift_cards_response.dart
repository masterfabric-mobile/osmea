// To parse this JSON data, do
//
//     final retrievesListOfGiftCardResponse = retrievesListOfGiftCardResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_list_of_gift_cards_response.freezed.dart';
part 'retrieves_list_of_gift_cards_response.g.dart';

RetrievesListOfGiftCardResponse retrievesListOfGiftCardResponseFromJson(
        String str) =>
    RetrievesListOfGiftCardResponse.fromJson(json.decode(str));

String retrievesListOfGiftCardResponseToJson(
        RetrievesListOfGiftCardResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesListOfGiftCardResponse with _$RetrievesListOfGiftCardResponse {
  const factory RetrievesListOfGiftCardResponse({
    @JsonKey(name: "gift_cards") List<GiftCard>? giftCards,
  }) = _RetrievesListOfGiftCardResponse;

  factory RetrievesListOfGiftCardResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrievesListOfGiftCardResponseFromJson(json);
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
