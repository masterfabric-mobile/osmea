// To parse this JSON data, do
//
//     final removesAddressFromCustomersAddressListResponse = removesAddressFromCustomersAddressListResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'removes_address_from_customers_address_list_response.freezed.dart';
part 'removes_address_from_customers_address_list_response.g.dart';

RemovesAddressFromCustomersAddressListResponse removesAddressFromCustomersAddressListResponseFromJson(String str) => RemovesAddressFromCustomersAddressListResponse.fromJson(json.decode(str));

String removesAddressFromCustomersAddressListResponseToJson(RemovesAddressFromCustomersAddressListResponse data) => json.encode(data.toJson());

@freezed
class RemovesAddressFromCustomersAddressListResponse with _$RemovesAddressFromCustomersAddressListResponse {
    const factory RemovesAddressFromCustomersAddressListResponse({
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _RemovesAddressFromCustomersAddressListResponse;

    factory RemovesAddressFromCustomersAddressListResponse.fromJson(Map<String, dynamic> json) => _$RemovesAddressFromCustomersAddressListResponseFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "base")
        List<String>? base,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}