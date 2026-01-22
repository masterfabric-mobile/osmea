import 'package:freezed_annotation/freezed_annotation.dart';
import 'get_user_orders_response.dart';

part 'get_user_contracts_response.freezed.dart';
part 'get_user_contracts_response.g.dart';

/// 📝 Get User Contracts Response Model
@freezed
class GetUserContractsResponse with _$GetUserContractsResponse {
  const factory GetUserContractsResponse({
    @JsonKey(name: 'contracts') required List<UserContractDetail> contracts,
    @JsonKey(name: 'pagination') required PaginationInfo pagination,
  }) = _GetUserContractsResponse;

  factory GetUserContractsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserContractsResponseFromJson(json);
}

/// 📝 Detailed User Contract Model
@freezed
class UserContractDetail with _$UserContractDetail {
  const factory UserContractDetail({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'contract_type') required String contractType,
    @JsonKey(name: 'contract_title') required String contractTitle,
    @JsonKey(name: 'contract_content') String? contractContent,
    @JsonKey(name: 'signature_data') Map<String, dynamic>? signatureData,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'user_agent') String? userAgent,
    @JsonKey(name: 'signed_at') required String signedAt,
  }) = _UserContractDetail;

  factory UserContractDetail.fromJson(Map<String, dynamic> json) =>
      _$UserContractDetailFromJson(json);
}

/// ✅ Create Contract Signature Response Model
@freezed
class CreateContractSignatureResponse with _$CreateContractSignatureResponse {
  const factory CreateContractSignatureResponse({
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'contract_id') required int contractId,
    @JsonKey(name: 'message') required String message,
  }) = _CreateContractSignatureResponse;

  factory CreateContractSignatureResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateContractSignatureResponseFromJson(json);
}
