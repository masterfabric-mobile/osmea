import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_metadata_response.freezed.dart';
part 'update_user_metadata_response.g.dart';

/// ✅ Update User Metadata Response Model
@freezed
class UpdateUserMetadataResponse with _$UpdateUserMetadataResponse {
  const factory UpdateUserMetadataResponse({
    required bool success,
    required List<String> updated,
    String? message,
    List<String>? errors,
  }) = _UpdateUserMetadataResponse;

  factory UpdateUserMetadataResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserMetadataResponseFromJson(json);
}
