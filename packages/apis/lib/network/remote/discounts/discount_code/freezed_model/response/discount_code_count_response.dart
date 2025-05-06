// To parse this JSON data, do
//
//     final discountCodeCountResponse = discountCodeCountResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'discount_code_count_response.freezed.dart';
part 'discount_code_count_response.g.dart';

DiscountCodeCountResponse discountCodeCountResponseFromJson(String str) =>
    DiscountCodeCountResponse.fromJson(json.decode(str));

String discountCodeCountResponseToJson(DiscountCodeCountResponse data) =>
    json.encode(data.toJson());

@freezed
class DiscountCodeCountResponse with _$DiscountCodeCountResponse {
  const factory DiscountCodeCountResponse({
    @JsonKey(name: "count") int? count,
  }) = _DiscountCodeCountResponse;

  factory DiscountCodeCountResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeCountResponseFromJson(json);
}
