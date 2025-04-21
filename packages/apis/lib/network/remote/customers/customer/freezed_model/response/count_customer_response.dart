// To parse this JSON data, do
//
//     final countCustomerResponse = countCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_customer_response.freezed.dart';
part 'count_customer_response.g.dart';

CountCustomerResponse countCustomerResponseFromJson(String str) => CountCustomerResponse.fromJson(json.decode(str));

String countCustomerResponseToJson(CountCustomerResponse data) => json.encode(data.toJson());

@freezed
class CountCustomerResponse with _$CountCustomerResponse {
    const factory CountCustomerResponse({
        @JsonKey(name: "count")
        required int count,
    }) = _CountCustomerResponse;

    factory CountCustomerResponse.fromJson(Map<String, dynamic> json) => _$CountCustomerResponseFromJson(json);
}
