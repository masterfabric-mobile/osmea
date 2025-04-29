// To parse this JSON data, do
//
//     final createNewCustomerRecordResponse = createNewCustomerRecordResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_new_customer_record_response.freezed.dart';
part 'create_new_customer_record_response.g.dart';

CreateNewCustomerRecordResponse createNewCustomerRecordResponseFromJson(String str) => CreateNewCustomerRecordResponse.fromJson(json.decode(str));

String createNewCustomerRecordResponseToJson(CreateNewCustomerRecordResponse data) => json.encode(data.toJson());

@freezed
class CreateNewCustomerRecordResponse with _$CreateNewCustomerRecordResponse {
    const factory CreateNewCustomerRecordResponse({
        @JsonKey(name: "customer")
        Customer? customer,
    }) = _CreateNewCustomerRecordResponse;

    factory CreateNewCustomerRecordResponse.fromJson(Map<String, dynamic> json) => _$CreateNewCustomerRecordResponseFromJson(json);
}

@freezed
class Customer with _$Customer {
    const factory Customer({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "email")
        String? email,
        @JsonKey(name: "accepts_marketing")
        bool? acceptsMarketing,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "first_name")
        String? firstName,
        @JsonKey(name: "last_name")
        String? lastName,
        @JsonKey(name: "orders_count")
        int? ordersCount,
        @JsonKey(name: "state")
        String? state,
        @JsonKey(name: "total_spent")
        String? totalSpent,
        @JsonKey(name: "last_order_id")
        dynamic lastOrderId,
        @JsonKey(name: "note")
        dynamic note,
        @JsonKey(name: "verified_email")
        bool? verifiedEmail,
        @JsonKey(name: "multipass_identifier")
        dynamic multipassIdentifier,
        @JsonKey(name: "tax_exempt")
        bool? taxExempt,
        @JsonKey(name: "tags")
        String? tags,
        @JsonKey(name: "last_order_name")
        dynamic lastOrderName,
        @JsonKey(name: "currency")
        String? currency,
        @JsonKey(name: "phone")
        String? phone,
        @JsonKey(name: "addresses")
        List<Address>? addresses,
        @JsonKey(name: "accepts_marketing_updated_at")
        String? acceptsMarketingUpdatedAt,
        @JsonKey(name: "marketing_opt_in_level")
        dynamic marketingOptInLevel,
        @JsonKey(name: "tax_exemptions")
        List<dynamic>? taxExemptions,
        @JsonKey(name: "email_marketing_consent")
        EmailMarketingConsent? emailMarketingConsent,
        @JsonKey(name: "sms_marketing_consent")
        SmsMarketingConsent? smsMarketingConsent,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
        @JsonKey(name: "default_address")
        Address? defaultAddress,
    }) = _Customer;

    factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
class Address with _$Address {
    const factory Address({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "customer_id")
        int? customerId,
        @JsonKey(name: "first_name")
        String? firstName,
        @JsonKey(name: "last_name")
        String? lastName,
        @JsonKey(name: "company")
        dynamic company,
        @JsonKey(name: "address1")
        String? address1,
        @JsonKey(name: "address2")
        dynamic address2,
        @JsonKey(name: "city")
        String? city,
        @JsonKey(name: "province")
        String? province,
        @JsonKey(name: "country")
        String? country,
        @JsonKey(name: "zip")
        String? zip,
        @JsonKey(name: "phone")
        String? phone,
        @JsonKey(name: "name")
        String? name,
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

@freezed
class EmailMarketingConsent with _$EmailMarketingConsent {
    const factory EmailMarketingConsent({
        @JsonKey(name: "state")
        String? state,
        @JsonKey(name: "opt_in_level")
        String? optInLevel,
        @JsonKey(name: "consent_updated_at")
        dynamic consentUpdatedAt,
    }) = _EmailMarketingConsent;

    factory EmailMarketingConsent.fromJson(Map<String, dynamic> json) => _$EmailMarketingConsentFromJson(json);
}

@freezed
class SmsMarketingConsent with _$SmsMarketingConsent {
    const factory SmsMarketingConsent({
        @JsonKey(name: "state")
        String? state,
        @JsonKey(name: "opt_in_level")
        String? optInLevel,
        @JsonKey(name: "consent_updated_at")
        dynamic consentUpdatedAt,
        @JsonKey(name: "consent_collected_from")
        String? consentCollectedFrom,
    }) = _SmsMarketingConsent;

    factory SmsMarketingConsent.fromJson(Map<String, dynamic> json) => _$SmsMarketingConsentFromJson(json);
}
