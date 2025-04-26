// To parse this JSON data, do
//
//     final setsDefaultAddressForCustomerResponse = setsDefaultAddressForCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'sets_default_address_for_customer_response.freezed.dart';
part 'sets_default_address_for_customer_response.g.dart';

SetsDefaultAddressForCustomerResponse setsDefaultAddressForCustomerResponseFromJson(String str) => SetsDefaultAddressForCustomerResponse.fromJson(json.decode(str));

String setsDefaultAddressForCustomerResponseToJson(SetsDefaultAddressForCustomerResponse data) => json.encode(data.toJson());

@freezed
class SetsDefaultAddressForCustomerResponse with _$SetsDefaultAddressForCustomerResponse {
    const factory SetsDefaultAddressForCustomerResponse({
        @JsonKey(name: "customer_address")
        CustomerAddress? customerAddress,
    }) = _SetsDefaultAddressForCustomerResponse;

    factory SetsDefaultAddressForCustomerResponse.fromJson(Map<String, dynamic> json) => _$SetsDefaultAddressForCustomerResponseFromJson(json);
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
