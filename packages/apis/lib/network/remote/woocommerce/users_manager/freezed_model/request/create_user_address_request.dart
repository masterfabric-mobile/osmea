import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_address_request.freezed.dart';
part 'create_user_address_request.g.dart';

/// 📍 Create User Address Request Model
@freezed
class CreateUserAddressRequest with _$CreateUserAddressRequest {
  const factory CreateUserAddressRequest({
    @JsonKey(name: 'address_type') required String addressType,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'address_1') required String address1,
    @JsonKey(name: 'address_2') String? address2,
    @JsonKey(name: 'city') required String city,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'postcode') String? postcode,
    @JsonKey(name: 'country') required String country,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'is_default') bool? isDefault,
  }) = _CreateUserAddressRequest;

  factory CreateUserAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserAddressRequestFromJson(json);
}
