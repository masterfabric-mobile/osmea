import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_order_response.freezed.dart';
part 'update_order_response.g.dart';

UpdateOrderResponse updateOrderResponseFromJson(String str) =>
    UpdateOrderResponse.fromJson(json.decode(str));

String updateOrderResponseToJson(UpdateOrderResponse data) =>
    json.encode(data.toJson());

@freezed
class UpdateOrderResponse with _$UpdateOrderResponse {
  const factory UpdateOrderResponse({
    @JsonKey(name: "order") Order? order,
  }) = _UpdateOrderResponse;

  factory UpdateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderResponseFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "app_id") dynamic appId,
    @JsonKey(name: "browser_ip") String? browserIp,
    @JsonKey(name: "buyer_accepts_marketing") bool? buyerAcceptsMarketing,
    @JsonKey(name: "cancel_reason") dynamic cancelReason,
    @JsonKey(name: "cancelled_at") dynamic cancelledAt,
    @JsonKey(name: "cart_token") String? cartToken,
    @JsonKey(name: "checkout_id") int? checkoutId,
    @JsonKey(name: "checkout_token") String? checkoutToken,
    @JsonKey(name: "client_details") ClientDetails? clientDetails,
    @JsonKey(name: "closed_at") dynamic closedAt,
    @JsonKey(name: "confirmation_number") dynamic confirmationNumber,
    @JsonKey(name: "confirmed") bool? confirmed,
    @JsonKey(name: "contact_email") String? contactEmail,
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
    @JsonKey(name: "discount_codes") List<DiscountCode>? discountCodes,
    @JsonKey(name: "duties_included") bool? dutiesIncluded,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "estimated_taxes") bool? estimatedTaxes,
    @JsonKey(name: "financial_status") String? financialStatus,
    @JsonKey(name: "fulfillment_status") dynamic fulfillmentStatus,
    @JsonKey(name: "landing_site") String? landingSite,
    @JsonKey(name: "landing_site_ref") String? landingSiteRef,
    @JsonKey(name: "location_id") dynamic locationId,
    @JsonKey(name: "merchant_business_entity_id")
    String? merchantBusinessEntityId,
    @JsonKey(name: "merchant_of_record_app_id") dynamic merchantOfRecordAppId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "note_attributes") List<NoteAttribute>? noteAttributes,
    @JsonKey(name: "number") int? number,
    @JsonKey(name: "order_number") int? orderNumber,
    @JsonKey(name: "order_status_url") String? orderStatusUrl,
    @JsonKey(name: "original_total_additional_fees_set")
    dynamic originalTotalAdditionalFeesSet,
    @JsonKey(name: "original_total_duties_set") dynamic originalTotalDutiesSet,
    @JsonKey(name: "payment_gateway_names") List<String>? paymentGatewayNames,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "po_number") String? poNumber,
    @JsonKey(name: "presentment_currency") String? presentmentCurrency,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "reference") String? reference,
    @JsonKey(name: "referring_site") String? referringSite,
    @JsonKey(name: "source_identifier") String? sourceIdentifier,
    @JsonKey(name: "source_name") String? sourceName,
    @JsonKey(name: "source_url") dynamic sourceUrl,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "subtotal_price_set") Set? subtotalPriceSet,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "test") bool? test,
    @JsonKey(name: "token") String? token,
    @JsonKey(name: "total_cash_rounding_payment_adjustment_set")
    Set? totalCashRoundingPaymentAdjustmentSet,
    @JsonKey(name: "total_cash_rounding_refund_adjustment_set")
    Set? totalCashRoundingRefundAdjustmentSet,
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
    @JsonKey(name: "billing_address") Address? billingAddress,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "discount_applications")
    List<DiscountApplication>? discountApplications,
    @JsonKey(name: "fulfillments") List<Fulfillment>? fulfillments,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "payment_terms") dynamic paymentTerms,
    @JsonKey(name: "refunds") List<Refund>? refunds,
    @JsonKey(name: "shipping_address") Address? shippingAddress,
    @JsonKey(name: "shipping_lines") List<ShippingLine>? shippingLines,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
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
class ClientDetails with _$ClientDetails {
  const factory ClientDetails({
    @JsonKey(name: "accept_language") dynamic acceptLanguage,
    @JsonKey(name: "browser_height") dynamic browserHeight,
    @JsonKey(name: "browser_ip") String? browserIp,
    @JsonKey(name: "browser_width") dynamic browserWidth,
    @JsonKey(name: "session_hash") dynamic sessionHash,
    @JsonKey(name: "user_agent") dynamic userAgent,
  }) = _ClientDetails;

  factory ClientDetails.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailsFromJson(json);
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
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "first_name") String? firstName,
    @JsonKey(name: "last_name") String? lastName,
    @JsonKey(name: "state") String? state,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "verified_email") bool? verifiedEmail,
    @JsonKey(name: "multipass_identifier") dynamic multipassIdentifier,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "email_marketing_consent")
    MarketingConsent? emailMarketingConsent,
    @JsonKey(name: "sms_marketing_consent")
    MarketingConsent? smsMarketingConsent,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "tax_exemptions") List<dynamic>? taxExemptions,
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
class DiscountApplication with _$DiscountApplication {
  const factory DiscountApplication({
    @JsonKey(name: "target_type") String? targetType,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "value_type") String? valueType,
    @JsonKey(name: "allocation_method") String? allocationMethod,
    @JsonKey(name: "target_selection") String? targetSelection,
    @JsonKey(name: "code") String? code,
  }) = _DiscountApplication;

  factory DiscountApplication.fromJson(Map<String, dynamic> json) =>
      _$DiscountApplicationFromJson(json);
}

