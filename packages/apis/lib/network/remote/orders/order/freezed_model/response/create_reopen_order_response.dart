import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_reopen_order_response.freezed.dart';
part 'create_reopen_order_response.g.dart';

CreateReopenOrderResponse createReopenOrderResponseFromJson(String str) =>
    CreateReopenOrderResponse.fromJson(json.decode(str));

String createReopenOrderResponseToJson(CreateReopenOrderResponse data) =>
    json.encode(data.toJson());

@freezed
class CreateReopenOrderResponse with _$CreateReopenOrderResponse {
  const factory CreateReopenOrderResponse({
    @JsonKey(name: "order") Order? order,
  }) = _CreateReopenOrderResponse;

  factory CreateReopenOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateReopenOrderResponseFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "closed_at") dynamic closedAt,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "number") int? number,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "token") String? token,
    @JsonKey(name: "gateway") String? gateway,
    @JsonKey(name: "test") bool? test,
    @JsonKey(name: "total_price") String? totalPrice,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "total_weight") int? totalWeight,
    @JsonKey(name: "total_tax") String? totalTax,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "financial_status") String? financialStatus,
    @JsonKey(name: "confirmed") bool? confirmed,
    @JsonKey(name: "total_discounts") String? totalDiscounts,
    @JsonKey(name: "total_line_items_price") String? totalLineItemsPrice,
    @JsonKey(name: "cart_token") String? cartToken,
    @JsonKey(name: "buyer_accepts_marketing") bool? buyerAcceptsMarketing,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "referring_site") String? referringSite,
    @JsonKey(name: "landing_site") String? landingSite,
    @JsonKey(name: "cancelled_at") dynamic cancelledAt,
    @JsonKey(name: "cancel_reason") dynamic cancelReason,
    @JsonKey(name: "total_price_usd") String? totalPriceUsd,
    @JsonKey(name: "checkout_token") String? checkoutToken,
    @JsonKey(name: "reference") String? reference,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "location_id") dynamic locationId,
    @JsonKey(name: "source_identifier") String? sourceIdentifier,
    @JsonKey(name: "source_url") dynamic sourceUrl,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "device_id") dynamic deviceId,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "customer_locale") dynamic customerLocale,
    @JsonKey(name: "app_id") dynamic appId,
    @JsonKey(name: "browser_ip") String? browserIp,
    @JsonKey(name: "landing_site_ref") String? landingSiteRef,
    @JsonKey(name: "order_number") int? orderNumber,
    @JsonKey(name: "discount_applications")
    List<DiscountApplication>? discountApplications,
    @JsonKey(name: "discount_codes") List<DiscountCode>? discountCodes,
    @JsonKey(name: "note_attributes") List<NoteAttribute>? noteAttributes,
    @JsonKey(name: "payment_gateway_names") List<String>? paymentGatewayNames,
    @JsonKey(name: "processing_method") String? processingMethod,
    @JsonKey(name: "checkout_id") int? checkoutId,
    @JsonKey(name: "source_name") String? sourceName,
    @JsonKey(name: "fulfillment_status") dynamic fulfillmentStatus,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "contact_email") String? contactEmail,
    @JsonKey(name: "order_status_url") String? orderStatusUrl,
    @JsonKey(name: "presentment_currency") String? presentmentCurrency,
    @JsonKey(name: "total_line_items_price_set") Set? totalLineItemsPriceSet,
    @JsonKey(name: "total_discounts_set") Set? totalDiscountsSet,
    @JsonKey(name: "total_shipping_price_set") Set? totalShippingPriceSet,
    @JsonKey(name: "subtotal_price_set") Set? subtotalPriceSet,
    @JsonKey(name: "total_price_set") Set? totalPriceSet,
    @JsonKey(name: "total_tax_set") Set? totalTaxSet,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "shipping_lines") List<ShippingLine>? shippingLines,
    @JsonKey(name: "billing_address") Address? billingAddress,
    @JsonKey(name: "shipping_address") Address? shippingAddress,
    @JsonKey(name: "client_details") ClientDetails? clientDetails,
    @JsonKey(name: "payment_details") PaymentDetails? paymentDetails,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "fulfillments") List<Fulfillment>? fulfillments,
    @JsonKey(name: "refunds") List<Refund>? refunds,
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
    @JsonKey(name: "browser_ip") String? browserIp,
    @JsonKey(name: "accept_language") dynamic acceptLanguage,
    @JsonKey(name: "user_agent") dynamic userAgent,
    @JsonKey(name: "session_hash") dynamic sessionHash,
    @JsonKey(name: "browser_width") dynamic browserWidth,
    @JsonKey(name: "browser_height") dynamic browserHeight,
  }) = _ClientDetails;

  factory ClientDetails.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailsFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "accepts_marketing") bool? acceptsMarketing,
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
    @JsonKey(name: "phone") dynamic phone,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "last_order_name") String? lastOrderName,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "accepts_marketing_updated_at")
    String? acceptsMarketingUpdatedAt,
    @JsonKey(name: "marketing_opt_in_level") dynamic marketingOptInLevel,
    @JsonKey(name: "tax_exemptions") List<dynamic>? taxExemptions,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "default_address") Address? defaultAddress,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
