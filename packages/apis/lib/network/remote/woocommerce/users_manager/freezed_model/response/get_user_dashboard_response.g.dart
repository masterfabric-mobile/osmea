// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: (json['user_id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      nickname: json['nickname'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      registeredAt: json['registered_at'] as String,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'username': instance.username,
    'email': instance.email,
    'display_name': instance.displayName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull('nickname', instance.nickname);
  writeNotNull('roles', instance.roles);
  val['registered_at'] = instance.registeredAt;
  return val;
}

_$UserAddressImpl _$$UserAddressImplFromJson(Map<String, dynamic> json) =>
    _$UserAddressImpl(
      id: (json['id'] as num).toInt(),
      addressType: json['address_type'] as String,
      label: json['label'] as String?,
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
      isDefault: json['is_default'] as bool,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$UserAddressImplToJson(_$UserAddressImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'address_type': instance.addressType,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('label', instance.label);
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
  val['is_default'] = instance.isDefault;
  writeNotNull('created_at', instance.createdAt);
  writeNotNull('updated_at', instance.updatedAt);
  return val;
}

_$UserPreferenceImpl _$$UserPreferenceImplFromJson(Map<String, dynamic> json) =>
    _$UserPreferenceImpl(
      value: json['value'],
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$UserPreferenceImplToJson(
    _$UserPreferenceImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('value', instance.value);
  writeNotNull('updated_at', instance.updatedAt);
  return val;
}

_$UserContractImpl _$$UserContractImplFromJson(Map<String, dynamic> json) =>
    _$UserContractImpl(
      id: (json['id'] as num).toInt(),
      contractType: json['contract_type'] as String,
      contractTitle: json['contract_title'] as String,
      signedAt: json['signed_at'] as String,
    );

Map<String, dynamic> _$$UserContractImplToJson(_$UserContractImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contract_type': instance.contractType,
      'contract_title': instance.contractTitle,
      'signed_at': instance.signedAt,
    };

_$UserOrderImpl _$$UserOrderImplFromJson(Map<String, dynamic> json) =>
    _$UserOrderImpl(
      id: (json['id'] as num).toInt(),
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      dateCreated: json['date_created'] as String,
      total: _totalFromJson(json['total']),
      currency: json['currency'] as String,
      paymentMethod: json['payment_method'] as String?,
    );

Map<String, dynamic> _$$UserOrderImplToJson(_$UserOrderImpl instance) {
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
  return val;
}

_$UserActivityImpl _$$UserActivityImplFromJson(Map<String, dynamic> json) =>
    _$UserActivityImpl(
      id: (json['id'] as num).toInt(),
      activityType: json['activity_type'] as String,
      activityDescription: json['activity_description'] as String?,
      ipAddress: json['ip_address'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$UserActivityImplToJson(_$UserActivityImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'activity_type': instance.activityType,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('activity_description', instance.activityDescription);
  writeNotNull('ip_address', instance.ipAddress);
  writeNotNull('metadata', instance.metadata);
  val['created_at'] = instance.createdAt;
  return val;
}

_$UserStatisticsImpl _$$UserStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatisticsImpl(
      metadataCount: (json['metadata_count'] as num).toInt(),
      contractsCount: (json['contracts_count'] as num).toInt(),
      addressesCount: (json['addresses_count'] as num).toInt(),
      preferencesCount: (json['preferences_count'] as num).toInt(),
      activityCount: (json['activity_count'] as num).toInt(),
      ordersCount: (json['orders_count'] as num?)?.toInt(),
      ordersTotal: (json['orders_total'] as num?)?.toDouble(),
      ordersByStatus: (json['orders_by_status'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$$UserStatisticsImplToJson(
    _$UserStatisticsImpl instance) {
  final val = <String, dynamic>{
    'metadata_count': instance.metadataCount,
    'contracts_count': instance.contractsCount,
    'addresses_count': instance.addressesCount,
    'preferences_count': instance.preferencesCount,
    'activity_count': instance.activityCount,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('orders_count', instance.ordersCount);
  writeNotNull('orders_total', instance.ordersTotal);
  writeNotNull('orders_by_status', instance.ordersByStatus);
  return val;
}
