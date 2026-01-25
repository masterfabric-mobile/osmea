import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_metadata_request.freezed.dart';
part 'update_user_metadata_request.g.dart';

/// 📝 Update User Metadata Request Model
/// This is a Map<String, dynamic> wrapper for metadata updates
@freezed
class UpdateUserMetadataRequest with _$UpdateUserMetadataRequest {
  const factory UpdateUserMetadataRequest({
    required Map<String, dynamic> metadata,
  }) = _UpdateUserMetadataRequest;

  factory UpdateUserMetadataRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserMetadataRequestFromJson(json);
}
