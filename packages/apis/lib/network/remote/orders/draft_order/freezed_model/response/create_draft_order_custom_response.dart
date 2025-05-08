import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_draft_order_custom_response.freezed.dart';
part 'create_draft_order_custom_response.g.dart';

CreateDraftOrderCustomResponse createDraftOrderCustomResponseFromJson(
        String str) =>
    CreateDraftOrderCustomResponse.fromJson(json.decode(str));

String createDraftOrderCustomResponseToJson(
        CreateDraftOrderCustomResponse data) =>
    json.encode(data.toJson());

@freezed
class CreateDraftOrderCustomResponse with _$CreateDraftOrderCustomResponse {
  const factory CreateDraftOrderCustomResponse({
    @JsonKey(name: "draft_order") DraftOrder? draftOrder,
  }) = _CreateDraftOrderCustomResponse;

  factory CreateDraftOrderCustomResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateDraftOrderCustomResponseFromJson(json);
}

@freezed
class DraftOrder with _$DraftOrder {
  const factory DraftOrder({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "note") dynamic note,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "taxes_included") bool? taxesIncluded,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "invoice_sent_at") dynamic invoiceSentAt,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "tax_exempt") bool? taxExempt,
    @JsonKey(name: "completed_at") dynamic completedAt,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "line_items") List<LineItem>? lineItems,
    @JsonKey(name: "shipping_address") Address? shippingAddress,
    @JsonKey(name: "billing_address") Address? billingAddress,
    @JsonKey(name: "invoice_url") String? invoiceUrl,
    @JsonKey(name: "applied_discount") dynamic appliedDiscount,
    @JsonKey(name: "order_id") dynamic orderId,
    @JsonKey(name: "shipping_line") dynamic shippingLine,
    @JsonKey(name: "tax_lines") List<dynamic>? taxLines,
    @JsonKey(name: "tags") String? tags,
    @JsonKey(name: "note_attributes") List<dynamic>? noteAttributes,
    @JsonKey(name: "total_price") String? totalPrice,
    @JsonKey(name: "subtotal_price") String? subtotalPrice,
    @JsonKey(name: "total_tax") String? totalTax,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "customer") Customer? customer,
  }) = _DraftOrder;

  factory DraftOrder.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    @JsonKey(name: "first_name") dynamic firstName,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "city") String? city,
    @JsonKey(name: "zip") String? zip,
    @JsonKey(name: "province") String? province,
    @JsonKey(name: "country") String? country,
    @JsonKey(name: "last_name") dynamic lastName,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "company") dynamic company,
    @JsonKey(name: "latitude") dynamic latitude,
    @JsonKey(name: "longitude") dynamic longitude,
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
class LineItem with _$LineItem {
  const factory LineItem({
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
    @JsonKey(name: "tax_lines") List<dynamic>? taxLines,
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
