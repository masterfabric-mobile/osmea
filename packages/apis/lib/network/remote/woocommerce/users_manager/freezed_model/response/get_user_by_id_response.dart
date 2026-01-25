import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_by_id_response.freezed.dart';
part 'get_user_by_id_response.g.dart';

/// 👤 Get User By ID Response Model (Admin)
@freezed
class GetUserByIdResponse with _$GetUserByIdResponse {
  const factory GetUserByIdResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'roles') required List<String> roles,
    @JsonKey(name: 'registered_at') required String registeredAt,
    @JsonKey(name: 'metadata_count') required int metadataCount,
  }) = _GetUserByIdResponse;

  factory GetUserByIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserByIdResponseFromJson(json);
}
