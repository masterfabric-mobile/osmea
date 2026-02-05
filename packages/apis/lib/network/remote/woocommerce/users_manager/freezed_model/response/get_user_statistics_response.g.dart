// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserStatisticsResponseImpl _$$GetUserStatisticsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserStatisticsResponseImpl(
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

Map<String, dynamic> _$$GetUserStatisticsResponseImplToJson(
    _$GetUserStatisticsResponseImpl instance) {
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
