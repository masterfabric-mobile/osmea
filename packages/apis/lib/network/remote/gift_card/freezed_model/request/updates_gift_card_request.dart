import 'package:freezed_annotation/freezed_annotation.dart';

part 'updates_gift_card_request.freezed.dart';
part 'updates_gift_card_request.g.dart';

@freezed
class UpdatesGiftCardRequest with _$UpdatesGiftCardRequest {
  const factory UpdatesGiftCardRequest({
    @JsonKey(name: "gift_card") required GiftCardUpdate giftCard,
  }) = _UpdatesGiftCardRequest;

  factory UpdatesGiftCardRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatesGiftCardRequestFromJson(json);
}

@freezed
class GiftCardUpdate with _$GiftCardUpdate {
  const factory GiftCardUpdate({
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "template_suffix") String? templateSuffix,
    @JsonKey(name: "expires_on") String? expiresOn, // ISO 8601
  }) = _GiftCardUpdate;

  factory GiftCardUpdate.fromJson(Map<String, dynamic> json) =>
      _$GiftCardUpdateFromJson(json);
}
