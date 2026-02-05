// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_address_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateUserAddressRequestImpl _$$CreateUserAddressRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateUserAddressRequestImpl(
      addressType: json['address_type'] as String,
      label: json['label'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      company: json['company'] as String?,
      address1: json['address_1'] as String,
      address2: json['address_2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      isDefault: json['is_default'] as bool?,
    );

Map<String, dynamic> _$$CreateUserAddressRequestImplToJson(
    _$CreateUserAddressRequestImpl instance) {
  final val = <String, dynamic>{
    'address_type': instance.addressType,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('label', instance.label);
  val['first_name'] = instance.firstName;
  val['last_name'] = instance.lastName;
  writeNotNull('company', instance.company);
  val['address_1'] = instance.address1;
  writeNotNull('address_2', instance.address2);
  val['city'] = instance.city;
  writeNotNull('state', instance.state);
  writeNotNull('postcode', instance.postcode);
  val['country'] = instance.country;
  writeNotNull('email', instance.email);
  writeNotNull('phone', instance.phone);
  writeNotNull('is_default', instance.isDefault);
  return val;
}
