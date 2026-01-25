// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserOrdersResponseImpl _$$GetUserOrdersResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserOrdersResponseImpl(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => UserOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetUserOrdersResponseImplToJson(
        _$GetUserOrdersResponseImpl instance) =>
    <String, dynamic>{
      'orders': instance.orders.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

_$PaginationInfoImpl _$$PaginationInfoImplFromJson(Map<String, dynamic> json) =>
    _$PaginationInfoImpl(
      total: (json['total'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$$PaginationInfoImplToJson(
        _$PaginationInfoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
    };

_$DetailedUserOrderImpl _$$DetailedUserOrderImplFromJson(
        Map<String, dynamic> json) =>
    _$DetailedUserOrderImpl(
      id: (json['id'] as num).toInt(),
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      dateCreated: json['date_created'] as String,
      total: _totalFromJson(json['total']),
      currency: json['currency'] as String,
      paymentMethod: json['payment_method'] as String?,
      billing: json['billing'] == null
          ? null
          : UserBillingAddress.fromJson(
              json['billing'] as Map<String, dynamic>),
      shipping: json['shipping'] == null
          ? null
          : UserShippingAddress.fromJson(
              json['shipping'] as Map<String, dynamic>),
      lineItems: (json['line_items'] as List<dynamic>?)
          ?.map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: json['totals'] == null
          ? null
          : OrderTotals.fromJson(json['totals'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DetailedUserOrderImplToJson(
    _$DetailedUserOrderImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'order_number': instance.orderNumber,
    'status': instance.status,
    'date_created': instance.dateCreated,
    'total': instance.total,
    'currency': instance.currency,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('payment_method', instance.paymentMethod);
  writeNotNull('billing', instance.billing?.toJson());
  writeNotNull('shipping', instance.shipping?.toJson());
  writeNotNull(
      'line_items', instance.lineItems?.map((e) => e.toJson()).toList());
  writeNotNull('totals', instance.totals?.toJson());
  return val;
}

_$UserBillingAddressImpl _$$UserBillingAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$UserBillingAddressImpl(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      company: json['company'] as String?,
      address1: json['address_1'] as String?,
      address2: json['address_2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$UserBillingAddressImplToJson(
    _$UserBillingAddressImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull('company', instance.company);
  writeNotNull('address_1', instance.address1);
  writeNotNull('address_2', instance.address2);
  writeNotNull('city', instance.city);
  writeNotNull('state', instance.state);
  writeNotNull('postcode', instance.postcode);
  writeNotNull('country', instance.country);
  writeNotNull('email', instance.email);
  writeNotNull('phone', instance.phone);
  return val;
}

_$UserShippingAddressImpl _$$UserShippingAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$UserShippingAddressImpl(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      company: json['company'] as String?,
      address1: json['address_1'] as String?,
      address2: json['address_2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$UserShippingAddressImplToJson(
    _$UserShippingAddressImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull('company', instance.company);
  writeNotNull('address_1', instance.address1);
  writeNotNull('address_2', instance.address2);
  writeNotNull('city', instance.city);
  writeNotNull('state', instance.state);
  writeNotNull('postcode', instance.postcode);
  writeNotNull('country', instance.country);
  return val;
}

_$OrderLineItemImpl _$$OrderLineItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderLineItemImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      subtotal: _totalFromJson(json['subtotal']),
      total: _totalFromJson(json['total']),
      productId: (json['product_id'] as num).toInt(),
      productImage: json['product_image'] as String?,
    );

Map<String, dynamic> _$$OrderLineItemImplToJson(_$OrderLineItemImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'quantity': instance.quantity,
    'subtotal': instance.subtotal,
    'total': instance.total,
    'product_id': instance.productId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('product_image', instance.productImage);
  return val;
}

_$OrderTotalsImpl _$$OrderTotalsImplFromJson(Map<String, dynamic> json) =>
    _$OrderTotalsImpl(
      subtotal: _totalFromJson(json['subtotal']),
      shipping: _totalFromJson(json['shipping']),
      tax: _totalFromJson(json['tax']),
      total: _totalFromJson(json['total']),
    );

Map<String, dynamic> _$$OrderTotalsImplToJson(_$OrderTotalsImpl instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'shipping': instance.shipping,
      'tax': instance.tax,
      'total': instance.total,
    };
