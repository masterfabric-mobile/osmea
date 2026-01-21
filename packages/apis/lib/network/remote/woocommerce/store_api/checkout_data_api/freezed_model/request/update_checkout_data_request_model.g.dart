// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_checkout_data_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateCheckoutDataRequestModelImpl
    _$$UpdateCheckoutDataRequestModelImplFromJson(Map<String, dynamic> json) =>
        _$UpdateCheckoutDataRequestModelImpl(
          additionalFields: json['additional_fields'] == null
              ? null
              : AdditionalFields.fromJson(
                  json['additional_fields'] as Map<String, dynamic>),
          paymentMethod: json['payment_method'] as String?,
          orderNotes: json['order_notes'] as String?,
          billingAddress: json['billing_address'] == null
              ? null
              : IngAddress.fromJson(
                  json['billing_address'] as Map<String, dynamic>),
          shippingAddress: json['shipping_address'] == null
              ? null
              : IngAddress.fromJson(
                  json['shipping_address'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$UpdateCheckoutDataRequestModelImplToJson(
    _$UpdateCheckoutDataRequestModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('additional_fields', instance.additionalFields?.toJson());
  writeNotNull('payment_method', instance.paymentMethod);
  writeNotNull('order_notes', instance.orderNotes);
  writeNotNull('billing_address', instance.billingAddress?.toJson());
  writeNotNull('shipping_address', instance.shippingAddress?.toJson());
  return val;
}

_$AdditionalFieldsImpl _$$AdditionalFieldsImplFromJson(
        Map<String, dynamic> json) =>
    _$AdditionalFieldsImpl(
      pluginNamespaceLeaveOnPorch:
          json['plugin-namespace/leave-on-porch'] as bool?,
      pluginNamespaceLocationOnPorch:
          json['plugin-namespace/location-on-porch'] as String?,
    );

Map<String, dynamic> _$$AdditionalFieldsImplToJson(
    _$AdditionalFieldsImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'plugin-namespace/leave-on-porch', instance.pluginNamespaceLeaveOnPorch);
  writeNotNull('plugin-namespace/location-on-porch',
      instance.pluginNamespaceLocationOnPorch);
  return val;
}

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
