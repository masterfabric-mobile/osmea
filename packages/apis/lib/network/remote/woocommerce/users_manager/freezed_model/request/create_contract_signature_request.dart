import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_contract_signature_request.freezed.dart';
part 'create_contract_signature_request.g.dart';

/// 📝 Create Contract Signature Request Model
@freezed
class CreateContractSignatureRequest with _$CreateContractSignatureRequest {
  const factory CreateContractSignatureRequest({
    @JsonKey(name: 'contract_type') required String contractType,
    @JsonKey(name: 'contract_title') required String contractTitle,
    @JsonKey(name: 'contract_content') String? contractContent,
    @JsonKey(name: 'signature_data') required Map<String, dynamic> signatureData,
  }) = _CreateContractSignatureRequest;

  factory CreateContractSignatureRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateContractSignatureRequestFromJson(json);
}
