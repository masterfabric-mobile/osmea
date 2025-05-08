// To parse this JSON data, do
//
//     final updatesGiftCardResponse = updatesGiftCardResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'updates_gift_card_response.freezed.dart';
part 'updates_gift_card_response.g.dart';

UpdatesGiftCardResponse updatesGiftCardResponseFromJson(String str) =>
    UpdatesGiftCardResponse.fromJson(json.decode(str));

String updatesGiftCardResponseToJson(UpdatesGiftCardResponse data) =>
    json.encode(data.toJson());

@freezed
class UpdatesGiftCardResponse with _$UpdatesGiftCardResponse {
  const factory UpdatesGiftCardResponse({
    @JsonKey(name: "gift_card") GiftCard? giftCard,
  }) = _UpdatesGiftCardResponse;

  factory UpdatesGiftCardResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatesGiftCardResponseFromJson(json);
}

@freezed
class GiftCard with _$GiftCard {
  const factory GiftCard({
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "template_suffix") String? templateSuffix,
    @JsonKey(name: "initial_value") String? initialValue,
    @JsonKey(name: "balance") String? balance,
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "disabled_at") String? disabledAt,
    @JsonKey(name: "line_item_id") dynamic lineItemId,
    @JsonKey(name: "api_client_id") int? apiClientId,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "customer_id") dynamic customerId,
    @JsonKey(name: "expires_on") dynamic expiresOn,
    @JsonKey(name: "last_characters") String? lastCharacters,
    @JsonKey(name: "order_id") dynamic orderId,
  }) = _GiftCard;

  factory GiftCard.fromJson(Map<String, dynamic> json) =>
      _$GiftCardFromJson(json);
}
