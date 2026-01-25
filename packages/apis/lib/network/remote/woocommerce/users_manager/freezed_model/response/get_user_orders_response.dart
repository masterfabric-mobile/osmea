import 'package:freezed_annotation/freezed_annotation.dart';
import 'get_user_dashboard_response.dart';

part 'get_user_orders_response.freezed.dart';
part 'get_user_orders_response.g.dart';

/// 🛒 Get User Orders Response Model
@freezed
class GetUserOrdersResponse with _$GetUserOrdersResponse {
  const factory GetUserOrdersResponse({
    @JsonKey(name: 'orders') required List<UserOrder> orders,
    @JsonKey(name: 'pagination') required PaginationInfo pagination,
  }) = _GetUserOrdersResponse;

  factory GetUserOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserOrdersResponseFromJson(json);
}

/// 📄 Pagination Info Model
@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    @JsonKey(name: 'total') required int total,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _PaginationInfo;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
}

/// 🛒 Detailed User Order Model (for single order endpoint)
@freezed
class DetailedUserOrder with _$DetailedUserOrder {
  const factory DetailedUserOrder({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'order_number') required String orderNumber,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'date_created') required String dateCreated,
    @JsonKey(
      name: 'total',
      fromJson: _totalFromJson,
    )
    required double total,
    @JsonKey(name: 'currency') required String currency,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'billing') UserBillingAddress? billing,
    @JsonKey(name: 'shipping') UserShippingAddress? shipping,
    @JsonKey(name: 'line_items') List<OrderLineItem>? lineItems,
    @JsonKey(name: 'totals') OrderTotals? totals,
  }) = _DetailedUserOrder;

  factory DetailedUserOrder.fromJson(Map<String, dynamic> json) =>
      _$DetailedUserOrderFromJson(json);
}

/// 📍 User Billing Address Model
@freezed
class UserBillingAddress with _$UserBillingAddress {
  const factory UserBillingAddress({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'address_1') String? address1,
    @JsonKey(name: 'address_2') String? address2,
    @JsonKey(name: 'city') String? city,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'postcode') String? postcode,
    @JsonKey(name: 'country') String? country,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
  }) = _UserBillingAddress;

  factory UserBillingAddress.fromJson(Map<String, dynamic> json) =>
      _$UserBillingAddressFromJson(json);
}

/// 📍 User Shipping Address Model
@freezed
class UserShippingAddress with _$UserShippingAddress {
  const factory UserShippingAddress({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'address_1') String? address1,
    @JsonKey(name: 'address_2') String? address2,
    @JsonKey(name: 'city') String? city,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'postcode') String? postcode,
    @JsonKey(name: 'country') String? country,
  }) = _UserShippingAddress;

  factory UserShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$UserShippingAddressFromJson(json);
}

/// 🛍️ Order Line Item Model
@freezed
class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'quantity') required int quantity,
    @JsonKey(
      name: 'subtotal',
      fromJson: _totalFromJson,
    )
    required double subtotal,
    @JsonKey(
      name: 'total',
      fromJson: _totalFromJson,
    )
    required double total,
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'product_image') String? productImage,
  }) = _OrderLineItem;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) =>
      _$OrderLineItemFromJson(json);
}

/// 💰 Order Totals Model
@freezed
class OrderTotals with _$OrderTotals {
  const factory OrderTotals({
    @JsonKey(
      name: 'subtotal',
      fromJson: _totalFromJson,
    )
    required double subtotal,
    @JsonKey(
      name: 'shipping',
      fromJson: _totalFromJson,
    )
    required double shipping,
    @JsonKey(
      name: 'tax',
      fromJson: _totalFromJson,
    )
    required double tax,
    @JsonKey(
      name: 'total',
      fromJson: _totalFromJson,
    )
    required double total,
  }) = _OrderTotals;

  factory OrderTotals.fromJson(Map<String, dynamic> json) =>
      _$OrderTotalsFromJson(json);
}

// Helper function to parse total (can be string or number)
double _totalFromJson(dynamic value) {
  if (value is num) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}
