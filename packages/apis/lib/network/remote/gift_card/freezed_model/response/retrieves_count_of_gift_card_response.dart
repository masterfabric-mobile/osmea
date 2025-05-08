// To parse this JSON data, do
//
//     final retrievesCountOfGiftCardResponse = retrievesCountOfGiftCardResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_count_of_gift_card_response.freezed.dart';
part 'retrieves_count_of_gift_card_response.g.dart';

RetrievesCountOfGiftCardResponse retrievesCountOfGiftCardResponseFromJson(
        String str) =>
    RetrievesCountOfGiftCardResponse.fromJson(json.decode(str));

String retrievesCountOfGiftCardResponseToJson(
        RetrievesCountOfGiftCardResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesCountOfGiftCardResponse with _$RetrievesCountOfGiftCardResponse {
  const factory RetrievesCountOfGiftCardResponse({
    @JsonKey(name: "count") int? count,
  }) = _RetrievesCountOfGiftCardResponse;

  factory RetrievesCountOfGiftCardResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesCountOfGiftCardResponseFromJson(json);
}
