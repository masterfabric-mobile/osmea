import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_profile_request.freezed.dart';
part 'update_user_profile_request.g.dart';

/// 👤 Update User Profile Request Model
@freezed
class UpdateUserProfileRequest with _$UpdateUserProfileRequest {
  const factory UpdateUserProfileRequest({
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'password') String? password,
    @JsonKey(name: 'billing') Map<String, dynamic>? billing,
    @JsonKey(name: 'shipping') Map<String, dynamic>? shipping,
  }) = _UpdateUserProfileRequest;

  factory UpdateUserProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserProfileRequestFromJson(json);
}
