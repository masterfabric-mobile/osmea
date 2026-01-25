import 'package:freezed_annotation/freezed_annotation.dart';
import 'get_user_dashboard_response.dart';

part 'get_user_addresses_response.freezed.dart';
part 'get_user_addresses_response.g.dart';

/// 📍 Get User Addresses Response Model
@freezed
class GetUserAddressesResponse with _$GetUserAddressesResponse {
  const factory GetUserAddressesResponse({
    @JsonKey(name: 'addresses') required List<UserAddress> addresses,
    @JsonKey(name: 'count') required int count,
  }) = _GetUserAddressesResponse;

  factory GetUserAddressesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserAddressesResponseFromJson(json);
}

/// ✅ Create/Update/Delete Address Response Model
@freezed
class AddressOperationResponse with _$AddressOperationResponse {
  const factory AddressOperationResponse({
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'address_id') int? addressId,
    @JsonKey(name: 'message') required String message,
  }) = _AddressOperationResponse;

  factory AddressOperationResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressOperationResponseFromJson(json);
}