class DiscountApplication with _$DiscountApplication {
  const factory DiscountApplication({
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "value_type") String? valueType,
    @JsonKey(name: "allocation_method") String? allocationMethod,
    @JsonKey(name: "target_selection") String? targetSelection,
    @JsonKey(name: "target_type") String? targetType,
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
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "service") String? service,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "tracking_company") String? trackingCompany,
    @JsonKey(name: "shipment_status") dynamic shipmentStatus,
    @JsonKey(name: "location_id") int? locationId,
    @JsonKey(name: "tracking_number") String? trackingNumber,
    @JsonKey(name: "tracking_numbers") List<String>? trackingNumbers,
    @JsonKey(name: "tracking_url") String? trackingUrl,
    @JsonKey(name: "tracking_urls") List<String>? trackingUrls,
    @JsonKey(name: "receipt") FulfillmentReceipt? receipt,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
  }) = _Fulfillment;

  factory Fulfillment.fromJson(Map<String, dynamic> json) =>
      _$FulfillmentFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "variant_title") String? variantTitle,
    @JsonKey(name: "vendor") dynamic vendor,
    @JsonKey(name: "fulfillment_service") String? fulfillmentService,
    @JsonKey(name: "product_id") int? productId,
    @JsonKey(name: "requires_shipping") bool? requiresShipping,
    @JsonKey(name: "taxable") bool? taxable,
    @JsonKey(name: "gift_card") bool? giftCard,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "variant_inventory_management")
    String? variantInventoryManagement,
    @JsonKey(name: "properties") List<NoteAttribute>? properties,
    @JsonKey(name: "product_exists") bool? productExists,
    @JsonKey(name: "fulfillable_quantity") int? fulfillableQuantity,
    @JsonKey(name: "grams") int? grams,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "total_discount") String? totalDiscount,
    @JsonKey(name: "fulfillment_status") dynamic fulfillmentStatus,
    @JsonKey(name: "price_set") Set? priceSet,
    @JsonKey(name: "total_discount_set") Set? totalDiscountSet,
    @JsonKey(name: "discount_allocations") List<dynamic>? discountAllocations,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
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
  }) = _TaxLine;

  factory TaxLine.fromJson(Map<String, dynamic> json) =>
      _$TaxLineFromJson(json);
}

@freezed
class FulfillmentReceipt with _$FulfillmentReceipt {
  const factory FulfillmentReceipt({
    @JsonKey(name: "testcase") bool? testcase,
    @JsonKey(name: "authorization") String? authorization,
  }) = _FulfillmentReceipt;

  factory FulfillmentReceipt.fromJson(Map<String, dynamic> json) =>
      _$FulfillmentReceiptFromJson(json);
}

@freezed
class PaymentDetails with _$PaymentDetails {
  const factory PaymentDetails({
    @JsonKey(name: "credit_card_bin") dynamic creditCardBin,
    @JsonKey(name: "avs_result_code") dynamic avsResultCode,
    @JsonKey(name: "cvv_result_code") dynamic cvvResultCode,
    @JsonKey(name: "credit_card_number") String? creditCardNumber,
    @JsonKey(name: "credit_card_company") String? creditCardCompany,
  }) = _PaymentDetails;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);
}

@freezed
class Refund with _$Refund {
  const factory Refund({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "user_id") int? userId,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "restock") bool? restock,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "refund_line_items") List<RefundLineItem>? refundLineItems,
    @JsonKey(name: "transactions") List<Transaction>? transactions,
    @JsonKey(name: "order_adjustments") List<dynamic>? orderAdjustments,
  }) = _Refund;

  factory Refund.fromJson(Map<String, dynamic> json) => _$RefundFromJson(json);
}

@freezed
class RefundLineItem with _$RefundLineItem {
  const factory RefundLineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "line_item_id") int? lineItemId,
    @JsonKey(name: "location_id") int? locationId,
    @JsonKey(name: "restock_type") String? restockType,
    @JsonKey(name: "subtotal") int? subtotal,
    @JsonKey(name: "total_tax") double? totalTax,
    @JsonKey(name: "subtotal_set") Set? subtotalSet,
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
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "kind") String? kind,
    @JsonKey(name: "gateway") String? gateway,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "message") dynamic message,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "test") bool? test,
    @JsonKey(name: "authorization") String? authorization,
    @JsonKey(name: "location_id") dynamic locationId,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "parent_id") int? parentId,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "device_id") dynamic deviceId,
    @JsonKey(name: "receipt") TransactionReceipt? receipt,
    @JsonKey(name: "error_code") dynamic errorCode,
    @JsonKey(name: "source_name") String? sourceName,
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
class TransactionReceipt with _$TransactionReceipt {
  const factory TransactionReceipt() = _TransactionReceipt;

  factory TransactionReceipt.fromJson(Map<String, dynamic> json) =>
      _$TransactionReceiptFromJson(json);
}

@freezed
class ShippingLine with _$ShippingLine {
  const factory ShippingLine({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "source") String? source,
    @JsonKey(name: "phone") dynamic phone,
    @JsonKey(name: "requested_fulfillment_service_id")
    dynamic requestedFulfillmentServiceId,
    @JsonKey(name: "delivery_category") dynamic deliveryCategory,
    @JsonKey(name: "carrier_identifier") dynamic carrierIdentifier,
    @JsonKey(name: "discounted_price") String? discountedPrice,
    @JsonKey(name: "price_set") Set? priceSet,
    @JsonKey(name: "discounted_price_set") Set? discountedPriceSet,
    @JsonKey(name: "discount_allocations") List<dynamic>? discountAllocations,
    @JsonKey(name: "tax_lines") List<dynamic>? taxLines,
  }) = _ShippingLine;

  factory ShippingLine.fromJson(Map<String, dynamic> json) =>
      _$ShippingLineFromJson(json);
}
