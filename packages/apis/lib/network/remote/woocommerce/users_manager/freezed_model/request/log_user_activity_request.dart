import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_user_activity_request.freezed.dart';
part 'log_user_activity_request.g.dart';

/// 📊 Log User Activity Request Model
@freezed
class LogUserActivityRequest with _$LogUserActivityRequest {
  const factory LogUserActivityRequest({
    @JsonKey(name: 'activity_type') required String activityType,
    @JsonKey(name: 'activity_description') String? activityDescription,
    @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
  }) = _LogUserActivityRequest;

  factory LogUserActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$LogUserActivityRequestFromJson(json);
}
