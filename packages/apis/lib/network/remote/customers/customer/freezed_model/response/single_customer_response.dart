// To parse this JSON data, do
//
//     final singleCustomerResponse = singleCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'single_customer_response.freezed.dart';
part 'single_customer_response.g.dart';

SingleCustomerResponse singleCustomerResponseFromJson(String str) => SingleCustomerResponse.fromJson(json.decode(str));

String singleCustomerResponseToJson(SingleCustomerResponse data) => json.encode(data.toJson());

@freezed
class SingleCustomerResponse with _$SingleCustomerResponse {
    const factory SingleCustomerResponse({
        @JsonKey(name: "customer")
        required Customer customer,
        @JsonKey(name: "errors")
        required Errors errors,
    }) = _SingleCustomerResponse;

    factory SingleCustomerResponse.fromJson(Map<String, dynamic> json) => _$SingleCustomerResponseFromJson(json);
}

@freezed
class Customer with _$Customer {
    const factory Customer({
        @JsonKey(name: "id")
        required int id,
        @JsonKey(name: "email")
        required String email,
        @JsonKey(name: "accepts_marketing")
        required bool acceptsMarketing,
        @JsonKey(name: "created_at")
        required DateTime createdAt,
        @JsonKey(name: "updated_at")
        required DateTime updatedAt,
        @JsonKey(name: "first_name")
        required String firstName,
        @JsonKey(name: "last_name")
        required String lastName,
        @JsonKey(name: "orders_count")
        required int ordersCount,
        @JsonKey(name: "state")
        required String state,
        @JsonKey(name: "total_spent")
        required String totalSpent,
        @JsonKey(name: "last_order_id")
        required dynamic lastOrderId,
        @JsonKey(name: "note")
        required dynamic note,
        @JsonKey(name: "verified_email")
        required bool verifiedEmail,
        @JsonKey(name: "multipass_identifier")
        required dynamic multipassIdentifier,
        @JsonKey(name: "tax_exempt")
        required bool taxExempt,
        @JsonKey(name: "tags")
        required String tags,
        @JsonKey(name: "last_order_name")
        required dynamic lastOrderName,
        @JsonKey(name: "currency")
        required String currency,
        @JsonKey(name: "phone")
        required String phone,
        @JsonKey(name: "addresses")
        required List<Address> addresses,
        @JsonKey(name: "accepts_marketing_updated_at")
        required DateTime acceptsMarketingUpdatedAt,
        @JsonKey(name: "marketing_opt_in_level")
        required dynamic marketingOptInLevel,
        @JsonKey(name: "tax_exemptions")
        required List<dynamic> taxExemptions,
        @JsonKey(name: "email_marketing_consent")
        required MarketingConsent emailMarketingConsent,
        @JsonKey(name: "sms_marketing_consent")
        required MarketingConsent smsMarketingConsent,
        @JsonKey(name: "admin_graphql_api_id")
        required String adminGraphqlApiId,
        @JsonKey(name: "default_address")
        required Address defaultAddress,
    }) = _Customer;

    factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
class Address with _$Address {
    const factory Address({
        @JsonKey(name: "id")
        required int id,
        @JsonKey(name: "customer_id")
        required int customerId,
        @JsonKey(name: "first_name")
        required String firstName,
        @JsonKey(name: "last_name")
        required String lastName,
        @JsonKey(name: "company")
        required dynamic company,
        @JsonKey(name: "address1")
        required String address1,
        @JsonKey(name: "address2")
        required dynamic address2,
        @JsonKey(name: "city")
        required String city,
        @JsonKey(name: "province")
        required String province,
        @JsonKey(name: "country")
        required String country,
        @JsonKey(name: "zip")
        required String zip,
        @JsonKey(name: "phone")
        required String phone,
        @JsonKey(name: "name")
        required String name,
        @JsonKey(name: "province_code")
        required String provinceCode,
        @JsonKey(name: "country_code")
        required String countryCode,
        @JsonKey(name: "country_name")
        required String countryName,
        @JsonKey(name: "default")
        required bool addressDefault,
    }) = _Address;

    factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

@freezed
class MarketingConsent with _$MarketingConsent {
    const factory MarketingConsent({
        @JsonKey(name: "state")
        required String state,
        @JsonKey(name: "opt_in_level")
        required String optInLevel,
        @JsonKey(name: "consent_updated_at")
        required dynamic consentUpdatedAt,
        @JsonKey(name: "consent_collected_from")
        String? consentCollectedFrom,
    }) = _MarketingConsent;

    factory MarketingConsent.fromJson(Map<String, dynamic> json) => _$MarketingConsentFromJson(json);
}

@freezed
class Errors with _$Errors {
    const factory Errors({
        @JsonKey(name: "base")
        required List<String> base,
    }) = _Errors;

    factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
