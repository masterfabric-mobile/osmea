// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contract_signature_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateContractSignatureRequestImpl
    _$$CreateContractSignatureRequestImplFromJson(Map<String, dynamic> json) =>
        _$CreateContractSignatureRequestImpl(
          contractType: json['contract_type'] as String,
          contractTitle: json['contract_title'] as String,
          contractContent: json['contract_content'] as String?,
          signatureData: json['signature_data'] as Map<String, dynamic>,
        );

Map<String, dynamic> _$$CreateContractSignatureRequestImplToJson(
    _$CreateContractSignatureRequestImpl instance) {
  final val = <String, dynamic>{
    'contract_type': instance.contractType,
    'contract_title': instance.contractTitle,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('contract_content', instance.contractContent);
  val['signature_data'] = instance.signatureData;
  return val;
}
