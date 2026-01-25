// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_all_users_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetAllUsersResponse _$GetAllUsersResponseFromJson(Map<String, dynamic> json) {
  return _GetAllUsersResponse.fromJson(json);
}

/// @nodoc
mixin _$GetAllUsersResponse {
  List<UserListItem> get users => throw _privateConstructorUsedError;
  PaginationInfo get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetAllUsersResponseCopyWith<GetAllUsersResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetAllUsersResponseCopyWith<$Res> {
  factory $GetAllUsersResponseCopyWith(
          GetAllUsersResponse value, $Res Function(GetAllUsersResponse) then) =
      _$GetAllUsersResponseCopyWithImpl<$Res, GetAllUsersResponse>;
  @useResult
  $Res call({List<UserListItem> users, PaginationInfo pagination});

  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$GetAllUsersResponseCopyWithImpl<$Res, $Val extends GetAllUsersResponse>
    implements $GetAllUsersResponseCopyWith<$Res> {
  _$GetAllUsersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserListItem>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res> get pagination {
    return $PaginationInfoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetAllUsersResponseImplCopyWith<$Res>
    implements $GetAllUsersResponseCopyWith<$Res> {
  factory _$$GetAllUsersResponseImplCopyWith(_$GetAllUsersResponseImpl value,
          $Res Function(_$GetAllUsersResponseImpl) then) =
      __$$GetAllUsersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserListItem> users, PaginationInfo pagination});

  @override
  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$GetAllUsersResponseImplCopyWithImpl<$Res>
    extends _$GetAllUsersResponseCopyWithImpl<$Res, _$GetAllUsersResponseImpl>
    implements _$$GetAllUsersResponseImplCopyWith<$Res> {
  __$$GetAllUsersResponseImplCopyWithImpl(_$GetAllUsersResponseImpl _value,
      $Res Function(_$GetAllUsersResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? pagination = null,
  }) {
    return _then(_$GetAllUsersResponseImpl(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserListItem>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetAllUsersResponseImpl implements _GetAllUsersResponse {
  const _$GetAllUsersResponseImpl(
      {required final List<UserListItem> users, required this.pagination})
      : _users = users;

  factory _$GetAllUsersResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetAllUsersResponseImplFromJson(json);

  final List<UserListItem> _users;
  @override
  List<UserListItem> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final PaginationInfo pagination;

  @override
  String toString() {
    return 'GetAllUsersResponse(users: $users, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetAllUsersResponseImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_users), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetAllUsersResponseImplCopyWith<_$GetAllUsersResponseImpl> get copyWith =>
      __$$GetAllUsersResponseImplCopyWithImpl<_$GetAllUsersResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetAllUsersResponseImplToJson(
      this,
    );
  }
}

abstract class _GetAllUsersResponse implements GetAllUsersResponse {
  const factory _GetAllUsersResponse(
      {required final List<UserListItem> users,
      required final PaginationInfo pagination}) = _$GetAllUsersResponseImpl;

  factory _GetAllUsersResponse.fromJson(Map<String, dynamic> json) =
      _$GetAllUsersResponseImpl.fromJson;

  @override
  List<UserListItem> get users;
  @override
  PaginationInfo get pagination;
  @override
  @JsonKey(ignore: true)
  _$$GetAllUsersResponseImplCopyWith<_$GetAllUsersResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserListItem _$UserListItemFromJson(Map<String, dynamic> json) {
  return _UserListItem.fromJson(json);
}

/// @nodoc
mixin _$UserListItem {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'roles')
  List<String> get roles => throw _privateConstructorUsedError;
  @JsonKey(name: 'registered_at')
  String get registeredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'metadata_count')
  int get metadataCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserListItemCopyWith<UserListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserListItemCopyWith<$Res> {
  factory $UserListItemCopyWith(
          UserListItem value, $Res Function(UserListItem) then) =
      _$UserListItemCopyWithImpl<$Res, UserListItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'registered_at') String registeredAt,
      @JsonKey(name: 'metadata_count') int metadataCount});
}

/// @nodoc
class _$UserListItemCopyWithImpl<$Res, $Val extends UserListItem>
    implements $UserListItemCopyWith<$Res> {
  _$UserListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? roles = null,
    Object? registeredAt = null,
    Object? metadataCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String,
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserListItemImplCopyWith<$Res>
    implements $UserListItemCopyWith<$Res> {
  factory _$$UserListItemImplCopyWith(
          _$UserListItemImpl value, $Res Function(_$UserListItemImpl) then) =
      __$$UserListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'registered_at') String registeredAt,
      @JsonKey(name: 'metadata_count') int metadataCount});
}

/// @nodoc
class __$$UserListItemImplCopyWithImpl<$Res>
    extends _$UserListItemCopyWithImpl<$Res, _$UserListItemImpl>
    implements _$$UserListItemImplCopyWith<$Res> {
  __$$UserListItemImplCopyWithImpl(
      _$UserListItemImpl _value, $Res Function(_$UserListItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? roles = null,
    Object? registeredAt = null,
    Object? metadataCount = null,
  }) {
    return _then(_$UserListItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String,
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserListItemImpl implements _UserListItem {
  const _$UserListItemImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'display_name') required this.displayName,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'roles') required final List<String> roles,
      @JsonKey(name: 'registered_at') required this.registeredAt,
      @JsonKey(name: 'metadata_count') required this.metadataCount})
      : _roles = roles;

  factory _$UserListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserListItemImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'username')
  final String username;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  final List<String> _roles;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  @JsonKey(name: 'registered_at')
  final String registeredAt;
  @override
  @JsonKey(name: 'metadata_count')
  final int metadataCount;

  @override
  String toString() {
    return 'UserListItem(id: $id, username: $username, email: $email, displayName: $displayName, firstName: $firstName, lastName: $lastName, roles: $roles, registeredAt: $registeredAt, metadataCount: $metadataCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.metadataCount, metadataCount) ||
                other.metadataCount == metadataCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      email,
      displayName,
      firstName,
      lastName,
      const DeepCollectionEquality().hash(_roles),
      registeredAt,
      metadataCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserListItemImplCopyWith<_$UserListItemImpl> get copyWith =>
      __$$UserListItemImplCopyWithImpl<_$UserListItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserListItemImplToJson(
      this,
    );
  }
}

