// To parse this JSON data, do
//
//     final createDiscountCodeCreationRequest = createDiscountCodeCreationRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_discount_code_creation_request.freezed.dart';
part 'create_discount_code_creation_request.g.dart';

CreateDiscountCodeCreationRequest createDiscountCodeCreationRequestFromJson(
        String str) =>
    CreateDiscountCodeCreationRequest.fromJson(json.decode(str));

String createDiscountCodeCreationRequestToJson(
        CreateDiscountCodeCreationRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateDiscountCodeCreationRequest
    with _$CreateDiscountCodeCreationRequest {
  const factory CreateDiscountCodeCreationRequest({
    @JsonKey(name: "discount_codes") List<DiscountCode>? discountCodes,
  }) = _CreateDiscountCodeCreationRequest;

  factory CreateDiscountCodeCreationRequest.fromJson(
          Map<String, dynamic> json) =>
      _$CreateDiscountCodeCreationRequestFromJson(json);
}

@freezed
class DiscountCode with _$DiscountCode {
  const factory DiscountCode({
    @JsonKey(name: "code") String? code,
  }) = _DiscountCode;

  factory DiscountCode.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeFromJson(json);
}
