import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_list_refund_response.freezed.dart';
part 'get_list_refund_response.g.dart';

GetListRefundResponse getListRefundResponseFromJson(String str) =>
    GetListRefundResponse.fromJson(json.decode(str));

String getListRefundResponseToJson(GetListRefundResponse data) =>
    json.encode(data.toJson());

@freezed
class GetListRefundResponse with _$GetListRefundResponse {
  const factory GetListRefundResponse({
    @JsonKey(name: "refunds") List<Refund>? refunds,
  }) = _GetListRefundResponse;

  factory GetListRefundResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListRefundResponseFromJson(json);
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
    @JsonKey(name: "duties") List<dynamic>? duties,
    @JsonKey(name: "total_duties_set") Set? totalDutiesSet,
    @JsonKey(name: "return") dynamic refundReturn,
    @JsonKey(name: "restock") bool? restock,
    @JsonKey(name: "refund_shipping_lines") List<dynamic>? refundShippingLines,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "order_adjustments") List<dynamic>? orderAdjustments,
    @JsonKey(name: "refund_line_items") List<RefundLineItem>? refundLineItems,
    @JsonKey(name: "transactions") List<Transaction>? transactions,
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
    @JsonKey(name: "subtotal") double? subtotal,
    @JsonKey(name: "total_tax") double? totalTax,
    @JsonKey(name: "subtotal_set") Set? subtotalSet,
    @JsonKey(name: "total_tax_set") Set? totalTaxSet,
    @JsonKey(name: "line_item") LineItem? lineItem,
  }) = _RefundLineItem;

  factory RefundLineItem.fromJson(Map<String, dynamic> json) =>
      _$RefundLineItemFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "variant_id") int? variantId,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "variant_title") dynamic variantTitle,
    @JsonKey(name: "vendor") String? vendor,
    @JsonKey(name: "fulfillment_service") String? fulfillmentService,
    @JsonKey(name: "product_id") int? productId,
    @JsonKey(name: "requires_shipping") bool? requiresShipping,
    @JsonKey(name: "taxable") bool? taxable,
    @JsonKey(name: "gift_card") bool? giftCard,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "variant_inventory_management")
    String? variantInventoryManagement,
    @JsonKey(name: "properties") List<dynamic>? properties,
    @JsonKey(name: "product_exists") bool? productExists,
    @JsonKey(name: "fulfillable_quantity") int? fulfillableQuantity,
    @JsonKey(name: "grams") int? grams,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "total_discount") String? totalDiscount,
    @JsonKey(name: "fulfillment_status") dynamic fulfillmentStatus,
    @JsonKey(name: "price_set") Set? priceSet,
    @JsonKey(name: "total_discount_set") Set? totalDiscountSet,
    @JsonKey(name: "discount_allocations") List<dynamic>? discountAllocations,
    @JsonKey(name: "duties") List<dynamic>? duties,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "tax_lines") List<TaxLine>? taxLines,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

@freezed
class Set with _$Set {
  const factory Set({
    @JsonKey(name: "shop_money") TotalDutiesSetPresentmentMoney? shopMoney,
    @JsonKey(name: "presentment_money")
    TotalDutiesSetPresentmentMoney? presentmentMoney,
  }) = _Set;

  factory Set.fromJson(Map<String, dynamic> json) => _$SetFromJson(json);
}

@freezed
class TotalDutiesSetPresentmentMoney with _$TotalDutiesSetPresentmentMoney {
  const factory TotalDutiesSetPresentmentMoney({
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "currency_code") String? currencyCode,
  }) = _TotalDutiesSetPresentmentMoney;

  factory TotalDutiesSetPresentmentMoney.fromJson(Map<String, dynamic> json) =>
      _$TotalDutiesSetPresentmentMoneyFromJson(json);
}

@freezed
class TaxLine with _$TaxLine {
  const factory TaxLine({
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "rate") double? rate,
    @JsonKey(name: "channel_liable") bool? channelLiable,
    @JsonKey(name: "price_set") Set? priceSet,
  }) = _TaxLine;

  factory TaxLine.fromJson(Map<String, dynamic> json) =>
      _$TaxLineFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "kind") String? kind,
    @JsonKey(name: "gateway") String? gateway,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "test") bool? test,
    @JsonKey(name: "authorization") dynamic authorization,
    @JsonKey(name: "location_id") dynamic locationId,
    @JsonKey(name: "user_id") int? userId,
    @JsonKey(name: "parent_id") int? parentId,
    @JsonKey(name: "processed_at") String? processedAt,
    @JsonKey(name: "device_id") dynamic deviceId,
    @JsonKey(name: "error_code") dynamic errorCode,
    @JsonKey(name: "source_name") String? sourceName,
    @JsonKey(name: "payment_details") PaymentDetails? paymentDetails,
    @JsonKey(name: "receipt") Receipt? receipt,
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "payment_id") String? paymentId,
    @JsonKey(name: "total_unsettled_set") TotalUnsettledSet? totalUnsettledSet,
    @JsonKey(name: "manual_payment_gateway") bool? manualPaymentGateway,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
class PaymentDetails with _$PaymentDetails {
  const factory PaymentDetails({
    @JsonKey(name: "credit_card_bin") String? creditCardBin,
    @JsonKey(name: "avs_result_code") dynamic avsResultCode,
    @JsonKey(name: "cvv_result_code") dynamic cvvResultCode,
    @JsonKey(name: "credit_card_number") String? creditCardNumber,
    @JsonKey(name: "credit_card_company") String? creditCardCompany,
    @JsonKey(name: "buyer_action_info") dynamic buyerActionInfo,
    @JsonKey(name: "credit_card_name") String? creditCardName,
    @JsonKey(name: "credit_card_wallet") dynamic creditCardWallet,
    @JsonKey(name: "credit_card_expiration_month")
    int? creditCardExpirationMonth,
    @JsonKey(name: "credit_card_expiration_year") int? creditCardExpirationYear,
    @JsonKey(name: "payment_method_name") String? paymentMethodName,
  }) = _PaymentDetails;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);
}

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    @JsonKey(name: "paid_amount") String? paidAmount,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}

@freezed
class TotalUnsettledSet with _$TotalUnsettledSet {
  const factory TotalUnsettledSet({
    @JsonKey(name: "presentment_money")
    TotalUnsettledSetPresentmentMoney? presentmentMoney,
    @JsonKey(name: "shop_money") TotalUnsettledSetPresentmentMoney? shopMoney,
  }) = _TotalUnsettledSet;

  factory TotalUnsettledSet.fromJson(Map<String, dynamic> json) =>
      _$TotalUnsettledSetFromJson(json);
}

@freezed
class TotalUnsettledSetPresentmentMoney
    with _$TotalUnsettledSetPresentmentMoney {
  const factory TotalUnsettledSetPresentmentMoney({
    @JsonKey(name: "amount") String? amount,
    @JsonKey(name: "currency") String? currency,
  }) = _TotalUnsettledSetPresentmentMoney;

  factory TotalUnsettledSetPresentmentMoney.fromJson(
          Map<String, dynamic> json) =>
      _$TotalUnsettledSetPresentmentMoneyFromJson(json);
}
