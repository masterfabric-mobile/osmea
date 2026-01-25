import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_user_metadata_response.freezed.dart';
part 'delete_user_metadata_response.g.dart';

/// 🗑️ Delete User Metadata Response Model
@freezed
class DeleteUserMetadataResponse with _$DeleteUserMetadataResponse {
  const factory DeleteUserMetadataResponse({
    required bool success,
    String? message,
  }) = _DeleteUserMetadataResponse;

  factory DeleteUserMetadataResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserMetadataResponseFromJson(json);
}
