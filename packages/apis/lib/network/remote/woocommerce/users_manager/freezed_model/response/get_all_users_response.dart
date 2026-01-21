import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_all_users_response.freezed.dart';
part 'get_all_users_response.g.dart';

/// 👥 Get All Users Response Model (Admin)
@freezed
class GetAllUsersResponse with _$GetAllUsersResponse {
  const factory GetAllUsersResponse({
    required List<UserListItem> users,
    required PaginationInfo pagination,
  }) = _GetAllUsersResponse;

  factory GetAllUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllUsersResponseFromJson(json);
}

/// 👤 User List Item Model
@freezed
class UserListItem with _$UserListItem {
  const factory UserListItem({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'roles') required List<String> roles,
    @JsonKey(name: 'registered_at') required String registeredAt,
    @JsonKey(name: 'metadata_count') required int metadataCount,
  }) = _UserListItem;

  factory UserListItem.fromJson(Map<String, dynamic> json) =>
      _$UserListItemFromJson(json);
}

/// 📄 Pagination Info Model
@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    @JsonKey(name: 'total') required int total,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _PaginationInfo;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
}
