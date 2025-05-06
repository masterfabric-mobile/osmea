import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'discount_code_list_creation_response.freezed.dart';
part 'discount_code_list_creation_response.g.dart';

DiscountCodeListCreationResponse discountCodeListCreationResponseFromJson(
        String str) =>
    DiscountCodeListCreationResponse.fromJson(json.decode(str));

String discountCodeListCreationResponseToJson(
        DiscountCodeListCreationResponse data) =>
    json.encode(data.toJson());

@freezed
class DiscountCodeListCreationResponse with _$DiscountCodeListCreationResponse {
  const factory DiscountCodeListCreationResponse({
    @JsonKey(name: "discount_codes") List<DiscountCode>? discountCodes,
  }) = _DiscountCodeListCreationResponse;

  factory DiscountCodeListCreationResponse.fromJson(
          Map<String, dynamic> json) =>
      _$DiscountCodeListCreationResponseFromJson(json);
}

@freezed
class DiscountCode with _$DiscountCode {
  const factory DiscountCode({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "errors") Errors? errors,
  }) = _DiscountCode;

  factory DiscountCode.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeFromJson(json);
}

@freezed
class Errors with _$Errors {
  const factory Errors() = _Errors;

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
