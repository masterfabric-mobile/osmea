// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_addresses_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserAddressesResponseImpl _$$GetUserAddressesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserAddressesResponseImpl(
      addresses: (json['addresses'] as List<dynamic>)
          .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$GetUserAddressesResponseImplToJson(
        _$GetUserAddressesResponseImpl instance) =>
    <String, dynamic>{
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'count': instance.count,
    };

_$AddressOperationResponseImpl _$$AddressOperationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AddressOperationResponseImpl(
      success: json['success'] as bool,
      addressId: (json['address_id'] as num?)?.toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$AddressOperationResponseImplToJson(
    _$AddressOperationResponseImpl instance) {
  final val = <String, dynamic>{
    'success': instance.success,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('address_id', instance.addressId);
  val['message'] = instance.message;
  return val;
}
