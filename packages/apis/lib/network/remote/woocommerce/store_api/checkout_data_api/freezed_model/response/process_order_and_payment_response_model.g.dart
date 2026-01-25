// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_order_and_payment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProcessPaymentAndOrderResponseModelImpl
    _$$ProcessPaymentAndOrderResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$ProcessPaymentAndOrderResponseModelImpl(
          orderId: (json['order_id'] as num?)?.toInt(),
          status: json['status'] as String?,
          orderKey: json['order_key'] as String?,
          orderNumber: json['order_number'] as String?,
          customerNote: json['customer_note'] as String?,
          customerId: (json['customer_id'] as num?)?.toInt(),
          billingAddress: json['billing_address'] == null
              ? null
              : IngAddress.fromJson(
                  json['billing_address'] as Map<String, dynamic>),
          shippingAddress: json['shipping_address'] == null
              ? null
              : IngAddress.fromJson(
                  json['shipping_address'] as Map<String, dynamic>),
          paymentMethod: json['payment_method'] as String?,
          paymentResult: json['payment_result'] == null
              ? null
              : PaymentResult.fromJson(
                  json['payment_result'] as Map<String, dynamic>),
          additionalFields: json['additional_fields'] == null
              ? null
              : AdditionalFields.fromJson(
                  json['additional_fields'] as Map<String, dynamic>),
          experimentalCart: json['__experimentalCart'],
          extensions: json['extensions'] == null
              ? null
              : AdditionalFields.fromJson(
                  json['extensions'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$ProcessPaymentAndOrderResponseModelImplToJson(
    _$ProcessPaymentAndOrderResponseModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('order_id', instance.orderId);
  writeNotNull('status', instance.status);
  writeNotNull('order_key', instance.orderKey);
  writeNotNull('order_number', instance.orderNumber);
  writeNotNull('customer_note', instance.customerNote);
  writeNotNull('customer_id', instance.customerId);
  writeNotNull('billing_address', instance.billingAddress?.toJson());
  writeNotNull('shipping_address', instance.shippingAddress?.toJson());
  writeNotNull('payment_method', instance.paymentMethod);
  writeNotNull('payment_result', instance.paymentResult?.toJson());
  writeNotNull('additional_fields', instance.additionalFields?.toJson());
  writeNotNull('__experimentalCart', instance.experimentalCart);
  writeNotNull('extensions', instance.extensions?.toJson());
  return val;
}

_$AdditionalFieldsImpl _$$AdditionalFieldsImplFromJson(
        Map<String, dynamic> json) =>
    _$AdditionalFieldsImpl();

Map<String, dynamic> _$$AdditionalFieldsImplToJson(
        _$AdditionalFieldsImpl instance) =>
    <String, dynamic>{};

_$IngAddressImpl _$$IngAddressImplFromJson(Map<String, dynamic> json) =>
    _$IngAddressImpl(
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

Map<String, dynamic> _$$IngAddressImplToJson(_$IngAddressImpl instance) {
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

_$PaymentResultImpl _$$PaymentResultImplFromJson(Map<String, dynamic> json) =>
    _$PaymentResultImpl(
      paymentStatus: json['payment_status'] as String?,
      paymentDetails: (json['payment_details'] as List<dynamic>?)
          ?.map((e) => PaymentDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      redirectUrl: json['redirect_url'] as String?,
    );

Map<String, dynamic> _$$PaymentResultImplToJson(_$PaymentResultImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('payment_status', instance.paymentStatus);
  writeNotNull('payment_details',
      instance.paymentDetails?.map((e) => e.toJson()).toList());
  writeNotNull('redirect_url', instance.redirectUrl);
  return val;
}

_$PaymentDetailImpl _$$PaymentDetailImplFromJson(Map<String, dynamic> json) =>
    _$PaymentDetailImpl(
      key: json['key'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$$PaymentDetailImplToJson(_$PaymentDetailImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('key', instance.key);
  writeNotNull('value', instance.value);
  return val;
}
