// To parse this JSON data, do
//
//     final retrievesTheShopConfigurationResponse = retrievesTheShopConfigurationResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_the_shop_configuration_response.freezed.dart';
part 'retrieves_the_shop_configuration_response.g.dart';

RetrievesTheShopConfigurationResponse
    retrievesTheShopConfigurationResponseFromJson(String str) =>
        RetrievesTheShopConfigurationResponse.fromJson(json.decode(str));

String retrievesTheShopConfigurationResponseToJson(
        RetrievesTheShopConfigurationResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesTheShopConfigurationResponse
    with _$RetrievesTheShopConfigurationResponse {
  const factory RetrievesTheShopConfigurationResponse({
    @JsonKey(name: "shop") Shop? shop,
  }) = _RetrievesTheShopConfigurationResponse;

  factory RetrievesTheShopConfigurationResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesTheShopConfigurationResponseFromJson(json);
}

@freezed
class Shop with _$Shop {
  const factory Shop({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "domain") String? domain,
    @JsonKey(name: "province") dynamic province,
    @JsonKey(name: "country") String? country,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "zip") String? zip,
    @JsonKey(name: "city") String? city,
    @JsonKey(name: "source") dynamic source,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "latitude") double? latitude,
    @JsonKey(name: "longitude") double? longitude,
    @JsonKey(name: "primary_locale") String? primaryLocale,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "country_code") String? countryCode,
    @JsonKey(name: "country_name") String? countryName,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "customer_email") String? customerEmail,
    @JsonKey(name: "timezone") String? timezone,
    @JsonKey(name: "iana_timezone") String? ianaTimezone,
    @JsonKey(name: "shop_owner") String? shopOwner,
    @JsonKey(name: "money_format") String? moneyFormat,
    @JsonKey(name: "money_with_currency_format")
    String? moneyWithCurrencyFormat,
    @JsonKey(name: "weight_unit") String? weightUnit,
    @JsonKey(name: "province_code") dynamic provinceCode,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "auto_configure_tax_inclusivity")
    dynamic autoConfigureTaxInclusivity,
    @JsonKey(name: "tax_shipping") dynamic taxShipping,
    @JsonKey(name: "county_taxes") bool? countyTaxes,
    @JsonKey(name: "plan_display_name") String? planDisplayName,
    @JsonKey(name: "plan_name") String? planName,
    @JsonKey(name: "has_discounts") bool? hasDiscounts,
    @JsonKey(name: "has_gift_cards") bool? hasGiftCards,
    @JsonKey(name: "myshopify_domain") String? myshopifyDomain,
    @JsonKey(name: "google_apps_domain") dynamic googleAppsDomain,
    @JsonKey(name: "google_apps_login_enabled") dynamic googleAppsLoginEnabled,
    @JsonKey(name: "money_in_emails_format") String? moneyInEmailsFormat,
    @JsonKey(name: "money_with_currency_in_emails_format")
    String? moneyWithCurrencyInEmailsFormat,
    @JsonKey(name: "eligible_for_payments") bool? eligibleForPayments,
    @JsonKey(name: "requires_extra_payments_agreement")
    bool? requiresExtraPaymentsAgreement,
    @JsonKey(name: "password_enabled") bool? passwordEnabled,
    @JsonKey(name: "has_storefront") bool? hasStorefront,
    @JsonKey(name: "finances") bool? finances,
    @JsonKey(name: "primary_location_id") int? primaryLocationId,
    @JsonKey(name: "checkout_api_supported") bool? checkoutApiSupported,
    @JsonKey(name: "multi_location_enabled") bool? multiLocationEnabled,
    @JsonKey(name: "setup_required") bool? setupRequired,
    @JsonKey(name: "pre_launch_enabled") bool? preLaunchEnabled,
    @JsonKey(name: "enabled_presentment_currencies")
    List<String>? enabledPresentmentCurrencies,
    @JsonKey(name: "marketing_sms_consent_enabled_at_checkout")
    bool? marketingSmsConsentEnabledAtCheckout,
    @JsonKey(name: "transactional_sms_disabled") bool? transactionalSmsDisabled,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}
