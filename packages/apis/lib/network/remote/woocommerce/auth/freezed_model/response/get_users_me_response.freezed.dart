// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_users_me_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUsersMeResponse _$GetUsersMeResponseFromJson(Map<String, dynamic> json) {
  return _GetUsersMeResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUsersMeResponse {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "url")
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: "description")
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: "link")
  String? get link => throw _privateConstructorUsedError;
  @JsonKey(name: "slug")
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: "avatar_urls")
  AvatarUrls? get avatarUrls => throw _privateConstructorUsedError;
  @JsonKey(name: "meta")
  List<dynamic>? get meta => throw _privateConstructorUsedError;
  @JsonKey(name: "is_super_admin")
  bool? get isSuperAdmin => throw _privateConstructorUsedError;
  @JsonKey(name: "woocommerce_meta")
  WoocommerceMeta? get woocommerceMeta => throw _privateConstructorUsedError;
  @JsonKey(name: "_links")
  Links? get links => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUsersMeResponseCopyWith<GetUsersMeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUsersMeResponseCopyWith<$Res> {
  factory $GetUsersMeResponseCopyWith(
          GetUsersMeResponse value, $Res Function(GetUsersMeResponse) then) =
      _$GetUsersMeResponseCopyWithImpl<$Res, GetUsersMeResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "url") String? url,
      @JsonKey(name: "description") String? description,
      @JsonKey(name: "link") String? link,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "avatar_urls") AvatarUrls? avatarUrls,
      @JsonKey(name: "meta") List<dynamic>? meta,
      @JsonKey(name: "is_super_admin") bool? isSuperAdmin,
      @JsonKey(name: "woocommerce_meta") WoocommerceMeta? woocommerceMeta,
      @JsonKey(name: "_links") Links? links});

  $AvatarUrlsCopyWith<$Res>? get avatarUrls;
  $WoocommerceMetaCopyWith<$Res>? get woocommerceMeta;
  $LinksCopyWith<$Res>? get links;
}

