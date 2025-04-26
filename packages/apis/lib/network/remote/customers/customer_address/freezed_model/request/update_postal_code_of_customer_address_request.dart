// To parse this JSON data, do
//
//     final updatePostalCodeOfCustomerAddressRequest = updatePostalCodeOfCustomerAddressRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_postal_code_of_customer_address_request.freezed.dart';
part 'update_postal_code_of_customer_address_request.g.dart';

UpdatePostalCodeOfCustomerAddressRequest updatePostalCodeOfCustomerAddressRequestFromJson(String str) => UpdatePostalCodeOfCustomerAddressRequest.fromJson(json.decode(str));

String updatePostalCodeOfCustomerAddressRequestToJson(UpdatePostalCodeOfCustomerAddressRequest data) => json.encode(data.toJson());

@freezed
class UpdatePostalCodeOfCustomerAddressRequest with _$UpdatePostalCodeOfCustomerAddressRequest {
    const factory UpdatePostalCodeOfCustomerAddressRequest({
        @JsonKey(name: "address")
        Address? address,
    }) = _UpdatePostalCodeOfCustomerAddressRequest;

    factory UpdatePostalCodeOfCustomerAddressRequest.fromJson(Map<String, dynamic> json) => _$UpdatePostalCodeOfCustomerAddressRequestFromJson(json);
}

@freezed
class Address with _$Address {
    const factory Address({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "zip")
        String? zip,
    }) = _Address;

    factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
