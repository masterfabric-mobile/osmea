// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_contracts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserContractsResponseImpl _$$GetUserContractsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserContractsResponseImpl(
      contracts: (json['contracts'] as List<dynamic>)
          .map((e) => UserContractDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetUserContractsResponseImplToJson(
        _$GetUserContractsResponseImpl instance) =>
    <String, dynamic>{
      'contracts': instance.contracts.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

_$UserContractDetailImpl _$$UserContractDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$UserContractDetailImpl(
      id: (json['id'] as num).toInt(),
      contractType: json['contract_type'] as String,
      contractTitle: json['contract_title'] as String,
      contractContent: json['contract_content'] as String?,
      signatureData: json['signature_data'] as Map<String, dynamic>?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      signedAt: json['signed_at'] as String,
    );

Map<String, dynamic> _$$UserContractDetailImplToJson(
    _$UserContractDetailImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'contract_type': instance.contractType,
    'contract_title': instance.contractTitle,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('contract_content', instance.contractContent);
  writeNotNull('signature_data', instance.signatureData);
  writeNotNull('ip_address', instance.ipAddress);
  writeNotNull('user_agent', instance.userAgent);
  val['signed_at'] = instance.signedAt;
  return val;
}

_$CreateContractSignatureResponseImpl
    _$$CreateContractSignatureResponseImplFromJson(Map<String, dynamic> json) =>
        _$CreateContractSignatureResponseImpl(
          success: json['success'] as bool,
          contractId: (json['contract_id'] as num).toInt(),
          message: json['message'] as String,
        );

Map<String, dynamic> _$$CreateContractSignatureResponseImplToJson(
        _$CreateContractSignatureResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'contract_id': instance.contractId,
      'message': instance.message,
    };