/// @nodoc
class _$GetUsersMeResponseCopyWithImpl<$Res, $Val extends GetUsersMeResponse>
    implements $GetUsersMeResponseCopyWith<$Res> {
  _$GetUsersMeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? url = freezed,
    Object? description = freezed,
    Object? link = freezed,
    Object? slug = freezed,
    Object? avatarUrls = freezed,
    Object? meta = freezed,
    Object? isSuperAdmin = freezed,
    Object? woocommerceMeta = freezed,
    Object? links = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrls: freezed == avatarUrls
          ? _value.avatarUrls
          : avatarUrls // ignore: cast_nullable_to_non_nullable
              as AvatarUrls?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      isSuperAdmin: freezed == isSuperAdmin
          ? _value.isSuperAdmin
          : isSuperAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      woocommerceMeta: freezed == woocommerceMeta
          ? _value.woocommerceMeta
          : woocommerceMeta // ignore: cast_nullable_to_non_nullable
              as WoocommerceMeta?,
      links: freezed == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as Links?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AvatarUrlsCopyWith<$Res>? get avatarUrls {
    if (_value.avatarUrls == null) {
      return null;
    }

    return $AvatarUrlsCopyWith<$Res>(_value.avatarUrls!, (value) {
      return _then(_value.copyWith(avatarUrls: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WoocommerceMetaCopyWith<$Res>? get woocommerceMeta {
    if (_value.woocommerceMeta == null) {
      return null;
    }

    return $WoocommerceMetaCopyWith<$Res>(_value.woocommerceMeta!, (value) {
      return _then(_value.copyWith(woocommerceMeta: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LinksCopyWith<$Res>? get links {
    if (_value.links == null) {
      return null;
    }

    return $LinksCopyWith<$Res>(_value.links!, (value) {
      return _then(_value.copyWith(links: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetUsersMeResponseImplCopyWith<$Res>
    implements $GetUsersMeResponseCopyWith<$Res> {
  factory _$$GetUsersMeResponseImplCopyWith(_$GetUsersMeResponseImpl value,
          $Res Function(_$GetUsersMeResponseImpl) then) =
      __$$GetUsersMeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "url") String? url,
      @JsonKey(name: "description") String? description,
      @JsonKey(name: "link") String? link,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "avatar_urls") AvatarUrls? avatarUrls,
      @JsonKey(name: "meta") List<dynamic>? meta,
      @JsonKey(name: "is_super_admin") bool? isSuperAdmin,
      @JsonKey(name: "woocommerce_meta") WoocommerceMeta? woocommerceMeta,
      @JsonKey(name: "_links") Links? links});

  @override
  $AvatarUrlsCopyWith<$Res>? get avatarUrls;
  @override
  $WoocommerceMetaCopyWith<$Res>? get woocommerceMeta;
  @override
  $LinksCopyWith<$Res>? get links;
}

/// @nodoc
class __$$GetUsersMeResponseImplCopyWithImpl<$Res>
    extends _$GetUsersMeResponseCopyWithImpl<$Res, _$GetUsersMeResponseImpl>
    implements _$$GetUsersMeResponseImplCopyWith<$Res> {
  __$$GetUsersMeResponseImplCopyWithImpl(_$GetUsersMeResponseImpl _value,
      $Res Function(_$GetUsersMeResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? url = freezed,
    Object? description = freezed,
    Object? link = freezed,
    Object? slug = freezed,
    Object? avatarUrls = freezed,
    Object? meta = freezed,
    Object? isSuperAdmin = freezed,
    Object? woocommerceMeta = freezed,
    Object? links = freezed,
  }) {
    return _then(_$GetUsersMeResponseImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrls: freezed == avatarUrls
          ? _value.avatarUrls
          : avatarUrls // ignore: cast_nullable_to_non_nullable
              as AvatarUrls?,
      meta: freezed == meta
          ? _value._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      isSuperAdmin: freezed == isSuperAdmin
          ? _value.isSuperAdmin
          : isSuperAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      woocommerceMeta: freezed == woocommerceMeta
          ? _value.woocommerceMeta
          : woocommerceMeta // ignore: cast_nullable_to_non_nullable
              as WoocommerceMeta?,
      links: freezed == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as Links?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUsersMeResponseImpl implements _GetUsersMeResponse {
  const _$GetUsersMeResponseImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "url") this.url,
      @JsonKey(name: "description") this.description,
      @JsonKey(name: "link") this.link,
      @JsonKey(name: "slug") this.slug,
      @JsonKey(name: "avatar_urls") this.avatarUrls,
      @JsonKey(name: "meta") final List<dynamic>? meta,
      @JsonKey(name: "is_super_admin") this.isSuperAdmin,
      @JsonKey(name: "woocommerce_meta") this.woocommerceMeta,
      @JsonKey(name: "_links") this.links})
      : _meta = meta;

  factory _$GetUsersMeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUsersMeResponseImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "url")
  final String? url;
  @override
  @JsonKey(name: "description")
  final String? description;
  @override
  @JsonKey(name: "link")
  final String? link;
  @override
  @JsonKey(name: "slug")
  final String? slug;
  @override
  @JsonKey(name: "avatar_urls")
  final AvatarUrls? avatarUrls;
  final List<dynamic>? _meta;
  @override
  @JsonKey(name: "meta")
  List<dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableListView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: "is_super_admin")
  final bool? isSuperAdmin;
  @override
  @JsonKey(name: "woocommerce_meta")
  final WoocommerceMeta? woocommerceMeta;
  @override
  @JsonKey(name: "_links")
  final Links? links;

  @override
  String toString() {
    return 'GetUsersMeResponse(id: $id, name: $name, url: $url, description: $description, link: $link, slug: $slug, avatarUrls: $avatarUrls, meta: $meta, isSuperAdmin: $isSuperAdmin, woocommerceMeta: $woocommerceMeta, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUsersMeResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.avatarUrls, avatarUrls) ||
                other.avatarUrls == avatarUrls) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            (identical(other.isSuperAdmin, isSuperAdmin) ||
                other.isSuperAdmin == isSuperAdmin) &&
            (identical(other.woocommerceMeta, woocommerceMeta) ||
                other.woocommerceMeta == woocommerceMeta) &&
            (identical(other.links, links) || other.links == links));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      url,
      description,
      link,
      slug,
      avatarUrls,
      const DeepCollectionEquality().hash(_meta),
      isSuperAdmin,
      woocommerceMeta,
      links);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUsersMeResponseImplCopyWith<_$GetUsersMeResponseImpl> get copyWith =>
      __$$GetUsersMeResponseImplCopyWithImpl<_$GetUsersMeResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUsersMeResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUsersMeResponse implements GetUsersMeResponse {
  const factory _GetUsersMeResponse(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "name") final String? name,
      @JsonKey(name: "url") final String? url,
      @JsonKey(name: "description") final String? description,
      @JsonKey(name: "link") final String? link,
      @JsonKey(name: "slug") final String? slug,
      @JsonKey(name: "avatar_urls") final AvatarUrls? avatarUrls,
      @JsonKey(name: "meta") final List<dynamic>? meta,
      @JsonKey(name: "is_super_admin") final bool? isSuperAdmin,
      @JsonKey(name: "woocommerce_meta") final WoocommerceMeta? woocommerceMeta,
      @JsonKey(name: "_links") final Links? links}) = _$GetUsersMeResponseImpl;

  factory _GetUsersMeResponse.fromJson(Map<String, dynamic> json) =
      _$GetUsersMeResponseImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "url")
  String? get url;
  @override
  @JsonKey(name: "description")
  String? get description;
  @override
  @JsonKey(name: "link")
  String? get link;
  @override
  @JsonKey(name: "slug")
  String? get slug;
  @override
  @JsonKey(name: "avatar_urls")
  AvatarUrls? get avatarUrls;
  @override
  @JsonKey(name: "meta")
  List<dynamic>? get meta;
  @override
  @JsonKey(name: "is_super_admin")
  bool? get isSuperAdmin;
  @override
  @JsonKey(name: "woocommerce_meta")
  WoocommerceMeta? get woocommerceMeta;
  @override
  @JsonKey(name: "_links")
  Links? get links;
  @override
  @JsonKey(ignore: true)
  _$$GetUsersMeResponseImplCopyWith<_$GetUsersMeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvatarUrls _$AvatarUrlsFromJson(Map<String, dynamic> json) {
  return _AvatarUrls.fromJson(json);
}

/// @nodoc
mixin _$AvatarUrls {
  @JsonKey(name: "24")
  String? get the24 => throw _privateConstructorUsedError;
  @JsonKey(name: "48")
  String? get the48 => throw _privateConstructorUsedError;
  @JsonKey(name: "96")
  String? get the96 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvatarUrlsCopyWith<AvatarUrls> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarUrlsCopyWith<$Res> {
  factory $AvatarUrlsCopyWith(
          AvatarUrls value, $Res Function(AvatarUrls) then) =
      _$AvatarUrlsCopyWithImpl<$Res, AvatarUrls>;
  @useResult
  $Res call(
      {@JsonKey(name: "24") String? the24,
      @JsonKey(name: "48") String? the48,
      @JsonKey(name: "96") String? the96});
}

/// @nodoc
class _$AvatarUrlsCopyWithImpl<$Res, $Val extends AvatarUrls>
    implements $AvatarUrlsCopyWith<$Res> {
  _$AvatarUrlsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? the24 = freezed,
    Object? the48 = freezed,
    Object? the96 = freezed,
  }) {
    return _then(_value.copyWith(
      the24: freezed == the24
          ? _value.the24
          : the24 // ignore: cast_nullable_to_non_nullable
              as String?,
      the48: freezed == the48
          ? _value.the48
          : the48 // ignore: cast_nullable_to_non_nullable
              as String?,
      the96: freezed == the96
          ? _value.the96
          : the96 // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvatarUrlsImplCopyWith<$Res>
    implements $AvatarUrlsCopyWith<$Res> {
  factory _$$AvatarUrlsImplCopyWith(
          _$AvatarUrlsImpl value, $Res Function(_$AvatarUrlsImpl) then) =
      __$$AvatarUrlsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "24") String? the24,
      @JsonKey(name: "48") String? the48,
      @JsonKey(name: "96") String? the96});
}

/// @nodoc
class __$$AvatarUrlsImplCopyWithImpl<$Res>
    extends _$AvatarUrlsCopyWithImpl<$Res, _$AvatarUrlsImpl>
    implements _$$AvatarUrlsImplCopyWith<$Res> {
  __$$AvatarUrlsImplCopyWithImpl(
      _$AvatarUrlsImpl _value, $Res Function(_$AvatarUrlsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? the24 = freezed,
    Object? the48 = freezed,
    Object? the96 = freezed,
  }) {
    return _then(_$AvatarUrlsImpl(
      the24: freezed == the24
          ? _value.the24
          : the24 // ignore: cast_nullable_to_non_nullable
              as String?,
      the48: freezed == the48
          ? _value.the48
          : the48 // ignore: cast_nullable_to_non_nullable
              as String?,
      the96: freezed == the96
          ? _value.the96
          : the96 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvatarUrlsImpl implements _AvatarUrls {
  const _$AvatarUrlsImpl(
      {@JsonKey(name: "24") this.the24,
      @JsonKey(name: "48") this.the48,
      @JsonKey(name: "96") this.the96});

  factory _$AvatarUrlsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvatarUrlsImplFromJson(json);

  @override
  @JsonKey(name: "24")
  final String? the24;
  @override
  @JsonKey(name: "48")
  final String? the48;
  @override
  @JsonKey(name: "96")
  final String? the96;

  @override
  String toString() {
    return 'AvatarUrls(the24: $the24, the48: $the48, the96: $the96)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvatarUrlsImpl &&
            (identical(other.the24, the24) || other.the24 == the24) &&
            (identical(other.the48, the48) || other.the48 == the48) &&
            (identical(other.the96, the96) || other.the96 == the96));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, the24, the48, the96);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvatarUrlsImplCopyWith<_$AvatarUrlsImpl> get copyWith =>
      __$$AvatarUrlsImplCopyWithImpl<_$AvatarUrlsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvatarUrlsImplToJson(
      this,
    );
  }
}

abstract class _AvatarUrls implements AvatarUrls {
  const factory _AvatarUrls(
      {@JsonKey(name: "24") final String? the24,
      @JsonKey(name: "48") final String? the48,
      @JsonKey(name: "96") final String? the96}) = _$AvatarUrlsImpl;

  factory _AvatarUrls.fromJson(Map<String, dynamic> json) =
      _$AvatarUrlsImpl.fromJson;

  @override
  @JsonKey(name: "24")
  String? get the24;
  @override
  @JsonKey(name: "48")
  String? get the48;
  @override
  @JsonKey(name: "96")
  String? get the96;
  @override
  @JsonKey(ignore: true)
  _$$AvatarUrlsImplCopyWith<_$AvatarUrlsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Links _$LinksFromJson(Map<String, dynamic> json) {
  return _Links.fromJson(json);
}

/// @nodoc
mixin _$Links {
  @JsonKey(name: "self")
  List<Self>? get self => throw _privateConstructorUsedError;
  @JsonKey(name: "collection")
  List<Collection>? get collection => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LinksCopyWith<Links> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinksCopyWith<$Res> {
  factory $LinksCopyWith(Links value, $Res Function(Links) then) =
      _$LinksCopyWithImpl<$Res, Links>;
  @useResult
  $Res call(
      {@JsonKey(name: "self") List<Self>? self,
      @JsonKey(name: "collection") List<Collection>? collection});
}

/// @nodoc
class _$LinksCopyWithImpl<$Res, $Val extends Links>
    implements $LinksCopyWith<$Res> {
  _$LinksCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? self = freezed,
    Object? collection = freezed,
  }) {
    return _then(_value.copyWith(
      self: freezed == self
          ? _value.self
          : self // ignore: cast_nullable_to_non_nullable
              as List<Self>?,
      collection: freezed == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as List<Collection>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LinksImplCopyWith<$Res> implements $LinksCopyWith<$Res> {
  factory _$$LinksImplCopyWith(
          _$LinksImpl value, $Res Function(_$LinksImpl) then) =
      __$$LinksImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "self") List<Self>? self,
      @JsonKey(name: "collection") List<Collection>? collection});
}

/// @nodoc
class __$$LinksImplCopyWithImpl<$Res>
    extends _$LinksCopyWithImpl<$Res, _$LinksImpl>
    implements _$$LinksImplCopyWith<$Res> {
  __$$LinksImplCopyWithImpl(
      _$LinksImpl _value, $Res Function(_$LinksImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? self = freezed,
    Object? collection = freezed,
  }) {
    return _then(_$LinksImpl(
      self: freezed == self
          ? _value._self
          : self // ignore: cast_nullable_to_non_nullable
              as List<Self>?,
      collection: freezed == collection
          ? _value._collection
          : collection // ignore: cast_nullable_to_non_nullable
              as List<Collection>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LinksImpl implements _Links {
  const _$LinksImpl(
      {@JsonKey(name: "self") final List<Self>? self,
      @JsonKey(name: "collection") final List<Collection>? collection})
      : _self = self,
        _collection = collection;

  factory _$LinksImpl.fromJson(Map<String, dynamic> json) =>
      _$$LinksImplFromJson(json);

  final List<Self>? _self;
  @override
  @JsonKey(name: "self")
  List<Self>? get self {
    final value = _self;
    if (value == null) return null;
    if (_self is EqualUnmodifiableListView) return _self;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Collection>? _collection;
  @override
  @JsonKey(name: "collection")
  List<Collection>? get collection {
    final value = _collection;
    if (value == null) return null;
    if (_collection is EqualUnmodifiableListView) return _collection;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Links(self: $self, collection: $collection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinksImpl &&
            const DeepCollectionEquality().equals(other._self, _self) &&
            const DeepCollectionEquality()
                .equals(other._collection, _collection));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_self),
      const DeepCollectionEquality().hash(_collection));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LinksImplCopyWith<_$LinksImpl> get copyWith =>
      __$$LinksImplCopyWithImpl<_$LinksImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LinksImplToJson(
      this,
    );
  }
}

abstract class _Links implements Links {
  const factory _Links(
          {@JsonKey(name: "self") final List<Self>? self,
          @JsonKey(name: "collection") final List<Collection>? collection}) =
      _$LinksImpl;

  factory _Links.fromJson(Map<String, dynamic> json) = _$LinksImpl.fromJson;

  @override
  @JsonKey(name: "self")
  List<Self>? get self;
  @override
  @JsonKey(name: "collection")
  List<Collection>? get collection;
  @override
  @JsonKey(ignore: true)
  _$$LinksImplCopyWith<_$LinksImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Collection _$CollectionFromJson(Map<String, dynamic> json) {
  return _Collection.fromJson(json);
}

/// @nodoc
mixin _$Collection {
  @JsonKey(name: "href")
  String? get href => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CollectionCopyWith<Collection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionCopyWith<$Res> {
  factory $CollectionCopyWith(
          Collection value, $Res Function(Collection) then) =
      _$CollectionCopyWithImpl<$Res, Collection>;
  @useResult
  $Res call({@JsonKey(name: "href") String? href});
}

/// @nodoc
class _$CollectionCopyWithImpl<$Res, $Val extends Collection>
    implements $CollectionCopyWith<$Res> {
  _$CollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? href = freezed,
  }) {
    return _then(_value.copyWith(
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionImplCopyWith<$Res>
    implements $CollectionCopyWith<$Res> {
  factory _$$CollectionImplCopyWith(
          _$CollectionImpl value, $Res Function(_$CollectionImpl) then) =
      __$$CollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: "href") String? href});
}

/// @nodoc
class __$$CollectionImplCopyWithImpl<$Res>
    extends _$CollectionCopyWithImpl<$Res, _$CollectionImpl>
    implements _$$CollectionImplCopyWith<$Res> {
  __$$CollectionImplCopyWithImpl(
      _$CollectionImpl _value, $Res Function(_$CollectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? href = freezed,
  }) {
    return _then(_$CollectionImpl(
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionImpl implements _Collection {
  const _$CollectionImpl({@JsonKey(name: "href") this.href});

  factory _$CollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionImplFromJson(json);

  @override
  @JsonKey(name: "href")
  final String? href;

  @override
  String toString() {
    return 'Collection(href: $href)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionImpl &&
            (identical(other.href, href) || other.href == href));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, href);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionImplCopyWith<_$CollectionImpl> get copyWith =>
      __$$CollectionImplCopyWithImpl<_$CollectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionImplToJson(
      this,
    );
  }
}

abstract class _Collection implements Collection {
  const factory _Collection({@JsonKey(name: "href") final String? href}) =
      _$CollectionImpl;

  factory _Collection.fromJson(Map<String, dynamic> json) =
      _$CollectionImpl.fromJson;

  @override
  @JsonKey(name: "href")
  String? get href;
  @override
  @JsonKey(ignore: true)
  _$$CollectionImplCopyWith<_$CollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Self _$SelfFromJson(Map<String, dynamic> json) {
  return _Self.fromJson(json);
}

/// @nodoc
mixin _$Self {
  @JsonKey(name: "href")
  String? get href => throw _privateConstructorUsedError;
  @JsonKey(name: "targetHints")
  TargetHints? get targetHints => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SelfCopyWith<Self> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelfCopyWith<$Res> {
  factory $SelfCopyWith(Self value, $Res Function(Self) then) =
      _$SelfCopyWithImpl<$Res, Self>;
  @useResult
  $Res call(
      {@JsonKey(name: "href") String? href,
      @JsonKey(name: "targetHints") TargetHints? targetHints});

  $TargetHintsCopyWith<$Res>? get targetHints;
}

/// @nodoc
class _$SelfCopyWithImpl<$Res, $Val extends Self>
    implements $SelfCopyWith<$Res> {
  _$SelfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? href = freezed,
    Object? targetHints = freezed,
  }) {
    return _then(_value.copyWith(
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHints: freezed == targetHints
          ? _value.targetHints
          : targetHints // ignore: cast_nullable_to_non_nullable
              as TargetHints?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TargetHintsCopyWith<$Res>? get targetHints {
    if (_value.targetHints == null) {
      return null;
    }

    return $TargetHintsCopyWith<$Res>(_value.targetHints!, (value) {
      return _then(_value.copyWith(targetHints: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SelfImplCopyWith<$Res> implements $SelfCopyWith<$Res> {
  factory _$$SelfImplCopyWith(
          _$SelfImpl value, $Res Function(_$SelfImpl) then) =
      __$$SelfImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "href") String? href,
      @JsonKey(name: "targetHints") TargetHints? targetHints});

  @override
  $TargetHintsCopyWith<$Res>? get targetHints;
}

/// @nodoc
class __$$SelfImplCopyWithImpl<$Res>
    extends _$SelfCopyWithImpl<$Res, _$SelfImpl>
    implements _$$SelfImplCopyWith<$Res> {
  __$$SelfImplCopyWithImpl(_$SelfImpl _value, $Res Function(_$SelfImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? href = freezed,
    Object? targetHints = freezed,
  }) {
    return _then(_$SelfImpl(
      href: freezed == href
          ? _value.href
          : href // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHints: freezed == targetHints
          ? _value.targetHints
          : targetHints // ignore: cast_nullable_to_non_nullable
              as TargetHints?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelfImpl implements _Self {
  const _$SelfImpl(
      {@JsonKey(name: "href") this.href,
      @JsonKey(name: "targetHints") this.targetHints});

  factory _$SelfImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelfImplFromJson(json);

  @override
  @JsonKey(name: "href")
  final String? href;
  @override
  @JsonKey(name: "targetHints")
  final TargetHints? targetHints;

  @override
  String toString() {
    return 'Self(href: $href, targetHints: $targetHints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelfImpl &&
            (identical(other.href, href) || other.href == href) &&
            (identical(other.targetHints, targetHints) ||
                other.targetHints == targetHints));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, href, targetHints);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelfImplCopyWith<_$SelfImpl> get copyWith =>
      __$$SelfImplCopyWithImpl<_$SelfImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelfImplToJson(
      this,
    );
  }
}

abstract class _Self implements Self {
  const factory _Self(
          {@JsonKey(name: "href") final String? href,
          @JsonKey(name: "targetHints") final TargetHints? targetHints}) =
      _$SelfImpl;

  factory _Self.fromJson(Map<String, dynamic> json) = _$SelfImpl.fromJson;

  @override
  @JsonKey(name: "href")
  String? get href;
  @override
  @JsonKey(name: "targetHints")
  TargetHints? get targetHints;
  @override
  @JsonKey(ignore: true)
  _$$SelfImplCopyWith<_$SelfImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TargetHints _$TargetHintsFromJson(Map<String, dynamic> json) {
  return _TargetHints.fromJson(json);
}

/// @nodoc
mixin _$TargetHints {
  @JsonKey(name: "allow")
  List<String>? get allow => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TargetHintsCopyWith<TargetHints> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetHintsCopyWith<$Res> {
  factory $TargetHintsCopyWith(
          TargetHints value, $Res Function(TargetHints) then) =
      _$TargetHintsCopyWithImpl<$Res, TargetHints>;
  @useResult
  $Res call({@JsonKey(name: "allow") List<String>? allow});
}

/// @nodoc
class _$TargetHintsCopyWithImpl<$Res, $Val extends TargetHints>
    implements $TargetHintsCopyWith<$Res> {
  _$TargetHintsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allow = freezed,
  }) {
    return _then(_value.copyWith(
      allow: freezed == allow
          ? _value.allow
          : allow // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TargetHintsImplCopyWith<$Res>
    implements $TargetHintsCopyWith<$Res> {
  factory _$$TargetHintsImplCopyWith(
          _$TargetHintsImpl value, $Res Function(_$TargetHintsImpl) then) =
      __$$TargetHintsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: "allow") List<String>? allow});
}

/// @nodoc
class __$$TargetHintsImplCopyWithImpl<$Res>
    extends _$TargetHintsCopyWithImpl<$Res, _$TargetHintsImpl>
    implements _$$TargetHintsImplCopyWith<$Res> {
  __$$TargetHintsImplCopyWithImpl(
      _$TargetHintsImpl _value, $Res Function(_$TargetHintsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allow = freezed,
  }) {
    return _then(_$TargetHintsImpl(
      allow: freezed == allow
          ? _value._allow
          : allow // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TargetHintsImpl implements _TargetHints {
  const _$TargetHintsImpl({@JsonKey(name: "allow") final List<String>? allow})
      : _allow = allow;

  factory _$TargetHintsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TargetHintsImplFromJson(json);

  final List<String>? _allow;
  @override
  @JsonKey(name: "allow")
  List<String>? get allow {
    final value = _allow;
    if (value == null) return null;
    if (_allow is EqualUnmodifiableListView) return _allow;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TargetHints(allow: $allow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TargetHintsImpl &&
            const DeepCollectionEquality().equals(other._allow, _allow));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_allow));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetHintsImplCopyWith<_$TargetHintsImpl> get copyWith =>
      __$$TargetHintsImplCopyWithImpl<_$TargetHintsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetHintsImplToJson(
      this,
    );
  }
}

abstract class _TargetHints implements TargetHints {
  const factory _TargetHints(
      {@JsonKey(name: "allow") final List<String>? allow}) = _$TargetHintsImpl;

  factory _TargetHints.fromJson(Map<String, dynamic> json) =
      _$TargetHintsImpl.fromJson;

  @override
  @JsonKey(name: "allow")
  List<String>? get allow;
  @override
  @JsonKey(ignore: true)
  _$$TargetHintsImplCopyWith<_$TargetHintsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WoocommerceMeta _$WoocommerceMetaFromJson(Map<String, dynamic> json) {
  return _WoocommerceMeta.fromJson(json);
}

/// @nodoc
mixin _$WoocommerceMeta {
  @JsonKey(name: "variable_product_tour_shown")
  String? get variableProductTourShown => throw _privateConstructorUsedError;
  @JsonKey(name: "activity_panel_inbox_last_read")
  String? get activityPanelInboxLastRead => throw _privateConstructorUsedError;
  @JsonKey(name: "activity_panel_reviews_last_read")
  String? get activityPanelReviewsLastRead =>
      throw _privateConstructorUsedError;
  @JsonKey(name: "categories_report_columns")
  String? get categoriesReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "coupons_report_columns")
  String? get couponsReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "customers_report_columns")
  String? get customersReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "orders_report_columns")
  String? get ordersReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "products_report_columns")
  String? get productsReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "revenue_report_columns")
  String? get revenueReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "taxes_report_columns")
  String? get taxesReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "variations_report_columns")
  String? get variationsReportColumns => throw _privateConstructorUsedError;
  @JsonKey(name: "dashboard_sections")
  String? get dashboardSections => throw _privateConstructorUsedError;
  @JsonKey(name: "dashboard_chart_type")
  String? get dashboardChartType => throw _privateConstructorUsedError;
  @JsonKey(name: "dashboard_chart_interval")
  String? get dashboardChartInterval => throw _privateConstructorUsedError;
  @JsonKey(name: "dashboard_leaderboard_rows")
  String? get dashboardLeaderboardRows => throw _privateConstructorUsedError;
  @JsonKey(name: "order_attribution_install_banner_dismissed")
  String? get orderAttributionInstallBannerDismissed =>
      throw _privateConstructorUsedError;
  @JsonKey(name: "homepage_layout")
  String? get homepageLayout => throw _privateConstructorUsedError;
  @JsonKey(name: "homepage_stats")
  String? get homepageStats => throw _privateConstructorUsedError;
  @JsonKey(name: "task_list_tracked_started_tasks")
  String? get taskListTrackedStartedTasks => throw _privateConstructorUsedError;
  @JsonKey(name: "android_app_banner_dismissed")
  String? get androidAppBannerDismissed => throw _privateConstructorUsedError;
  @JsonKey(name: "launch_your_store_tour_hidden")
  String? get launchYourStoreTourHidden => throw _privateConstructorUsedError;
  @JsonKey(name: "coming_soon_banner_dismissed")
  String? get comingSoonBannerDismissed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WoocommerceMetaCopyWith<WoocommerceMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WoocommerceMetaCopyWith<$Res> {
  factory $WoocommerceMetaCopyWith(
          WoocommerceMeta value, $Res Function(WoocommerceMeta) then) =
      _$WoocommerceMetaCopyWithImpl<$Res, WoocommerceMeta>;
  @useResult
  $Res call(
      {@JsonKey(name: "variable_product_tour_shown")
      String? variableProductTourShown,
      @JsonKey(name: "activity_panel_inbox_last_read")
      String? activityPanelInboxLastRead,
      @JsonKey(name: "activity_panel_reviews_last_read")
      String? activityPanelReviewsLastRead,
      @JsonKey(name: "categories_report_columns")
      String? categoriesReportColumns,
      @JsonKey(name: "coupons_report_columns") String? couponsReportColumns,
      @JsonKey(name: "customers_report_columns") String? customersReportColumns,
      @JsonKey(name: "orders_report_columns") String? ordersReportColumns,
      @JsonKey(name: "products_report_columns") String? productsReportColumns,
      @JsonKey(name: "revenue_report_columns") String? revenueReportColumns,
      @JsonKey(name: "taxes_report_columns") String? taxesReportColumns,
      @JsonKey(name: "variations_report_columns")
      String? variationsReportColumns,
      @JsonKey(name: "dashboard_sections") String? dashboardSections,
      @JsonKey(name: "dashboard_chart_type") String? dashboardChartType,
      @JsonKey(name: "dashboard_chart_interval") String? dashboardChartInterval,
      @JsonKey(name: "dashboard_leaderboard_rows")
      String? dashboardLeaderboardRows,
      @JsonKey(name: "order_attribution_install_banner_dismissed")
      String? orderAttributionInstallBannerDismissed,
      @JsonKey(name: "homepage_layout") String? homepageLayout,
      @JsonKey(name: "homepage_stats") String? homepageStats,
      @JsonKey(name: "task_list_tracked_started_tasks")
      String? taskListTrackedStartedTasks,
      @JsonKey(name: "android_app_banner_dismissed")
      String? androidAppBannerDismissed,
      @JsonKey(name: "launch_your_store_tour_hidden")
      String? launchYourStoreTourHidden,
      @JsonKey(name: "coming_soon_banner_dismissed")
      String? comingSoonBannerDismissed});
}

/// @nodoc
class _$WoocommerceMetaCopyWithImpl<$Res, $Val extends WoocommerceMeta>
    implements $WoocommerceMetaCopyWith<$Res> {
  _$WoocommerceMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variableProductTourShown = freezed,
    Object? activityPanelInboxLastRead = freezed,
    Object? activityPanelReviewsLastRead = freezed,
    Object? categoriesReportColumns = freezed,
    Object? couponsReportColumns = freezed,
    Object? customersReportColumns = freezed,
    Object? ordersReportColumns = freezed,
    Object? productsReportColumns = freezed,
    Object? revenueReportColumns = freezed,
    Object? taxesReportColumns = freezed,
    Object? variationsReportColumns = freezed,
    Object? dashboardSections = freezed,
    Object? dashboardChartType = freezed,
    Object? dashboardChartInterval = freezed,
    Object? dashboardLeaderboardRows = freezed,
    Object? orderAttributionInstallBannerDismissed = freezed,
    Object? homepageLayout = freezed,
    Object? homepageStats = freezed,
    Object? taskListTrackedStartedTasks = freezed,
    Object? androidAppBannerDismissed = freezed,
    Object? launchYourStoreTourHidden = freezed,
    Object? comingSoonBannerDismissed = freezed,
  }) {
    return _then(_value.copyWith(
      variableProductTourShown: freezed == variableProductTourShown
          ? _value.variableProductTourShown
          : variableProductTourShown // ignore: cast_nullable_to_non_nullable
              as String?,
      activityPanelInboxLastRead: freezed == activityPanelInboxLastRead
          ? _value.activityPanelInboxLastRead
          : activityPanelInboxLastRead // ignore: cast_nullable_to_non_nullable
              as String?,
      activityPanelReviewsLastRead: freezed == activityPanelReviewsLastRead
          ? _value.activityPanelReviewsLastRead
          : activityPanelReviewsLastRead // ignore: cast_nullable_to_non_nullable
              as String?,
      categoriesReportColumns: freezed == categoriesReportColumns
          ? _value.categoriesReportColumns
          : categoriesReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      couponsReportColumns: freezed == couponsReportColumns
          ? _value.couponsReportColumns
          : couponsReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      customersReportColumns: freezed == customersReportColumns
          ? _value.customersReportColumns
          : customersReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      ordersReportColumns: freezed == ordersReportColumns
          ? _value.ordersReportColumns
          : ordersReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      productsReportColumns: freezed == productsReportColumns
          ? _value.productsReportColumns
          : productsReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      revenueReportColumns: freezed == revenueReportColumns
          ? _value.revenueReportColumns
          : revenueReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      taxesReportColumns: freezed == taxesReportColumns
          ? _value.taxesReportColumns
          : taxesReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      variationsReportColumns: freezed == variationsReportColumns
          ? _value.variationsReportColumns
          : variationsReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardSections: freezed == dashboardSections
          ? _value.dashboardSections
          : dashboardSections // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardChartType: freezed == dashboardChartType
          ? _value.dashboardChartType
          : dashboardChartType // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardChartInterval: freezed == dashboardChartInterval
          ? _value.dashboardChartInterval
          : dashboardChartInterval // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardLeaderboardRows: freezed == dashboardLeaderboardRows
          ? _value.dashboardLeaderboardRows
          : dashboardLeaderboardRows // ignore: cast_nullable_to_non_nullable
              as String?,
      orderAttributionInstallBannerDismissed: freezed ==
              orderAttributionInstallBannerDismissed
          ? _value.orderAttributionInstallBannerDismissed
          : orderAttributionInstallBannerDismissed // ignore: cast_nullable_to_non_nullable
              as String?,
      homepageLayout: freezed == homepageLayout
          ? _value.homepageLayout
          : homepageLayout // ignore: cast_nullable_to_non_nullable
              as String?,
      homepageStats: freezed == homepageStats
          ? _value.homepageStats
          : homepageStats // ignore: cast_nullable_to_non_nullable
              as String?,
      taskListTrackedStartedTasks: freezed == taskListTrackedStartedTasks
          ? _value.taskListTrackedStartedTasks
          : taskListTrackedStartedTasks // ignore: cast_nullable_to_non_nullable
              as String?,
      androidAppBannerDismissed: freezed == androidAppBannerDismissed
          ? _value.androidAppBannerDismissed
          : androidAppBannerDismissed // ignore: cast_nullable_to_non_nullable
              as String?,
      launchYourStoreTourHidden: freezed == launchYourStoreTourHidden
          ? _value.launchYourStoreTourHidden
          : launchYourStoreTourHidden // ignore: cast_nullable_to_non_nullable
              as String?,
      comingSoonBannerDismissed: freezed == comingSoonBannerDismissed
          ? _value.comingSoonBannerDismissed
          : comingSoonBannerDismissed // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WoocommerceMetaImplCopyWith<$Res>
    implements $WoocommerceMetaCopyWith<$Res> {
  factory _$$WoocommerceMetaImplCopyWith(_$WoocommerceMetaImpl value,
          $Res Function(_$WoocommerceMetaImpl) then) =
      __$$WoocommerceMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "variable_product_tour_shown")
      String? variableProductTourShown,
      @JsonKey(name: "activity_panel_inbox_last_read")
      String? activityPanelInboxLastRead,
      @JsonKey(name: "activity_panel_reviews_last_read")
      String? activityPanelReviewsLastRead,
      @JsonKey(name: "categories_report_columns")
      String? categoriesReportColumns,
      @JsonKey(name: "coupons_report_columns") String? couponsReportColumns,
      @JsonKey(name: "customers_report_columns") String? customersReportColumns,
      @JsonKey(name: "orders_report_columns") String? ordersReportColumns,
      @JsonKey(name: "products_report_columns") String? productsReportColumns,
      @JsonKey(name: "revenue_report_columns") String? revenueReportColumns,
      @JsonKey(name: "taxes_report_columns") String? taxesReportColumns,
      @JsonKey(name: "variations_report_columns")
      String? variationsReportColumns,
      @JsonKey(name: "dashboard_sections") String? dashboardSections,
      @JsonKey(name: "dashboard_chart_type") String? dashboardChartType,
      @JsonKey(name: "dashboard_chart_interval") String? dashboardChartInterval,
      @JsonKey(name: "dashboard_leaderboard_rows")
      String? dashboardLeaderboardRows,
      @JsonKey(name: "order_attribution_install_banner_dismissed")
      String? orderAttributionInstallBannerDismissed,
      @JsonKey(name: "homepage_layout") String? homepageLayout,
      @JsonKey(name: "homepage_stats") String? homepageStats,
      @JsonKey(name: "task_list_tracked_started_tasks")
      String? taskListTrackedStartedTasks,
      @JsonKey(name: "android_app_banner_dismissed")
      String? androidAppBannerDismissed,
      @JsonKey(name: "launch_your_store_tour_hidden")
      String? launchYourStoreTourHidden,
      @JsonKey(name: "coming_soon_banner_dismissed")
      String? comingSoonBannerDismissed});
}

/// @nodoc
class __$$WoocommerceMetaImplCopyWithImpl<$Res>
    extends _$WoocommerceMetaCopyWithImpl<$Res, _$WoocommerceMetaImpl>
    implements _$$WoocommerceMetaImplCopyWith<$Res> {
  __$$WoocommerceMetaImplCopyWithImpl(
      _$WoocommerceMetaImpl _value, $Res Function(_$WoocommerceMetaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variableProductTourShown = freezed,
    Object? activityPanelInboxLastRead = freezed,
    Object? activityPanelReviewsLastRead = freezed,
    Object? categoriesReportColumns = freezed,
    Object? couponsReportColumns = freezed,
    Object? customersReportColumns = freezed,
    Object? ordersReportColumns = freezed,
    Object? productsReportColumns = freezed,
    Object? revenueReportColumns = freezed,
    Object? taxesReportColumns = freezed,
    Object? variationsReportColumns = freezed,
    Object? dashboardSections = freezed,
    Object? dashboardChartType = freezed,
    Object? dashboardChartInterval = freezed,
    Object? dashboardLeaderboardRows = freezed,
    Object? orderAttributionInstallBannerDismissed = freezed,
    Object? homepageLayout = freezed,
    Object? homepageStats = freezed,
    Object? taskListTrackedStartedTasks = freezed,
    Object? androidAppBannerDismissed = freezed,
    Object? launchYourStoreTourHidden = freezed,
    Object? comingSoonBannerDismissed = freezed,
  }) {
    return _then(_$WoocommerceMetaImpl(
      variableProductTourShown: freezed == variableProductTourShown
          ? _value.variableProductTourShown
          : variableProductTourShown // ignore: cast_nullable_to_non_nullable
              as String?,
      activityPanelInboxLastRead: freezed == activityPanelInboxLastRead
          ? _value.activityPanelInboxLastRead
          : activityPanelInboxLastRead // ignore: cast_nullable_to_non_nullable
              as String?,
      activityPanelReviewsLastRead: freezed == activityPanelReviewsLastRead
          ? _value.activityPanelReviewsLastRead
          : activityPanelReviewsLastRead // ignore: cast_nullable_to_non_nullable
              as String?,
      categoriesReportColumns: freezed == categoriesReportColumns
          ? _value.categoriesReportColumns
          : categoriesReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      couponsReportColumns: freezed == couponsReportColumns
          ? _value.couponsReportColumns
          : couponsReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      customersReportColumns: freezed == customersReportColumns
          ? _value.customersReportColumns
          : customersReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      ordersReportColumns: freezed == ordersReportColumns
          ? _value.ordersReportColumns
          : ordersReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      productsReportColumns: freezed == productsReportColumns
          ? _value.productsReportColumns
          : productsReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      revenueReportColumns: freezed == revenueReportColumns
          ? _value.revenueReportColumns
          : revenueReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      taxesReportColumns: freezed == taxesReportColumns
          ? _value.taxesReportColumns
          : taxesReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      variationsReportColumns: freezed == variationsReportColumns
          ? _value.variationsReportColumns
          : variationsReportColumns // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardSections: freezed == dashboardSections
          ? _value.dashboardSections
          : dashboardSections // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardChartType: freezed == dashboardChartType
          ? _value.dashboardChartType
          : dashboardChartType // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardChartInterval: freezed == dashboardChartInterval
          ? _value.dashboardChartInterval
          : dashboardChartInterval // ignore: cast_nullable_to_non_nullable
              as String?,
      dashboardLeaderboardRows: freezed == dashboardLeaderboardRows
          ? _value.dashboardLeaderboardRows
          : dashboardLeaderboardRows // ignore: cast_nullable_to_non_nullable
              as String?,
      orderAttributionInstallBannerDismissed: freezed ==
              orderAttributionInstallBannerDismissed
          ? _value.orderAttributionInstallBannerDismissed
          : orderAttributionInstallBannerDismissed // ignore: cast_nullable_to_non_nullable
              as String?,
      homepageLayout: freezed == homepageLayout
          ? _value.homepageLayout
          : homepageLayout // ignore: cast_nullable_to_non_nullable
              as String?,
      homepageStats: freezed == homepageStats
          ? _value.homepageStats
          : homepageStats // ignore: cast_nullable_to_non_nullable
              as String?,
      taskListTrackedStartedTasks: freezed == taskListTrackedStartedTasks
          ? _value.taskListTrackedStartedTasks
          : taskListTrackedStartedTasks // ignore: cast_nullable_to_non_nullable
              as String?,
      androidAppBannerDismissed: freezed == androidAppBannerDismissed
          ? _value.androidAppBannerDismissed
          : androidAppBannerDismissed // ignore: cast_nullable_to_non_nullable
              as String?,
      launchYourStoreTourHidden: freezed == launchYourStoreTourHidden
          ? _value.launchYourStoreTourHidden
          : launchYourStoreTourHidden // ignore: cast_nullable_to_non_nullable
              as String?,
      comingSoonBannerDismissed: freezed == comingSoonBannerDismissed
          ? _value.comingSoonBannerDismissed
          : comingSoonBannerDismissed // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WoocommerceMetaImpl implements _WoocommerceMeta {
  const _$WoocommerceMetaImpl(
      {@JsonKey(name: "variable_product_tour_shown")
      this.variableProductTourShown,
      @JsonKey(name: "activity_panel_inbox_last_read")
      this.activityPanelInboxLastRead,
      @JsonKey(name: "activity_panel_reviews_last_read")
      this.activityPanelReviewsLastRead,
      @JsonKey(name: "categories_report_columns") this.categoriesReportColumns,
      @JsonKey(name: "coupons_report_columns") this.couponsReportColumns,
      @JsonKey(name: "customers_report_columns") this.customersReportColumns,
      @JsonKey(name: "orders_report_columns") this.ordersReportColumns,
      @JsonKey(name: "products_report_columns") this.productsReportColumns,
      @JsonKey(name: "revenue_report_columns") this.revenueReportColumns,
      @JsonKey(name: "taxes_report_columns") this.taxesReportColumns,
      @JsonKey(name: "variations_report_columns") this.variationsReportColumns,
      @JsonKey(name: "dashboard_sections") this.dashboardSections,
      @JsonKey(name: "dashboard_chart_type") this.dashboardChartType,
      @JsonKey(name: "dashboard_chart_interval") this.dashboardChartInterval,
      @JsonKey(name: "dashboard_leaderboard_rows")
      this.dashboardLeaderboardRows,
      @JsonKey(name: "order_attribution_install_banner_dismissed")
      this.orderAttributionInstallBannerDismissed,
      @JsonKey(name: "homepage_layout") this.homepageLayout,
      @JsonKey(name: "homepage_stats") this.homepageStats,
      @JsonKey(name: "task_list_tracked_started_tasks")
      this.taskListTrackedStartedTasks,
      @JsonKey(name: "android_app_banner_dismissed")
      this.androidAppBannerDismissed,
      @JsonKey(name: "launch_your_store_tour_hidden")
      this.launchYourStoreTourHidden,
      @JsonKey(name: "coming_soon_banner_dismissed")
      this.comingSoonBannerDismissed});

  factory _$WoocommerceMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$WoocommerceMetaImplFromJson(json);

  @override
  @JsonKey(name: "variable_product_tour_shown")
  final String? variableProductTourShown;
  @override
  @JsonKey(name: "activity_panel_inbox_last_read")
  final String? activityPanelInboxLastRead;
  @override
  @JsonKey(name: "activity_panel_reviews_last_read")
  final String? activityPanelReviewsLastRead;
  @override
  @JsonKey(name: "categories_report_columns")
  final String? categoriesReportColumns;
  @override
  @JsonKey(name: "coupons_report_columns")
  final String? couponsReportColumns;
  @override
  @JsonKey(name: "customers_report_columns")
  final String? customersReportColumns;
  @override
  @JsonKey(name: "orders_report_columns")
  final String? ordersReportColumns;
  @override
  @JsonKey(name: "products_report_columns")
  final String? productsReportColumns;
  @override
  @JsonKey(name: "revenue_report_columns")
  final String? revenueReportColumns;
  @override
  @JsonKey(name: "taxes_report_columns")
  final String? taxesReportColumns;
  @override
  @JsonKey(name: "variations_report_columns")
  final String? variationsReportColumns;
  @override
  @JsonKey(name: "dashboard_sections")
  final String? dashboardSections;
  @override
  @JsonKey(name: "dashboard_chart_type")
  final String? dashboardChartType;
  @override
  @JsonKey(name: "dashboard_chart_interval")
  final String? dashboardChartInterval;
  @override
  @JsonKey(name: "dashboard_leaderboard_rows")
  final String? dashboardLeaderboardRows;
  @override
  @JsonKey(name: "order_attribution_install_banner_dismissed")
  final String? orderAttributionInstallBannerDismissed;
  @override
  @JsonKey(name: "homepage_layout")
  final String? homepageLayout;
  @override
  @JsonKey(name: "homepage_stats")
  final String? homepageStats;
  @override
  @JsonKey(name: "task_list_tracked_started_tasks")
  final String? taskListTrackedStartedTasks;
  @override
  @JsonKey(name: "android_app_banner_dismissed")
  final String? androidAppBannerDismissed;
  @override
  @JsonKey(name: "launch_your_store_tour_hidden")
  final String? launchYourStoreTourHidden;
  @override
  @JsonKey(name: "coming_soon_banner_dismissed")
  final String? comingSoonBannerDismissed;

  @override
  String toString() {
    return 'WoocommerceMeta(variableProductTourShown: $variableProductTourShown, activityPanelInboxLastRead: $activityPanelInboxLastRead, activityPanelReviewsLastRead: $activityPanelReviewsLastRead, categoriesReportColumns: $categoriesReportColumns, couponsReportColumns: $couponsReportColumns, customersReportColumns: $customersReportColumns, ordersReportColumns: $ordersReportColumns, productsReportColumns: $productsReportColumns, revenueReportColumns: $revenueReportColumns, taxesReportColumns: $taxesReportColumns, variationsReportColumns: $variationsReportColumns, dashboardSections: $dashboardSections, dashboardChartType: $dashboardChartType, dashboardChartInterval: $dashboardChartInterval, dashboardLeaderboardRows: $dashboardLeaderboardRows, orderAttributionInstallBannerDismissed: $orderAttributionInstallBannerDismissed, homepageLayout: $homepageLayout, homepageStats: $homepageStats, taskListTrackedStartedTasks: $taskListTrackedStartedTasks, androidAppBannerDismissed: $androidAppBannerDismissed, launchYourStoreTourHidden: $launchYourStoreTourHidden, comingSoonBannerDismissed: $comingSoonBannerDismissed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WoocommerceMetaImpl &&
            (identical(other.variableProductTourShown, variableProductTourShown) ||
                other.variableProductTourShown == variableProductTourShown) &&
            (identical(other.activityPanelInboxLastRead, activityPanelInboxLastRead) ||
                other.activityPanelInboxLastRead ==
                    activityPanelInboxLastRead) &&
            (identical(other.activityPanelReviewsLastRead, activityPanelReviewsLastRead) ||
                other.activityPanelReviewsLastRead ==
                    activityPanelReviewsLastRead) &&
            (identical(other.categoriesReportColumns, categoriesReportColumns) ||
                other.categoriesReportColumns == categoriesReportColumns) &&
            (identical(other.couponsReportColumns, couponsReportColumns) ||
                other.couponsReportColumns == couponsReportColumns) &&
            (identical(other.customersReportColumns, customersReportColumns) ||
                other.customersReportColumns == customersReportColumns) &&
            (identical(other.ordersReportColumns, ordersReportColumns) ||
                other.ordersReportColumns == ordersReportColumns) &&
            (identical(other.productsReportColumns, productsReportColumns) ||
                other.productsReportColumns == productsReportColumns) &&
            (identical(other.revenueReportColumns, revenueReportColumns) ||
                other.revenueReportColumns == revenueReportColumns) &&
            (identical(other.taxesReportColumns, taxesReportColumns) ||
                other.taxesReportColumns == taxesReportColumns) &&
            (identical(other.variationsReportColumns, variationsReportColumns) ||
                other.variationsReportColumns == variationsReportColumns) &&
            (identical(other.dashboardSections, dashboardSections) ||
                other.dashboardSections == dashboardSections) &&
            (identical(other.dashboardChartType, dashboardChartType) ||
                other.dashboardChartType == dashboardChartType) &&
            (identical(other.dashboardChartInterval, dashboardChartInterval) ||
                other.dashboardChartInterval == dashboardChartInterval) &&
            (identical(other.dashboardLeaderboardRows, dashboardLeaderboardRows) ||
                other.dashboardLeaderboardRows == dashboardLeaderboardRows) &&
            (identical(other.orderAttributionInstallBannerDismissed, orderAttributionInstallBannerDismissed) ||
                other.orderAttributionInstallBannerDismissed ==
                    orderAttributionInstallBannerDismissed) &&
            (identical(other.homepageLayout, homepageLayout) ||
                other.homepageLayout == homepageLayout) &&
            (identical(other.homepageStats, homepageStats) || other.homepageStats == homepageStats) &&
            (identical(other.taskListTrackedStartedTasks, taskListTrackedStartedTasks) || other.taskListTrackedStartedTasks == taskListTrackedStartedTasks) &&
            (identical(other.androidAppBannerDismissed, androidAppBannerDismissed) || other.androidAppBannerDismissed == androidAppBannerDismissed) &&
            (identical(other.launchYourStoreTourHidden, launchYourStoreTourHidden) || other.launchYourStoreTourHidden == launchYourStoreTourHidden) &&
            (identical(other.comingSoonBannerDismissed, comingSoonBannerDismissed) || other.comingSoonBannerDismissed == comingSoonBannerDismissed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        variableProductTourShown,
        activityPanelInboxLastRead,
        activityPanelReviewsLastRead,
        categoriesReportColumns,
        couponsReportColumns,
        customersReportColumns,
        ordersReportColumns,
        productsReportColumns,
        revenueReportColumns,
        taxesReportColumns,
        variationsReportColumns,
        dashboardSections,
        dashboardChartType,
        dashboardChartInterval,
        dashboardLeaderboardRows,
        orderAttributionInstallBannerDismissed,
        homepageLayout,
        homepageStats,
        taskListTrackedStartedTasks,
        androidAppBannerDismissed,
        launchYourStoreTourHidden,
        comingSoonBannerDismissed
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WoocommerceMetaImplCopyWith<_$WoocommerceMetaImpl> get copyWith =>
      __$$WoocommerceMetaImplCopyWithImpl<_$WoocommerceMetaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WoocommerceMetaImplToJson(
      this,
    );
  }
}

abstract class _WoocommerceMeta implements WoocommerceMeta {
  const factory _WoocommerceMeta(
      {@JsonKey(name: "variable_product_tour_shown")
      final String? variableProductTourShown,
      @JsonKey(name: "activity_panel_inbox_last_read")
      final String? activityPanelInboxLastRead,
      @JsonKey(name: "activity_panel_reviews_last_read")
      final String? activityPanelReviewsLastRead,
      @JsonKey(name: "categories_report_columns")
      final String? categoriesReportColumns,
      @JsonKey(name: "coupons_report_columns")
      final String? couponsReportColumns,
      @JsonKey(name: "customers_report_columns")
      final String? customersReportColumns,
      @JsonKey(name: "orders_report_columns") final String? ordersReportColumns,
      @JsonKey(name: "products_report_columns")
      final String? productsReportColumns,
      @JsonKey(name: "revenue_report_columns")
      final String? revenueReportColumns,
      @JsonKey(name: "taxes_report_columns") final String? taxesReportColumns,
      @JsonKey(name: "variations_report_columns")
      final String? variationsReportColumns,
      @JsonKey(name: "dashboard_sections") final String? dashboardSections,
      @JsonKey(name: "dashboard_chart_type") final String? dashboardChartType,
      @JsonKey(name: "dashboard_chart_interval")
      final String? dashboardChartInterval,
      @JsonKey(name: "dashboard_leaderboard_rows")
      final String? dashboardLeaderboardRows,
      @JsonKey(name: "order_attribution_install_banner_dismissed")
      final String? orderAttributionInstallBannerDismissed,
      @JsonKey(name: "homepage_layout") final String? homepageLayout,
      @JsonKey(name: "homepage_stats") final String? homepageStats,
      @JsonKey(name: "task_list_tracked_started_tasks")
      final String? taskListTrackedStartedTasks,
      @JsonKey(name: "android_app_banner_dismissed")
      final String? androidAppBannerDismissed,
      @JsonKey(name: "launch_your_store_tour_hidden")
      final String? launchYourStoreTourHidden,
      @JsonKey(name: "coming_soon_banner_dismissed")
      final String? comingSoonBannerDismissed}) = _$WoocommerceMetaImpl;

  factory _WoocommerceMeta.fromJson(Map<String, dynamic> json) =
      _$WoocommerceMetaImpl.fromJson;

  @override
  @JsonKey(name: "variable_product_tour_shown")
  String? get variableProductTourShown;
  @override
  @JsonKey(name: "activity_panel_inbox_last_read")
  String? get activityPanelInboxLastRead;
  @override
  @JsonKey(name: "activity_panel_reviews_last_read")
  String? get activityPanelReviewsLastRead;
  @override
  @JsonKey(name: "categories_report_columns")
  String? get categoriesReportColumns;
  @override
  @JsonKey(name: "coupons_report_columns")
  String? get couponsReportColumns;
  @override
  @JsonKey(name: "customers_report_columns")
  String? get customersReportColumns;
  @override
  @JsonKey(name: "orders_report_columns")
  String? get ordersReportColumns;
  @override
  @JsonKey(name: "products_report_columns")
  String? get productsReportColumns;
  @override
  @JsonKey(name: "revenue_report_columns")
  String? get revenueReportColumns;
  @override
  @JsonKey(name: "taxes_report_columns")
  String? get taxesReportColumns;
  @override
  @JsonKey(name: "variations_report_columns")
  String? get variationsReportColumns;
  @override
  @JsonKey(name: "dashboard_sections")
  String? get dashboardSections;
  @override
  @JsonKey(name: "dashboard_chart_type")
  String? get dashboardChartType;
  @override
  @JsonKey(name: "dashboard_chart_interval")
  String? get dashboardChartInterval;
  @override
  @JsonKey(name: "dashboard_leaderboard_rows")
  String? get dashboardLeaderboardRows;
  @override
  @JsonKey(name: "order_attribution_install_banner_dismissed")
  String? get orderAttributionInstallBannerDismissed;
  @override
  @JsonKey(name: "homepage_layout")
  String? get homepageLayout;
  @override
  @JsonKey(name: "homepage_stats")
  String? get homepageStats;
  @override
  @JsonKey(name: "task_list_tracked_started_tasks")
  String? get taskListTrackedStartedTasks;
  @override
  @JsonKey(name: "android_app_banner_dismissed")
  String? get androidAppBannerDismissed;
  @override
  @JsonKey(name: "launch_your_store_tour_hidden")
  String? get launchYourStoreTourHidden;
  @override
  @JsonKey(name: "coming_soon_banner_dismissed")
  String? get comingSoonBannerDismissed;
  @override
  @JsonKey(ignore: true)
  _$$WoocommerceMetaImplCopyWith<_$WoocommerceMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
