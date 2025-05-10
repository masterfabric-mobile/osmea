import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_draft_order_modify_existing_response.freezed.dart';
part 'update_draft_order_modify_existing_response.g.dart';

UpdateDraftOrderModifyExistingResponse
    updateDraftOrderModifyExistingResponseFromJson(String str) =>
        UpdateDraftOrderModifyExistingResponse.fromJson(json.decode(str));

String updateDraftOrderModifyExistingResponseToJson(
        UpdateDraftOrderModifyExistingResponse data) =>
    json.encode(data.toJson());

@freezed
class UpdateDraftOrderModifyExistingResponse
    with _$UpdateDraftOrderModifyExistingResponse {
  const factory UpdateDraftOrderModifyExistingResponse({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _UpdateDraftOrderModifyExistingResponse;

  factory UpdateDraftOrderModifyExistingResponse.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateDraftOrderModifyExistingResponseFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "invoice_sent_at") dynamic invoiceSentAt,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "completed_at") dynamic completedAt,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "allow_discount_codes_in_checkout?")
    bool? allowDiscountCodesInCheckout,
    @JsonKey(name: "b2b?") bool? b2B,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "api_client_id") int? apiClientId,
    @JsonKey(name: "shipping_address") Address? shippingAddress,
    @JsonKey(name: "billing_address") Address? billingAddress,
    @JsonKey(name: "invoice_url") String? invoiceUrl,
    @JsonKey(name: "created_on_api_version") dynamic createdOnApiVersion,
    @JsonKey(name: "applied_discount") AppliedDiscount? appliedDiscount,
    @JsonKey(name: "order_id") dynamic orderId,
    @JsonKey(name: "shipping_line") ShippingLine? shippingLine,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "note_attributes") List<dynamic>? noteAttributes,
    @JsonKey(name: "total_price") String? totalPrice,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "total_tax") String? totalTax,
    @JsonKey(name: "payment_terms") dynamic paymentTerms,
    @JsonKey(name: "presentment_currency") String? presentmentCurrency,
    @JsonKey(name: "total_line_items_price_set") Set? totalLineItemsPriceSet,
    @JsonKey(name: "total_price_set") Set? totalPriceSet,
    @JsonKey(name: "subtotal_price_set") Set? subtotalPriceSet,
    @JsonKey(name: "total_tax_set") Set? totalTaxSet,
    @JsonKey(name: "total_discounts_set") Set? totalDiscountsSet,
    @JsonKey(name: "total_shipping_price_set") Set? totalShippingPriceSet,
    @JsonKey(name: "total_additional_fees_set") Set? totalAdditionalFeesSet,
    @JsonKey(name: "total_duties_set") Set? totalDutiesSet,
    @JsonKey(name: "amount_due_now_set") Set? amountDueNowSet,
    @JsonKey(name: "amount_due_later_set") Set? amountDueLaterSet,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "customer") Customer? customer,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class Set with _$Set {
  const factory Set({
    @JsonKey(name: "shop_money") Money? shopMoney,
    @JsonKey(name: "presentment_money") Money? presentmentMoney,
  }) = _Set;

  factory Set.fromJson(Map<String, dynamic> json) => _$SetFromJson(json);
}

@freezed
class Money with _$Money {
  const factory Money({
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "currency_code") String? currencyCode,
  }) = _Money;

  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);
}

@freezed
class AppliedDiscount with _$AppliedDiscount {
  const factory AppliedDiscount({
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "value_type") String? valueType,
  }) = _AppliedDiscount;

  factory AppliedDiscount.fromJson(Map<String, dynamic> json) =>
      _$AppliedDiscountFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "city") String? city,
    @JsonKey(name: "zip") String? zip,
    @JsonKey(name: "province") String? province,
    @JsonKey(name: "country") String? country,
    @JsonKey(name: "last_name") String? lastName,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "company") dynamic company,
    @JsonKey(name: "latitude") double? latitude,
    @JsonKey(name: "longitude") double? longitude,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "country_code") String? countryCode,
    @JsonKey(name: "province_code") String? provinceCode,
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "customer_id") int? customerId,
    @JsonKey(name: "country_name") String? countryName,
    @JsonKey(name: "default") bool? addressDefault,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "last_name") String? lastName,
    @JsonKey(name: "orders_count") int? ordersCount,
    @JsonKey(name: "state") String? state,
    @JsonKey(name: "total_spent") String? totalSpent,
    @JsonKey(name: "last_order_id") int? lastOrderId,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "verified_email") bool? verifiedEmail,
    @JsonKey(name: "multipass_identifier") dynamic multipassIdentifier,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "last_order_name") String? lastOrderName,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "tax_exemptions") List<dynamic>? taxExemptions,
    @JsonKey(name: "email_marketing_consent")
    MarketingConsent? emailMarketingConsent,
    @JsonKey(name: "sms_marketing_consent")
    MarketingConsent? smsMarketingConsent,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "default_address") Address? defaultAddress,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
class MarketingConsent with _$MarketingConsent {
  const factory MarketingConsent({
    @JsonKey(name: "state") String? state,
    @JsonKey(name: "opt_in_level") String? optInLevel,
    @JsonKey(name: "consent_updated_at") String? consentUpdatedAt,
    @JsonKey(name: "consent_collected_from") String? consentCollectedFrom,
  }) = _MarketingConsent;

  factory MarketingConsent.fromJson(Map<String, dynamic> json) =>
      _$MarketingConsentFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "product_id") int? productId,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "variant_title") String? variantTitle,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "vendor") dynamic vendor,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "requires_shipping") bool? requiresShipping,
    @JsonKey(name: "taxable") bool? taxable,
    @JsonKey(name: "gift_card") bool? giftCard,
    @JsonKey(name: "fulfillment_service") String? fulfillmentService,
    @JsonKey(name: "grams") int? grams,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "applied_discount") dynamic appliedDiscount,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "properties") List<dynamic>? properties,
    @JsonKey(name: "custom") bool? custom,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class TaxLine with _$TaxLine {
  const factory TaxLine({
    @JsonKey(name: "rate") double? rate,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
  }) = _TaxLine;

  factory TaxLine.fromJson(Map<String, dynamic> json) =>
      _$TaxLineFromJson(json);
}

@freezed
class ShippingLine with _$ShippingLine {
  const factory ShippingLine({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "custom") bool? custom,
    @JsonKey(name: "handle") dynamic handle,
    @JsonKey(name: "price") String? price,
  }) = _ShippingLine;

  factory ShippingLine.fromJson(Map<String, dynamic> json) =>
      _$ShippingLineFromJson(json);
}