@freezed
class DiscountCode with _$DiscountCode {
  const factory DiscountCode({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "type") String? type,
  }) = _DiscountCode;

  factory DiscountCode.fromJson(Map<String, dynamic> json) =>
      _$DiscountCodeFromJson(json);
}

@freezed
class Fulfillment with _$Fulfillment {
  const factory Fulfillment({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "location_id") int? locationId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "origin_address") OriginAddress? originAddress,
    @JsonKey(name: "receipt") Receipt? receipt,
    @JsonKey(name: "service") String? service,
    @JsonKey(name: "shipment_status") dynamic shipmentStatus,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "tracking_company") String? trackingCompany,
    @JsonKey(name: "tracking_number") String? trackingNumber,
    @JsonKey(name: "tracking_numbers") List<String>? trackingNumbers,
    @JsonKey(name: "tracking_url") String? trackingUrl,
    @JsonKey(name: "tracking_urls") List<String>? trackingUrls,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
  }) = _Fulfillment;

  factory Fulfillment.fromJson(Map<String, dynamic> json) =>
      _$FulfillmentFromJson(json);
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
    @JsonKey(name: "properties") List<NoteAttribute>? properties,
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
    @JsonKey(name: "variant_title") String? variantTitle,
    @JsonKey(name: "vendor") dynamic vendor,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "duties") List<dynamic>? duties,
    @JsonKey(name: "discount_allocations")
    List<DiscountAllocation>? discountAllocations,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class DiscountAllocation with _$DiscountAllocation {
  const factory DiscountAllocation({
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "amount_set") Set? amountSet,
    @JsonKey(name: "discount_application_index") int? discountApplicationIndex,
  }) = _DiscountAllocation;

  factory DiscountAllocation.fromJson(Map<String, dynamic> json) =>
      _$DiscountAllocationFromJson(json);
}

@freezed
class NoteAttribute with _$NoteAttribute {
  const factory NoteAttribute({
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "value") String? value,
  }) = _NoteAttribute;

  factory NoteAttribute.fromJson(Map<String, dynamic> json) =>
      _$NoteAttributeFromJson(json);
}

@freezed
class TaxLine with _$TaxLine {
  const factory TaxLine({
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "rate") double? rate,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price_set") Set? priceSet,
    @JsonKey(name: "channel_liable") dynamic channelLiable,
  }) = _TaxLine;

  factory TaxLine.fromJson(Map<String, dynamic> json) =>
      _$TaxLineFromJson(json);
}

@freezed
class OriginAddress with _$OriginAddress {
  const factory OriginAddress() = _OriginAddress;

  factory OriginAddress.fromJson(Map<String, dynamic> json) =>
      _$OriginAddressFromJson(json);
}

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    @JsonKey(name: "testcase") bool? testcase,
    @JsonKey(name: "authorization") String? authorization,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}

@freezed
class Refund with _$Refund {
  const factory Refund({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "restock") bool? restock,
    @JsonKey(name: "total_additional_fees_set") Set? totalAdditionalFeesSet,
    @JsonKey(name: "total_duties_set") Set? totalDutiesSet,
    @JsonKey(name: "user_id") int? userId,
    @JsonKey(name: "order_adjustments") List<dynamic>? orderAdjustments,
    @JsonKey(name: "transactions") List<Transaction>? transactions,
    @JsonKey(name: "refund_line_items") List<RefundLineItem>? refundLineItems,
    @JsonKey(name: "duties") List<dynamic>? duties,
    @JsonKey(name: "additional_fees") List<dynamic>? additionalFees,
  }) = _Refund;

  factory Refund.fromJson(Map<String, dynamic> json) => _$RefundFromJson(json);
}

@freezed
class RefundLineItem with _$RefundLineItem {
  const factory RefundLineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "line_item_id") int? lineItemId,
    @JsonKey(name: "location_id") int? locationId,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "restock_type") String? restockType,
    @JsonKey(name: "subtotal") double? subtotal,
    @JsonKey(name: "subtotal_set") Set? subtotalSet,
    @JsonKey(name: "total_tax") double? totalTax,
    @JsonKey(name: "total_tax_set") Set? totalTaxSet,
    @JsonKey(name: "line_item") LineItem? lineItem,
  }) = _RefundLineItem;

  factory RefundLineItem.fromJson(Map<String, dynamic> json) =>
      _$RefundLineItemFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "authorization") String? authorization,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "device_id") dynamic deviceId,
    @JsonKey(name: "error_code") dynamic errorCode,
    @JsonKey(name: "gateway") String? gateway,
    @JsonKey(name: "kind") String? kind,
    @JsonKey(name: "location_id") dynamic locationId,
    @JsonKey(name: "message") dynamic message,
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "parent_id") int? parentId,
    @JsonKey(name: "payment_id") String? paymentId,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "receipt") OriginAddress? receipt,
    @JsonKey(name: "source_name") String? sourceName,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "test") bool? test,
    @JsonKey(name: "user_id") dynamic userId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
class ShippingLine with _$ShippingLine {
  const factory ShippingLine({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "carrier_identifier") dynamic carrierIdentifier,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "discounted_price") String? discountedPrice,
    @JsonKey(name: "discounted_price_set") Set? discountedPriceSet,
    @JsonKey(name: "is_removed") bool? isRemoved,
    @JsonKey(name: "phone") dynamic phone,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "price_set") Set? priceSet,
    @JsonKey(name: "requested_fulfillment_service_id")
    dynamic requestedFulfillmentServiceId,
    @JsonKey(name: "source") String? source,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "tax_lines") List<dynamic>? taxLines,
    @JsonKey(name: "discount_allocations") List<dynamic>? discountAllocations,
  }) = _ShippingLine;

  factory ShippingLine.fromJson(Map<String, dynamic> json) =>
      _$ShippingLineFromJson(json);
}
