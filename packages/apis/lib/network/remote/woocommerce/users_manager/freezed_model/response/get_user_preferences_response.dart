import 'package:freezed_annotation/freezed_annotation.dart';
import 'get_user_dashboard_response.dart';

part 'get_user_preferences_response.freezed.dart';
part 'get_user_preferences_response.g.dart';

/// ⚙️ Get User Preferences Response Model
@freezed
class GetUserPreferencesResponse with _$GetUserPreferencesResponse {
  const factory GetUserPreferencesResponse({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'preferences') required Map<String, UserPreference> preferences,
    @JsonKey(name: 'count') required int count,
  }) = _GetUserPreferencesResponse;

  factory GetUserPreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserPreferencesResponseFromJson(json);
}

/// ✅ Update Preferences Response Model
@freezed
class UpdatePreferencesResponse with _$UpdatePreferencesResponse {
  const factory UpdatePreferencesResponse({
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'updated') required List<String> updated,
    @JsonKey(name: 'message') required String message,
  }) = _UpdatePreferencesResponse;

  factory UpdatePreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePreferencesResponseFromJson(json);
}
