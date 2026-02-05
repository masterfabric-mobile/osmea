import 'package:freezed_annotation/freezed_annotation.dart';
import 'get_user_orders_response.dart';
import 'get_user_dashboard_response.dart';

part 'get_user_activity_response.freezed.dart';
part 'get_user_activity_response.g.dart';

/// 📊 Get User Activity Response Model
@freezed
class GetUserActivityResponse with _$GetUserActivityResponse {
  const factory GetUserActivityResponse({
    @JsonKey(name: 'activities') required List<UserActivity> activities,
    @JsonKey(name: 'pagination') required PaginationInfo pagination,
  }) = _GetUserActivityResponse;

  factory GetUserActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserActivityResponseFromJson(json);
}

/// ✅ Log Activity Response Model
@freezed
class LogActivityResponse with _$LogActivityResponse {
  const factory LogActivityResponse({
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'activity_id') required int activityId,
    @JsonKey(name: 'message') required String message,
  }) = _LogActivityResponse;

  factory LogActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$LogActivityResponseFromJson(json);
}
