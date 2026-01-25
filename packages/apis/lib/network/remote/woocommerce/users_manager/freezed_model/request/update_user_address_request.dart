import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_address_request.freezed.dart';
part 'update_user_address_request.g.dart';

/// 📍 Update User Address Request Model
@freezed
class UpdateUserAddressRequest with _$UpdateUserAddressRequest {
  const factory UpdateUserAddressRequest({
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'address_1') String? address1,
    @JsonKey(name: 'address_2') String? address2,
    @JsonKey(name: 'city') String? city,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'postcode') String? postcode,
    @JsonKey(name: 'country') String? country,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'is_default') bool? isDefault,
  }) = _UpdateUserAddressRequest;

  factory UpdateUserAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserAddressRequestFromJson(json);
}
