// To parse this JSON data, do
//
//     final retrievesAllOrdersBelongingToCustomerResponse = retrievesAllOrdersBelongingToCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_all_orders_belonging_to_customer_response.freezed.dart';
part 'retrieves_all_orders_belonging_to_customer_response.g.dart';

RetrievesAllOrdersBelongingToCustomerResponse retrievesAllOrdersBelongingToCustomerResponseFromJson(String str) => RetrievesAllOrdersBelongingToCustomerResponse.fromJson(json.decode(str));

String retrievesAllOrdersBelongingToCustomerResponseToJson(RetrievesAllOrdersBelongingToCustomerResponse data) => json.encode(data.toJson());

@freezed
class RetrievesAllOrdersBelongingToCustomerResponse with _$RetrievesAllOrdersBelongingToCustomerResponse {
    const factory RetrievesAllOrdersBelongingToCustomerResponse({
        @JsonKey(name: "orders")
        List<dynamic>? orders,
    }) = _RetrievesAllOrdersBelongingToCustomerResponse;

    factory RetrievesAllOrdersBelongingToCustomerResponse.fromJson(Map<String, dynamic> json) => _$RetrievesAllOrdersBelongingToCustomerResponseFromJson(json);
}
