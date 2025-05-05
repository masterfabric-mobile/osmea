import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_discount_code_request.freezed.dart';
part 'create_discount_code_request.g.dart';

CreateDiscountCodeRequest createDiscountCodeRequestFromJson(String str) =>
    CreateDiscountCodeRequest.fromJson(json.decode(str));

String createDiscountCodeRequestToJson(CreateDiscountCodeRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateDiscountCodeRequest with _$CreateDiscountCodeRequest {
  const factory CreateDiscountCodeRequest({
    @JsonKey(name: "discount_code") DiscountCode? discountCode,
  }) = _CreateDiscountCodeRequest;

  factory CreateDiscountCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDiscountCodeRequestFromJson(json);
}

@freezed
class DiscountCode with _$DiscountCode {
  const factory DiscountCode({
    @JsonKey(name: "code") String? code,
  }) = _DiscountCode;

  factory DiscountCode.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeFromJson(json);
}
