import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_profile_response.freezed.dart';
part 'update_user_profile_response.g.dart';

/// ✅ Update User Profile Response Model
@freezed
class UpdateUserProfileResponse with _$UpdateUserProfileResponse {
  const factory UpdateUserProfileResponse({
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'updated') required List<String> updated,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'errors') List<String>? errors,
  }) = _UpdateUserProfileResponse;

  factory UpdateUserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserProfileResponseFromJson(json);
}
