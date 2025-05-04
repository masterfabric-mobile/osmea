// To parse this JSON data, do
//
//     final createNewCustomerRecordRequest = createNewCustomerRecordRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_new_customer_record_request.freezed.dart';
part 'create_new_customer_record_request.g.dart';

CreateNewCustomerRecordRequest createNewCustomerRecordRequestFromJson(String str) => CreateNewCustomerRecordRequest.fromJson(json.decode(str));

String createNewCustomerRecordRequestToJson(CreateNewCustomerRecordRequest data) => json.encode(data.toJson());

@freezed
class CreateNewCustomerRecordRequest with _$CreateNewCustomerRecordRequest {
    const factory CreateNewCustomerRecordRequest({
        @JsonKey(name: "customer")
        Customer? customer,
        @JsonKey(name: "errors")
        Errors? errors,
    }) = _CreateNewCustomerRecordRequest;

    factory CreateNewCustomerRecordRequest.fromJson(Map<String, dynamic> json) => _$CreateNewCustomerRecordRequestFromJson(json);
}

@freezed
class Customer with _$Customer {
    const factory Customer({
        @JsonKey(name: "first_name")
        String? firstName,
        @JsonKey(name: "last_name")
        String? lastName,
        @JsonKey(name: "email")
        String? email,
        @JsonKey(name: "phone")
        String? phone,
        @JsonKey(name: "verified_email")
        bool? verifiedEmail,
        @JsonKey(name: "addresses")
        List<Address>? addresses,
    }) = _Customer;

    factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
class Address with _$Address {
    const factory Address({
        @JsonKey(name: "address1")
        String? address1,
        @JsonKey(name: "city")
        String? city,
        @JsonKey(name: "province")
        String? province,
        @JsonKey(name: "phone")
        String? phone,
        @JsonKey(name: "zip")
        String? zip,
        @JsonKey(name: "last_name")
        String? lastName,
        @JsonKey(name: "first_name")
        String? firstName,
        @JsonKey(name: "country")
        String? country,
    }) = _Address;

    factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "base")
        List<String>? base,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
