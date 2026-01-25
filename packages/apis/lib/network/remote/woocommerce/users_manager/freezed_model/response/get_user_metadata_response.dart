import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_metadata_response.freezed.dart';
part 'get_user_metadata_response.g.dart';

/// 📋 User Metadata Response Model
@freezed
class GetUserMetadataResponse with _$GetUserMetadataResponse {
  const factory GetUserMetadataResponse({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'metadata') required Map<String, UserMetadataItem> metadata,
    @JsonKey(name: 'count') required int count,
  }) = _GetUserMetadataResponse;

  factory GetUserMetadataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserMetadataResponseFromJson(json);
}

/// 📋 User Metadata Item Model
@freezed
class UserMetadataItem with _$UserMetadataItem {
  const factory UserMetadataItem({
    @JsonKey(name: 'value') required dynamic value,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserMetadataItem;

  factory UserMetadataItem.fromJson(Map<String, dynamic> json) =>
      _$UserMetadataItemFromJson(json);
}
