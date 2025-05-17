import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_with_pending_customer_response.freezed.dart';
part 'create_order_with_pending_customer_response.g.dart';

CreateOrderWithPendingCustomerResponse
    createOrderWithPendingCustomerResponseFromJson(String str) =>
        CreateOrderWithPendingCustomerResponse.fromJson(json.decode(str));

String createOrderWithPendingCustomerResponseToJson(
        CreateOrderWithPendingCustomerResponse data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderWithPendingCustomerResponse
    with _$CreateOrderWithPendingCustomerResponse {
  const factory CreateOrderWithPendingCustomerResponse({
    @JsonKey(name: "order") Order? order,
  }) = _CreateOrderWithPendingCustomerResponse;

  factory CreateOrderWithPendingCustomerResponse.fromJson(
          Map<String, dynamic> json) =>
      _$CreateOrderWithPendingCustomerResponseFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "app_id") int? appId,
    @JsonKey(name: "browser_ip") dynamic browserIp,
    @JsonKey(name: "buyer_accepts_marketing") bool? buyerAcceptsMarketing,
    @JsonKey(name: "cancel_reason") dynamic cancelReason,
    @JsonKey(name: "cancelled_at") dynamic cancelledAt,
    @JsonKey(name: "cart_token") dynamic cartToken,
    @JsonKey(name: "checkout_id") dynamic checkoutId,
    @JsonKey(name: "checkout_token") dynamic checkoutToken,
    @JsonKey(name: "client_details") dynamic clientDetails,
    @JsonKey(name: "closed_at") dynamic closedAt,
    @JsonKey(name: "confirmation_number") String? confirmationNumber,
    @JsonKey(name: "confirmed") bool? confirmed,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "current_subtotal_price") String? currentSubtotalPrice,
    @JsonKey(name: "current_subtotal_price_set") Set? currentSubtotalPriceSet,
    @JsonKey(name: "current_total_additional_fees_set")
    dynamic currentTotalAdditionalFeesSet,
    @JsonKey(name: "current_total_discounts") String? currentTotalDiscounts,
    @JsonKey(name: "current_total_discounts_set") Set? currentTotalDiscountsSet,
    @JsonKey(name: "current_total_duties_set") dynamic currentTotalDutiesSet,
    @JsonKey(name: "current_total_price") String? currentTotalPrice,
    @JsonKey(name: "current_total_price_set") Set? currentTotalPriceSet,
    @JsonKey(name: "current_total_tax") String? currentTotalTax,
    @JsonKey(name: "current_total_tax_set") Set? currentTotalTaxSet,
    @JsonKey(name: "customer_locale") dynamic customerLocale,
    @JsonKey(name: "device_id") dynamic deviceId,
    @JsonKey(name: "discount_codes") List<dynamic>? discountCodes,
    @JsonKey(name: "estimated_taxes") bool? estimatedTaxes,
    @JsonKey(name: "financial_status") String? financialStatus,
    @JsonKey(name: "fulfillment_status") dynamic fulfillmentStatus,
    @JsonKey(name: "landing_site") dynamic landingSite,
    @JsonKey(name: "landing_site_ref") dynamic landingSiteRef,
    @JsonKey(name: "location_id") dynamic locationId,
    @JsonKey(name: "merchant_of_record_app_id") dynamic merchantOfRecordAppId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "note_attributes") List<dynamic>? noteAttributes,
    @JsonKey(name: "number") int? number,
    @JsonKey(name: "order_number") int? orderNumber,
    @JsonKey(name: "original_total_additional_fees_set")
    dynamic originalTotalAdditionalFeesSet,
    @JsonKey(name: "original_total_duties_set") dynamic originalTotalDutiesSet,
    @JsonKey(name: "payment_gateway_names") List<dynamic>? paymentGatewayNames,
    @JsonKey(name: "po_number") dynamic poNumber,
    @JsonKey(name: "presentment_currency") String? presentmentCurrency,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "reference") dynamic reference,
    @JsonKey(name: "referring_site") dynamic referringSite,
    @JsonKey(name: "source_identifier") dynamic sourceIdentifier,
    @JsonKey(name: "source_name") String? sourceName,
    @JsonKey(name: "source_url") dynamic sourceUrl,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "subtotal_price_set") Set? subtotalPriceSet,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "tax_lines") List<dynamic>? taxLines,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "test") bool? test,
    @JsonKey(name: "token") String? token,
    @JsonKey(name: "total_discounts") String? totalDiscounts,
    @JsonKey(name: "total_discounts_set") Set? totalDiscountsSet,
    @JsonKey(name: "total_line_items_price") String? totalLineItemsPrice,
    @JsonKey(name: "total_line_items_price_set") Set? totalLineItemsPriceSet,
    @JsonKey(name: "total_outstanding") String? totalOutstanding,
    @JsonKey(name: "total_price") String? totalPrice,
    @JsonKey(name: "total_price_set") Set? totalPriceSet,
    @JsonKey(name: "total_shipping_price_set") Set? totalShippingPriceSet,
    @JsonKey(name: "total_tax") String? totalTax,
    @JsonKey(name: "total_tax_set") Set? totalTaxSet,
    @JsonKey(name: "total_tip_received") String? totalTipReceived,
    @JsonKey(name: "total_weight") int? totalWeight,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "billing_address") dynamic billingAddress,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "discount_applications") List<dynamic>? discountApplications,
    @JsonKey(name: "fulfillments") List<dynamic>? fulfillments,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "payment_terms") dynamic paymentTerms,
    @JsonKey(name: "refunds") List<dynamic>? refunds,
    @JsonKey(name: "shipping_address") dynamic shippingAddress,
    @JsonKey(name: "shipping_lines") List<dynamic>? shippingLines,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
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
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "state") String? state,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "verified_email") bool? verifiedEmail,
    @JsonKey(name: "multipass_identifier") dynamic multipassIdentifier,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "email_marketing_consent")
    MarketingConsent? emailMarketingConsent,
    @JsonKey(name: "sms_marketing_consent")
    MarketingConsent? smsMarketingConsent,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "tax_exemptions") List<dynamic>? taxExemptions,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
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
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "attributed_staffs") List<dynamic>? attributedStaffs,
    @JsonKey(name: "current_quantity") int? currentQuantity,
    @JsonKey(name: "fulfillable_quantity") int? fulfillableQuantity,
    @JsonKey(name: "fulfillment_service") String? fulfillmentService,
    @JsonKey(name: "fulfillment_status") dynamic fulfillmentStatus,
    @JsonKey(name: "gift_card") bool? giftCard,
    @JsonKey(name: "grams") int? grams,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "price_set") Set? priceSet,
    @JsonKey(name: "product_exists") bool? productExists,
    @JsonKey(name: "product_id") int? productId,
    @JsonKey(name: "properties") List<dynamic>? properties,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "requires_shipping") bool? requiresShipping,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "taxable") bool? taxable,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "total_discount") String? totalDiscount,
    @JsonKey(name: "total_discount_set") Set? totalDiscountSet,
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "variant_inventory_management")
    String? variantInventoryManagement,
    @JsonKey(name: "variant_title") dynamic variantTitle,
    @JsonKey(name: "vendor") String? vendor,
    @JsonKey(name: "tax_lines") List<dynamic>? taxLines,
    @JsonKey(name: "duties") List<dynamic>? duties,
    @JsonKey(name: "discount_allocations") List<dynamic>? discountAllocations,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}
