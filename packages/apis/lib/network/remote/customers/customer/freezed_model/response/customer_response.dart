// To parse this JSON data, do
//
//     final customerResponse = customerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'customer_response.freezed.dart';
part 'customer_response.g.dart';

CustomerResponse customerResponseFromJson(String str) => CustomerResponse.fromJson(json.decode(str));

String customerResponseToJson(CustomerResponse data) => json.encode(data.toJson());

@freezed
class CustomerResponse with _$CustomerResponse {
    const factory CustomerResponse({
        @JsonKey(name: "customers")
        required List<Customer> customers,
    }) = _CustomerResponse;

    factory CustomerResponse.fromJson(Map<String, dynamic> json) => _$CustomerResponseFromJson(json);
}

@freezed
class Customer with _$Customer {
    const factory Customer({
        @JsonKey(name: "id")
        required int id,
        @JsonKey(name: "created_at")
        required DateTime createdAt,
        @JsonKey(name: "updated_at")
        required DateTime updatedAt,
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
        @JsonKey(name: "addresses")
        required List<Address> addresses,
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
        @JsonKey(name: "company")
        required dynamic company,
        @JsonKey(name: "province")
        required String province,
        @JsonKey(name: "country")
        required String country,
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
