// To parse this JSON data, do
//
//     final ordersBelongingToCustomerResponse = ordersBelongingToCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'orders_belonging_to_customer_response.freezed.dart';
part 'orders_belonging_to_customer_response.g.dart';

OrdersBelongingToCustomerResponse ordersBelongingToCustomerResponseFromJson(String str) => OrdersBelongingToCustomerResponse.fromJson(json.decode(str));

String ordersBelongingToCustomerResponseToJson(OrdersBelongingToCustomerResponse data) => json.encode(data.toJson());

@freezed
class OrdersBelongingToCustomerResponse with _$OrdersBelongingToCustomerResponse {
    const factory OrdersBelongingToCustomerResponse({
        @JsonKey(name: "orders")
        required List<dynamic> orders,
    }) = _OrdersBelongingToCustomerResponse;

    factory OrdersBelongingToCustomerResponse.fromJson(Map<String, dynamic> json) => _$OrdersBelongingToCustomerResponseFromJson(json);
}
