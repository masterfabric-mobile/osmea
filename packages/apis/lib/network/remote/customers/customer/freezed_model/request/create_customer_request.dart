// To parse this JSON data, do
//
//     final createCustomerRequest = createCustomerRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_customer_request.freezed.dart';
part 'create_customer_request.g.dart';

CreateCustomerRequest createCustomerRequestFromJson(String str) => CreateCustomerRequest.fromJson(json.decode(str));

String createCustomerRequestToJson(CreateCustomerRequest data) => json.encode(data.toJson());

@freezed
class CreateCustomerRequest with _$CreateCustomerRequest {
    const factory CreateCustomerRequest({
        @JsonKey(name: "customer")
        Customer? customer,
    }) = _CreateCustomerRequest;

    factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) => _$CreateCustomerRequestFromJson(json);
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
        @JsonKey(name: "send_email_invite")
        bool? sendEmailInvite,
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
