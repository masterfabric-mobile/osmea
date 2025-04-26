// To parse this JSON data, do
//
//     final createsNewAddressForCustomerResponse = createsNewAddressForCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_new_address_for_customer_response.freezed.dart';
part 'creates_new_address_for_customer_response.g.dart';

CreatesNewAddressForCustomerResponse createsNewAddressForCustomerResponseFromJson(String str) => CreatesNewAddressForCustomerResponse.fromJson(json.decode(str));

String createsNewAddressForCustomerResponseToJson(CreatesNewAddressForCustomerResponse data) => json.encode(data.toJson());

@freezed
class CreatesNewAddressForCustomerResponse with _$CreatesNewAddressForCustomerResponse {
    const factory CreatesNewAddressForCustomerResponse({
        @JsonKey(name: "customer_address")
        CustomerAddress? customerAddress,
    }) = _CreatesNewAddressForCustomerResponse;

    factory CreatesNewAddressForCustomerResponse.fromJson(Map<String, dynamic> json) => _$CreatesNewAddressForCustomerResponseFromJson(json);
}

@freezed
class CustomerAddress with _$CustomerAddress {
    const factory CustomerAddress({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "customer_id")
        int? customerId,
        @JsonKey(name: "company")
        String? company,
        @JsonKey(name: "province")
        String? province,
        @JsonKey(name: "country")
        String? country,
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
