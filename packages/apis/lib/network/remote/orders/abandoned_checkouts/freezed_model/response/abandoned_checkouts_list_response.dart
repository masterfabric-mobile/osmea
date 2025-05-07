import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'abandoned_checkouts_list_response.freezed.dart';
part 'abandoned_checkouts_list_response.g.dart';

AbandonedCheckoutsListResponse abandonedCheckoutsListResponseFromJson(
        String str) =>
    AbandonedCheckoutsListResponse.fromJson(json.decode(str));

String abandonedCheckoutsListResponseToJson(
        AbandonedCheckoutsListResponse data) =>
    json.encode(data.toJson());

@freezed
class AbandonedCheckoutsListResponse with _$AbandonedCheckoutsListResponse {
  const factory AbandonedCheckoutsListResponse({
    @JsonKey(name: "checkouts") List<Checkout>? checkouts,
  }) = _AbandonedCheckoutsListResponse;

  factory AbandonedCheckoutsListResponse.fromJson(Map<String, dynamic> json) =>
      _$AbandonedCheckoutsListResponseFromJson(json);
}

@freezed
class Checkout with _$Checkout {
  const factory Checkout({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "token") String? token,
    @JsonKey(name: "cart_token") String? cartToken,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "gateway") String? gateway,
    @JsonKey(name: "buyer_accepts_marketing") bool? buyerAcceptsMarketing,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "landing_site") dynamic landingSite,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "note_attributes") List<NoteAttribute>? noteAttributes,
    @JsonKey(name: "referring_site") dynamic referringSite,
    @JsonKey(name: "shipping_lines") List<ShippingLine>? shippingLines,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "total_weight") int? totalWeight,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "completed_at") String? completedAt,
    @JsonKey(name: "closed_at") dynamic closedAt,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "location_id") dynamic locationId,
    @JsonKey(name: "source_identifier") dynamic sourceIdentifier,
    @JsonKey(name: "source_url") dynamic sourceUrl,
    @JsonKey(name: "device_id") dynamic deviceId,
    @JsonKey(name: "phone") dynamic phone,
    @JsonKey(name: "customer_locale") dynamic customerLocale,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "source") dynamic source,
    @JsonKey(name: "abandoned_checkout_url") String? abandonedCheckoutUrl,
    @JsonKey(name: "discount_codes") List<DiscountCode>? discountCodes,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
    @JsonKey(name: "source_name") String? sourceName,
    @JsonKey(name: "presentment_currency") String? presentmentCurrency,
    @JsonKey(name: "total_discounts") String? totalDiscounts,
    @JsonKey(name: "total_line_items_price") String? totalLineItemsPrice,
    @JsonKey(name: "total_price") String? totalPrice,
    @JsonKey(name: "total_tax") String? totalTax,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "billing_address") Address? billingAddress,
    @JsonKey(name: "shipping_address") Address? shippingAddress,
    @JsonKey(name: "customer") Customer? customer,
  }) = _Checkout;

  factory Checkout.fromJson(Map<String, dynamic> json) =>
      _$CheckoutFromJson(json);
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
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "applied_discounts") List<dynamic>? appliedDiscounts,
    @JsonKey(name: "key") dynamic key,
    @JsonKey(name: "destination_location_id") dynamic destinationLocationId,
    @JsonKey(name: "fulfillment_service") String? fulfillmentService,
    @JsonKey(name: "gift_card") bool? giftCard,
    @JsonKey(name: "grams") int? grams,
    @JsonKey(name: "origin_location_id") dynamic originLocationId,
    @JsonKey(name: "product_id") int? productId,
    @JsonKey(name: "properties") dynamic properties,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "requires_shipping") bool? requiresShipping,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "tax_lines") List<dynamic>? taxLines,
    @JsonKey(name: "taxable") bool? taxable,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "variant_title") String? variantTitle,
    @JsonKey(name: "variant_price") dynamic variantPrice,
    @JsonKey(name: "vendor") String? vendor,
    @JsonKey(name: "user_id") dynamic userId,
    @JsonKey(name: "unit_price_measurement") dynamic unitPriceMeasurement,
    @JsonKey(name: "country_hs_codes") List<dynamic>? countryHsCodes,
    @JsonKey(name: "country_code_of_origin") dynamic countryCodeOfOrigin,
    @JsonKey(name: "province_code_of_origin") dynamic provinceCodeOfOrigin,
    @JsonKey(name: "harmonized_system_code") dynamic harmonizedSystemCode,
    @JsonKey(name: "compare_at_price") dynamic compareAtPrice,
    @JsonKey(name: "line_price") String? linePrice,
    @JsonKey(name: "price") String? price,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
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
class ShippingLine with _$ShippingLine {
  const factory ShippingLine({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "source") String? source,
    @JsonKey(name: "applied_discounts") List<dynamic>? appliedDiscounts,
    @JsonKey(name: "id") String? id,
  }) = _ShippingLine;

  factory ShippingLine.fromJson(Map<String, dynamic> json) =>
      _$ShippingLineFromJson(json);
}

@freezed
class TaxLine with _$TaxLine {
  const factory TaxLine({
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "rate") double? rate,
    @JsonKey(name: "title") String? title,
  }) = _TaxLine;

  factory TaxLine.fromJson(Map<String, dynamic> json) =>
      _$TaxLineFromJson(json);
}
