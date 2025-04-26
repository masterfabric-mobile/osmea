// To parse this JSON data, do
//
//     final createsNewAddressForCustomerRequest = createsNewAddressForCustomerRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_new_address_for_customer_request.freezed.dart';
part 'creates_new_address_for_customer_request.g.dart';

CreatesNewAddressForCustomerRequest createsNewAddressForCustomerRequestFromJson(String str) => CreatesNewAddressForCustomerRequest.fromJson(json.decode(str));

String createsNewAddressForCustomerRequestToJson(CreatesNewAddressForCustomerRequest data) => json.encode(data.toJson());

@freezed
class CreatesNewAddressForCustomerRequest with _$CreatesNewAddressForCustomerRequest {
    const factory CreatesNewAddressForCustomerRequest({
        @JsonKey(name: "address")
        Address? address,
    }) = _CreatesNewAddressForCustomerRequest;

    factory CreatesNewAddressForCustomerRequest.fromJson(Map<String, dynamic> json) => _$CreatesNewAddressForCustomerRequestFromJson(json);
}

@freezed
class Address with _$Address {
    const factory Address({
        @JsonKey(name: "address1")
        String? address1,
        @JsonKey(name: "address2")
        String? address2,
        @JsonKey(name: "city")
        String? city,
        @JsonKey(name: "company")
        String? company,
        @JsonKey(name: "first_name")
        String? firstName,
        @JsonKey(name: "last_name")
        String? lastName,
        @JsonKey(name: "phone")
        String? phone,
        @JsonKey(name: "province")
        String? province,
        @JsonKey(name: "country")
        String? country,
        @JsonKey(name: "zip")
        String? zip,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "province_code")
        String? provinceCode,
        @JsonKey(name: "country_code")
        String? countryCode,
        @JsonKey(name: "country_name")
        String? countryName,
    }) = _Address;

    factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
