// To parse this JSON data, do
//
//     final retrievesListOfAddressesForCustomerResponse = retrievesListOfAddressesForCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_list_of_addresses_for_customer_response.freezed.dart';
part 'retrieves_list_of_addresses_for_customer_response.g.dart';

RetrievesListOfAddressesForCustomerResponse retrievesListOfAddressesForCustomerResponseFromJson(String str) => RetrievesListOfAddressesForCustomerResponse.fromJson(json.decode(str));

String retrievesListOfAddressesForCustomerResponseToJson(RetrievesListOfAddressesForCustomerResponse data) => json.encode(data.toJson());

@freezed
class RetrievesListOfAddressesForCustomerResponse with _$RetrievesListOfAddressesForCustomerResponse {
    const factory RetrievesListOfAddressesForCustomerResponse({
        @JsonKey(name: "addresses")
        List<Address>? addresses,
    }) = _RetrievesListOfAddressesForCustomerResponse;

    factory RetrievesListOfAddressesForCustomerResponse.fromJson(Map<String, dynamic> json) => _$RetrievesListOfAddressesForCustomerResponseFromJson(json);
}

@freezed
class Address with _$Address {
    const factory Address({
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
        bool? addressDefault,
    }) = _Address;

    factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}
