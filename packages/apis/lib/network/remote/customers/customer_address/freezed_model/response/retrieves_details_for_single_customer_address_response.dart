// To parse this JSON data, do
//
//     final retrievesDetailsForSingleCustomerAddressResponse = retrievesDetailsForSingleCustomerAddressResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_details_for_single_customer_address_response.freezed.dart';
part 'retrieves_details_for_single_customer_address_response.g.dart';

RetrievesDetailsForSingleCustomerAddressResponse retrievesDetailsForSingleCustomerAddressResponseFromJson(String str) => RetrievesDetailsForSingleCustomerAddressResponse.fromJson(json.decode(str));

String retrievesDetailsForSingleCustomerAddressResponseToJson(RetrievesDetailsForSingleCustomerAddressResponse data) => json.encode(data.toJson());

@freezed
class RetrievesDetailsForSingleCustomerAddressResponse with _$RetrievesDetailsForSingleCustomerAddressResponse {
    const factory RetrievesDetailsForSingleCustomerAddressResponse({
        @JsonKey(name: "customer_address")
        CustomerAddress? customerAddress,
    }) = _RetrievesDetailsForSingleCustomerAddressResponse;

    factory RetrievesDetailsForSingleCustomerAddressResponse.fromJson(Map<String, dynamic> json) => _$RetrievesDetailsForSingleCustomerAddressResponseFromJson(json);
}

@freezed
class CustomerAddress with _$CustomerAddress {
    const factory CustomerAddress({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "customer_id")
        int? customerId,
        @JsonKey(name: "company")
        dynamic company,
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
