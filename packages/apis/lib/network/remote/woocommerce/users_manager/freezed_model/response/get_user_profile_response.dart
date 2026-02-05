import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_profile_response.freezed.dart';
part 'get_user_profile_response.g.dart';

/// 👤 Get User Profile Response Model
@freezed
class GetUserProfileResponse with _$GetUserProfileResponse {
  const factory GetUserProfileResponse({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'registered_at') required String registeredAt,
    @JsonKey(name: 'statistics') required UserProfileStatistics statistics,
  }) = _GetUserProfileResponse;

  factory GetUserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserProfileResponseFromJson(json);
}

/// 📊 User Profile Statistics Model
@freezed
class UserProfileStatistics with _$UserProfileStatistics {
  const factory UserProfileStatistics({
    @JsonKey(name: 'metadata_count') required int metadataCount,
    @JsonKey(name: 'orders_count') required int ordersCount,
    @JsonKey(name: 'contracts_count') required int contractsCount,
  }) = _UserProfileStatistics;

  factory UserProfileStatistics.fromJson(Map<String, dynamic> json) =>
      _$UserProfileStatisticsFromJson(json);
}