abstract class _UserListItem implements UserListItem {
  const factory _UserListItem(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'email') required final String email,
          @JsonKey(name: 'display_name') required final String displayName,
          @JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          @JsonKey(name: 'roles') required final List<String> roles,
          @JsonKey(name: 'registered_at') required final String registeredAt,
          @JsonKey(name: 'metadata_count') required final int metadataCount}) =
      _$UserListItemImpl;

  factory _UserListItem.fromJson(Map<String, dynamic> json) =
      _$UserListItemImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'username')
  String get username;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles;
  @override
  @JsonKey(name: 'registered_at')
  String get registeredAt;
  @override
  @JsonKey(name: 'metadata_count')
  int get metadataCount;
  @override
  @JsonKey(ignore: true)
  _$$UserListItemImplCopyWith<_$UserListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) {
  return _PaginationInfo.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfo {
  @JsonKey(name: 'total')
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationInfoCopyWith<PaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoCopyWith<$Res> {
  factory $PaginationInfoCopyWith(
          PaginationInfo value, $Res Function(PaginationInfo) then) =
      _$PaginationInfoCopyWithImpl<$Res, PaginationInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total') int total,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'total_pages') int totalPages});
}

/// @nodoc
class _$PaginationInfoCopyWithImpl<$Res, $Val extends PaginationInfo>
    implements $PaginationInfoCopyWith<$Res> {
  _$PaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? perPage = null,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoImplCopyWith<$Res>
    implements $PaginationInfoCopyWith<$Res> {
  factory _$$PaginationInfoImplCopyWith(_$PaginationInfoImpl value,
          $Res Function(_$PaginationInfoImpl) then) =
      __$$PaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total') int total,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'total_pages') int totalPages});
}

/// @nodoc
class __$$PaginationInfoImplCopyWithImpl<$Res>
    extends _$PaginationInfoCopyWithImpl<$Res, _$PaginationInfoImpl>
    implements _$$PaginationInfoImplCopyWith<$Res> {
  __$$PaginationInfoImplCopyWithImpl(
      _$PaginationInfoImpl _value, $Res Function(_$PaginationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? perPage = null,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_$PaginationInfoImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoImpl implements _PaginationInfo {
  const _$PaginationInfoImpl(
      {@JsonKey(name: 'total') required this.total,
      @JsonKey(name: 'per_page') required this.perPage,
      @JsonKey(name: 'current_page') required this.currentPage,
      @JsonKey(name: 'total_pages') required this.totalPages});

  factory _$PaginationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoImplFromJson(json);

  @override
  @JsonKey(name: 'total')
  final int total;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;

  @override
  String toString() {
    return 'PaginationInfo(total: $total, perPage: $perPage, currentPage: $currentPage, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, total, perPage, currentPage, totalPages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      __$$PaginationInfoImplCopyWithImpl<_$PaginationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfo implements PaginationInfo {
  const factory _PaginationInfo(
          {@JsonKey(name: 'total') required final int total,
          @JsonKey(name: 'per_page') required final int perPage,
          @JsonKey(name: 'current_page') required final int currentPage,
          @JsonKey(name: 'total_pages') required final int totalPages}) =
      _$PaginationInfoImpl;

  factory _PaginationInfo.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoImpl.fromJson;

  @override
  @JsonKey(name: 'total')
  int get total;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(ignore: true)
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
