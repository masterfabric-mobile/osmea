// To parse this JSON data, do
//
//     final destroyMultipleCustomerAddressesResponse = destroyMultipleCustomerAddressesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'destroy_multiple_customer_addresses_response.freezed.dart';
part 'destroy_multiple_customer_addresses_response.g.dart';

DestroyMultipleCustomerAddressesResponse
    destroyMultipleCustomerAddressesResponseFromJson(String str) =>
        DestroyMultipleCustomerAddressesResponse.fromJson(json.decode(str));

String destroyMultipleCustomerAddressesResponseToJson(
        DestroyMultipleCustomerAddressesResponse data) =>
    json.encode(data.toJson());

@freezed
class DestroyMultipleCustomerAddressesResponse
    with _$DestroyMultipleCustomerAddressesResponse {
  const factory DestroyMultipleCustomerAddressesResponse({
    // Shopify returns errors in this format when deletion fails
    // (especially for default address deletion attempts)
    String? errors,
  }) = _DestroyMultipleCustomerAddressesResponse;

  factory DestroyMultipleCustomerAddressesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$DestroyMultipleCustomerAddressesResponseFromJson(json);
}
