// To parse this JSON data, do
//
//     final updatePostalCodeOfCustomerAddressResponse = updatePostalCodeOfCustomerAddressResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_postal_code_of_customer_address_response.freezed.dart';
part 'update_postal_code_of_customer_address_response.g.dart';

UpdatePostalCodeOfCustomerAddressResponse updatePostalCodeOfCustomerAddressResponseFromJson(String str) => UpdatePostalCodeOfCustomerAddressResponse.fromJson(json.decode(str));

String updatePostalCodeOfCustomerAddressResponseToJson(UpdatePostalCodeOfCustomerAddressResponse data) => json.encode(data.toJson());

@freezed
class UpdatePostalCodeOfCustomerAddressResponse with _$UpdatePostalCodeOfCustomerAddressResponse {
    const factory UpdatePostalCodeOfCustomerAddressResponse({
        @JsonKey(name: "customer_address")
        CustomerAddress? customerAddress,
    }) = _UpdatePostalCodeOfCustomerAddressResponse;

    factory UpdatePostalCodeOfCustomerAddressResponse.fromJson(Map<String, dynamic> json) => _$UpdatePostalCodeOfCustomerAddressResponseFromJson(json);
}

@freezed
class CustomerAddress with _$CustomerAddress {
    const factory CustomerAddress({
        @JsonKey(name: "customer_id")
        int? customerId,
        @JsonKey(name: "country")
        String? country,
        @JsonKey(name: "province")
        String? province,
        @JsonKey(name: "company")
        dynamic company,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "province_code")
        String? provinceCode,
        @JsonKey(name: "country_code")
        String? countryCode,
        @JsonKey(name: "country_name")
        String? countryName,
        @JsonKey(name: "default")
        bool? customerAddressDefault,
    }) = _CustomerAddress;

    factory CustomerAddress.fromJson(Map<String, dynamic> json) => _$CustomerAddressFromJson(json);
}
