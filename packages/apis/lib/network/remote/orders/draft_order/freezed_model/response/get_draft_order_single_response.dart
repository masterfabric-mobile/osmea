import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_draft_order_single_response.freezed.dart';
part 'get_draft_order_single_response.g.dart';

GetDraftOrderSingleResponse getDraftOrderSingleResponseFromJson(String str) =>
    GetDraftOrderSingleResponse.fromJson(json.decode(str));

String getDraftOrderSingleResponseToJson(GetDraftOrderSingleResponse data) =>
    json.encode(data.toJson());

@freezed
class GetDraftOrderSingleResponse with _$GetDraftOrderSingleResponse {
  const factory GetDraftOrderSingleResponse({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _GetDraftOrderSingleResponse;

  factory GetDraftOrderSingleResponse.fromJson(Map<String, dynamic> json) =>
      _$GetDraftOrderSingleResponseFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "invoice_sent_at") String? invoiceSentAt,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "completed_at") String? completedAt,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "allow_discount_codes_in_checkout?")
    bool? allowDiscountCodesInCheckout,
    @JsonKey(name: "b2b?") bool? b2B,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "api_client_id") int? apiClientId,
    @JsonKey(name: "shipping_address") ShippingAddress? shippingAddress,
    @JsonKey(name: "billing_address") dynamic billingAddress,
    @JsonKey(name: "invoice_url") String? invoiceUrl,
    @JsonKey(name: "created_on_api_version_handle")
    String? createdOnApiVersionHandle,
    @JsonKey(name: "applied_discount") dynamic appliedDiscount,
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "shipping_line") dynamic shippingLine,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "note_attributes") List<dynamic>? noteAttributes,
    @JsonKey(name: "total_price") String? totalPrice,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "total_tax") String? totalTax,
    @JsonKey(name: "payment_terms") dynamic paymentTerms,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "customer") Customer? customer,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
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
    @JsonKey(name: "tax_exemptions") List<dynamic>? taxExemptions,
    @JsonKey(name: "email_marketing_consent")
    MarketingConsent? emailMarketingConsent,
    @JsonKey(name: "sms_marketing_consent")
    MarketingConsent? smsMarketingConsent,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "default_address") DefaultAddress? defaultAddress,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
class DefaultAddress with _$DefaultAddress {
  const factory DefaultAddress({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "customer_id") int? customerId,
    @JsonKey(name: "company") dynamic company,
    @JsonKey(name: "province") dynamic province,
    @JsonKey(name: "country") String? country,
    @JsonKey(name: "province_code") dynamic provinceCode,
    @JsonKey(name: "country_code") String? countryCode,
    @JsonKey(name: "country_name") String? countryName,
    @JsonKey(name: "default") bool? defaultAddressDefault,
  }) = _DefaultAddress;

  factory DefaultAddress.fromJson(Map<String, dynamic> json) =>
      _$DefaultAddressFromJson(json);
}

@freezed
class MarketingConsent with _$MarketingConsent {
  const factory MarketingConsent({
    @JsonKey(name: "state") String? state,
    @JsonKey(name: "opt_in_level") String? optInLevel,
    @JsonKey(name: "consent_updated_at") dynamic consentUpdatedAt,
    @JsonKey(name: "consent_collected_from") String? consentCollectedFrom,
  }) = _MarketingConsent;

  factory MarketingConsent.fromJson(Map<String, dynamic> json) =>
      _$MarketingConsentFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "variant_id") dynamic variantId,
    @JsonKey(name: "product_id") dynamic productId,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "variant_title") dynamic variantTitle,
    @JsonKey(name: "sku") dynamic sku,
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
class ShippingAddress with _$ShippingAddress {
  const factory ShippingAddress({
    @JsonKey(name: "province") dynamic province,
    @JsonKey(name: "country") dynamic country,
    @JsonKey(name: "country_code") dynamic countryCode,
    @JsonKey(name: "province_code") dynamic provinceCode,
  }) = _ShippingAddress;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);
}
