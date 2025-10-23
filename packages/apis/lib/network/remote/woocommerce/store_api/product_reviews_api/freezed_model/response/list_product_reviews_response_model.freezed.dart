// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_product_reviews_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListProductReviewsResponseModel _$ListProductReviewsResponseModelFromJson(
    Map<String, dynamic> json) {
  return _ListProductReviewsResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ListProductReviewsResponseModel {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "date_created")
  String? get dateCreated => throw _privateConstructorUsedError;
  @JsonKey(name: "formatted_date_created")
  String? get formattedDateCreated => throw _privateConstructorUsedError;
  @JsonKey(name: "date_created_gmt")
  String? get dateCreatedGmt => throw _privateConstructorUsedError;
  @JsonKey(name: "product_id")
  int? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: "product_name")
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: "product_permalink")
  String? get productPermalink => throw _privateConstructorUsedError;
  @JsonKey(name: "product_image")
  ProductImage? get productImage => throw _privateConstructorUsedError;
  @JsonKey(name: "reviewer")
  String? get reviewer => throw _privateConstructorUsedError;
  @JsonKey(name: "review")
  String? get review => throw _privateConstructorUsedError;
  @JsonKey(name: "rating")
  int? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: "verified")
  bool? get verified => throw _privateConstructorUsedError;
  @JsonKey(name: "reviewer_avatar_urls")
  ReviewerAvatarUrls? get reviewerAvatarUrls =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListProductReviewsResponseModelCopyWith<ListProductReviewsResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListProductReviewsResponseModelCopyWith<$Res> {
  factory $ListProductReviewsResponseModelCopyWith(
          ListProductReviewsResponseModel value,
          $Res Function(ListProductReviewsResponseModel) then) =
      _$ListProductReviewsResponseModelCopyWithImpl<$Res,
          ListProductReviewsResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "date_created") String? dateCreated,
      @JsonKey(name: "formatted_date_created") String? formattedDateCreated,
      @JsonKey(name: "date_created_gmt") String? dateCreatedGmt,
      @JsonKey(name: "product_id") int? productId,
      @JsonKey(name: "product_name") String? productName,
      @JsonKey(name: "product_permalink") String? productPermalink,
      @JsonKey(name: "product_image") ProductImage? productImage,
      @JsonKey(name: "reviewer") String? reviewer,
      @JsonKey(name: "review") String? review,
      @JsonKey(name: "rating") int? rating,
      @JsonKey(name: "verified") bool? verified,
      @JsonKey(name: "reviewer_avatar_urls")
      ReviewerAvatarUrls? reviewerAvatarUrls});

  $ProductImageCopyWith<$Res>? get productImage;
  $ReviewerAvatarUrlsCopyWith<$Res>? get reviewerAvatarUrls;
}

/// @nodoc
class _$ListProductReviewsResponseModelCopyWithImpl<$Res,
        $Val extends ListProductReviewsResponseModel>
    implements $ListProductReviewsResponseModelCopyWith<$Res> {
  _$ListProductReviewsResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? dateCreated = freezed,
    Object? formattedDateCreated = freezed,
    Object? dateCreatedGmt = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productPermalink = freezed,
    Object? productImage = freezed,
    Object? reviewer = freezed,
    Object? review = freezed,
    Object? rating = freezed,
    Object? verified = freezed,
    Object? reviewerAvatarUrls = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      dateCreated: freezed == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as String?,
      formattedDateCreated: freezed == formattedDateCreated
          ? _value.formattedDateCreated
          : formattedDateCreated // ignore: cast_nullable_to_non_nullable
              as String?,
      dateCreatedGmt: freezed == dateCreatedGmt
          ? _value.dateCreatedGmt
          : dateCreatedGmt // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productPermalink: freezed == productPermalink
          ? _value.productPermalink
          : productPermalink // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as ProductImage?,
      reviewer: freezed == reviewer
          ? _value.reviewer
          : reviewer // ignore: cast_nullable_to_non_nullable
              as String?,
      review: freezed == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
      reviewerAvatarUrls: freezed == reviewerAvatarUrls
          ? _value.reviewerAvatarUrls
          : reviewerAvatarUrls // ignore: cast_nullable_to_non_nullable
              as ReviewerAvatarUrls?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductImageCopyWith<$Res>? get productImage {
    if (_value.productImage == null) {
      return null;
    }

    return $ProductImageCopyWith<$Res>(_value.productImage!, (value) {
      return _then(_value.copyWith(productImage: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewerAvatarUrlsCopyWith<$Res>? get reviewerAvatarUrls {
    if (_value.reviewerAvatarUrls == null) {
      return null;
    }

    return $ReviewerAvatarUrlsCopyWith<$Res>(_value.reviewerAvatarUrls!,
        (value) {
      return _then(_value.copyWith(reviewerAvatarUrls: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ListProductReviewsResponseModelImplCopyWith<$Res>
    implements $ListProductReviewsResponseModelCopyWith<$Res> {
  factory _$$ListProductReviewsResponseModelImplCopyWith(
          _$ListProductReviewsResponseModelImpl value,
          $Res Function(_$ListProductReviewsResponseModelImpl) then) =
      __$$ListProductReviewsResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "date_created") String? dateCreated,
      @JsonKey(name: "formatted_date_created") String? formattedDateCreated,
      @JsonKey(name: "date_created_gmt") String? dateCreatedGmt,
      @JsonKey(name: "product_id") int? productId,
      @JsonKey(name: "product_name") String? productName,
      @JsonKey(name: "product_permalink") String? productPermalink,
      @JsonKey(name: "product_image") ProductImage? productImage,
      @JsonKey(name: "reviewer") String? reviewer,
      @JsonKey(name: "review") String? review,
      @JsonKey(name: "rating") int? rating,
      @JsonKey(name: "verified") bool? verified,
      @JsonKey(name: "reviewer_avatar_urls")
      ReviewerAvatarUrls? reviewerAvatarUrls});

  @override
  $ProductImageCopyWith<$Res>? get productImage;
  @override
  $ReviewerAvatarUrlsCopyWith<$Res>? get reviewerAvatarUrls;
}

/// @nodoc
class __$$ListProductReviewsResponseModelImplCopyWithImpl<$Res>
    extends _$ListProductReviewsResponseModelCopyWithImpl<$Res,
        _$ListProductReviewsResponseModelImpl>
    implements _$$ListProductReviewsResponseModelImplCopyWith<$Res> {
  __$$ListProductReviewsResponseModelImplCopyWithImpl(
      _$ListProductReviewsResponseModelImpl _value,
      $Res Function(_$ListProductReviewsResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? dateCreated = freezed,
    Object? formattedDateCreated = freezed,
    Object? dateCreatedGmt = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productPermalink = freezed,
    Object? productImage = freezed,
    Object? reviewer = freezed,
    Object? review = freezed,
    Object? rating = freezed,
    Object? verified = freezed,
    Object? reviewerAvatarUrls = freezed,
  }) {
    return _then(_$ListProductReviewsResponseModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      dateCreated: freezed == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as String?,
      formattedDateCreated: freezed == formattedDateCreated
          ? _value.formattedDateCreated
          : formattedDateCreated // ignore: cast_nullable_to_non_nullable
              as String?,
      dateCreatedGmt: freezed == dateCreatedGmt
          ? _value.dateCreatedGmt
          : dateCreatedGmt // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productPermalink: freezed == productPermalink
          ? _value.productPermalink
          : productPermalink // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as ProductImage?,
      reviewer: freezed == reviewer
          ? _value.reviewer
          : reviewer // ignore: cast_nullable_to_non_nullable
              as String?,
      review: freezed == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
      reviewerAvatarUrls: freezed == reviewerAvatarUrls
          ? _value.reviewerAvatarUrls
          : reviewerAvatarUrls // ignore: cast_nullable_to_non_nullable
              as ReviewerAvatarUrls?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListProductReviewsResponseModelImpl
    implements _ListProductReviewsResponseModel {
  const _$ListProductReviewsResponseModelImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "date_created") this.dateCreated,
      @JsonKey(name: "formatted_date_created") this.formattedDateCreated,
      @JsonKey(name: "date_created_gmt") this.dateCreatedGmt,
      @JsonKey(name: "product_id") this.productId,
      @JsonKey(name: "product_name") this.productName,
      @JsonKey(name: "product_permalink") this.productPermalink,
      @JsonKey(name: "product_image") this.productImage,
      @JsonKey(name: "reviewer") this.reviewer,
      @JsonKey(name: "review") this.review,
      @JsonKey(name: "rating") this.rating,
      @JsonKey(name: "verified") this.verified,
      @JsonKey(name: "reviewer_avatar_urls") this.reviewerAvatarUrls});

  factory _$ListProductReviewsResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ListProductReviewsResponseModelImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "date_created")
  final String? dateCreated;
  @override
  @JsonKey(name: "formatted_date_created")
  final String? formattedDateCreated;
  @override
  @JsonKey(name: "date_created_gmt")
  final String? dateCreatedGmt;
  @override
  @JsonKey(name: "product_id")
  final int? productId;
  @override
  @JsonKey(name: "product_name")
  final String? productName;
  @override
  @JsonKey(name: "product_permalink")
  final String? productPermalink;
  @override
  @JsonKey(name: "product_image")
  final ProductImage? productImage;
  @override
  @JsonKey(name: "reviewer")
  final String? reviewer;
  @override
  @JsonKey(name: "review")
  final String? review;
  @override
  @JsonKey(name: "rating")
  final int? rating;
  @override
  @JsonKey(name: "verified")
  final bool? verified;
  @override
  @JsonKey(name: "reviewer_avatar_urls")
  final ReviewerAvatarUrls? reviewerAvatarUrls;

  @override
  String toString() {
    return 'ListProductReviewsResponseModel(id: $id, dateCreated: $dateCreated, formattedDateCreated: $formattedDateCreated, dateCreatedGmt: $dateCreatedGmt, productId: $productId, productName: $productName, productPermalink: $productPermalink, productImage: $productImage, reviewer: $reviewer, review: $review, rating: $rating, verified: $verified, reviewerAvatarUrls: $reviewerAvatarUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListProductReviewsResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dateCreated, dateCreated) ||
                other.dateCreated == dateCreated) &&
            (identical(other.formattedDateCreated, formattedDateCreated) ||
                other.formattedDateCreated == formattedDateCreated) &&
            (identical(other.dateCreatedGmt, dateCreatedGmt) ||
                other.dateCreatedGmt == dateCreatedGmt) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productPermalink, productPermalink) ||
                other.productPermalink == productPermalink) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.reviewer, reviewer) ||
                other.reviewer == reviewer) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.reviewerAvatarUrls, reviewerAvatarUrls) ||
                other.reviewerAvatarUrls == reviewerAvatarUrls));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dateCreated,
      formattedDateCreated,
      dateCreatedGmt,
      productId,
      productName,
      productPermalink,
      productImage,
      reviewer,
      review,
      rating,
      verified,
      reviewerAvatarUrls);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListProductReviewsResponseModelImplCopyWith<
          _$ListProductReviewsResponseModelImpl>
      get copyWith => __$$ListProductReviewsResponseModelImplCopyWithImpl<
          _$ListProductReviewsResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListProductReviewsResponseModelImplToJson(
      this,
    );
  }
}

abstract class _ListProductReviewsResponseModel
    implements ListProductReviewsResponseModel {
  const factory _ListProductReviewsResponseModel(
          {@JsonKey(name: "id") final int? id,
          @JsonKey(name: "date_created") final String? dateCreated,
          @JsonKey(name: "formatted_date_created")
          final String? formattedDateCreated,
          @JsonKey(name: "date_created_gmt") final String? dateCreatedGmt,
          @JsonKey(name: "product_id") final int? productId,
          @JsonKey(name: "product_name") final String? productName,
          @JsonKey(name: "product_permalink") final String? productPermalink,
          @JsonKey(name: "product_image") final ProductImage? productImage,
          @JsonKey(name: "reviewer") final String? reviewer,
          @JsonKey(name: "review") final String? review,
          @JsonKey(name: "rating") final int? rating,
          @JsonKey(name: "verified") final bool? verified,
          @JsonKey(name: "reviewer_avatar_urls")
          final ReviewerAvatarUrls? reviewerAvatarUrls}) =
      _$ListProductReviewsResponseModelImpl;

  factory _ListProductReviewsResponseModel.fromJson(Map<String, dynamic> json) =
      _$ListProductReviewsResponseModelImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "date_created")
  String? get dateCreated;
  @override
  @JsonKey(name: "formatted_date_created")
  String? get formattedDateCreated;
  @override
  @JsonKey(name: "date_created_gmt")
  String? get dateCreatedGmt;
  @override
  @JsonKey(name: "product_id")
  int? get productId;
  @override
  @JsonKey(name: "product_name")
  String? get productName;
  @override
  @JsonKey(name: "product_permalink")
  String? get productPermalink;
  @override
  @JsonKey(name: "product_image")
  ProductImage? get productImage;
  @override
  @JsonKey(name: "reviewer")
  String? get reviewer;
  @override
  @JsonKey(name: "review")
  String? get review;
  @override
  @JsonKey(name: "rating")
  int? get rating;
  @override
  @JsonKey(name: "verified")
  bool? get verified;
  @override
  @JsonKey(name: "reviewer_avatar_urls")
  ReviewerAvatarUrls? get reviewerAvatarUrls;
  @override
  @JsonKey(ignore: true)
  _$$ListProductReviewsResponseModelImplCopyWith<
          _$ListProductReviewsResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) {
  return _ProductImage.fromJson(json);
}

/// @nodoc
mixin _$ProductImage {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "src")
  String? get src => throw _privateConstructorUsedError;
  @JsonKey(name: "thumbnail")
  String? get thumbnail => throw _privateConstructorUsedError;
  @JsonKey(name: "srcset")
  String? get srcset => throw _privateConstructorUsedError;
  @JsonKey(name: "sizes")
  String? get sizes => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "alt")
  String? get alt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductImageCopyWith<ProductImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductImageCopyWith<$Res> {
  factory $ProductImageCopyWith(
          ProductImage value, $Res Function(ProductImage) then) =
      _$ProductImageCopyWithImpl<$Res, ProductImage>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "src") String? src,
      @JsonKey(name: "thumbnail") String? thumbnail,
      @JsonKey(name: "srcset") String? srcset,
      @JsonKey(name: "sizes") String? sizes,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "alt") String? alt});
}

/// @nodoc
class _$ProductImageCopyWithImpl<$Res, $Val extends ProductImage>
    implements $ProductImageCopyWith<$Res> {
  _$ProductImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? src = freezed,
    Object? thumbnail = freezed,
    Object? srcset = freezed,
    Object? sizes = freezed,
    Object? name = freezed,
    Object? alt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      src: freezed == src
          ? _value.src
          : src // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      srcset: freezed == srcset
          ? _value.srcset
          : srcset // ignore: cast_nullable_to_non_nullable
              as String?,
      sizes: freezed == sizes
          ? _value.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      alt: freezed == alt
          ? _value.alt
          : alt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImageImplCopyWith<$Res>
    implements $ProductImageCopyWith<$Res> {
  factory _$$ProductImageImplCopyWith(
          _$ProductImageImpl value, $Res Function(_$ProductImageImpl) then) =
      __$$ProductImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "src") String? src,
      @JsonKey(name: "thumbnail") String? thumbnail,
      @JsonKey(name: "srcset") String? srcset,
      @JsonKey(name: "sizes") String? sizes,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "alt") String? alt});
}

/// @nodoc
class __$$ProductImageImplCopyWithImpl<$Res>
    extends _$ProductImageCopyWithImpl<$Res, _$ProductImageImpl>
    implements _$$ProductImageImplCopyWith<$Res> {
  __$$ProductImageImplCopyWithImpl(
      _$ProductImageImpl _value, $Res Function(_$ProductImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? src = freezed,
    Object? thumbnail = freezed,
    Object? srcset = freezed,
    Object? sizes = freezed,
    Object? name = freezed,
    Object? alt = freezed,
  }) {
    return _then(_$ProductImageImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      src: freezed == src
          ? _value.src
          : src // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      srcset: freezed == srcset
          ? _value.srcset
          : srcset // ignore: cast_nullable_to_non_nullable
              as String?,
      sizes: freezed == sizes
          ? _value.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      alt: freezed == alt
          ? _value.alt
          : alt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImageImpl implements _ProductImage {
  const _$ProductImageImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "src") this.src,
      @JsonKey(name: "thumbnail") this.thumbnail,
      @JsonKey(name: "srcset") this.srcset,
      @JsonKey(name: "sizes") this.sizes,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "alt") this.alt});

  factory _$ProductImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImageImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "src")
  final String? src;
  @override
  @JsonKey(name: "thumbnail")
  final String? thumbnail;
  @override
  @JsonKey(name: "srcset")
  final String? srcset;
  @override
  @JsonKey(name: "sizes")
  final String? sizes;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "alt")
  final String? alt;

  @override
  String toString() {
    return 'ProductImage(id: $id, src: $src, thumbnail: $thumbnail, srcset: $srcset, sizes: $sizes, name: $name, alt: $alt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.src, src) || other.src == src) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.srcset, srcset) || other.srcset == srcset) &&
            (identical(other.sizes, sizes) || other.sizes == sizes) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.alt, alt) || other.alt == alt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, src, thumbnail, srcset, sizes, name, alt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImageImplCopyWith<_$ProductImageImpl> get copyWith =>
      __$$ProductImageImplCopyWithImpl<_$ProductImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImageImplToJson(
      this,
    );
  }
}

abstract class _ProductImage implements ProductImage {
  const factory _ProductImage(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "src") final String? src,
      @JsonKey(name: "thumbnail") final String? thumbnail,
      @JsonKey(name: "srcset") final String? srcset,
      @JsonKey(name: "sizes") final String? sizes,
      @JsonKey(name: "name") final String? name,
      @JsonKey(name: "alt") final String? alt}) = _$ProductImageImpl;

  factory _ProductImage.fromJson(Map<String, dynamic> json) =
      _$ProductImageImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "src")
  String? get src;
  @override
  @JsonKey(name: "thumbnail")
  String? get thumbnail;
  @override
  @JsonKey(name: "srcset")
  String? get srcset;
  @override
  @JsonKey(name: "sizes")
  String? get sizes;
  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "alt")
  String? get alt;
  @override
  @JsonKey(ignore: true)
  _$$ProductImageImplCopyWith<_$ProductImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewerAvatarUrls _$ReviewerAvatarUrlsFromJson(Map<String, dynamic> json) {
  return _ReviewerAvatarUrls.fromJson(json);
}

/// @nodoc
mixin _$ReviewerAvatarUrls {
  @JsonKey(name: "24")
  String? get the24 => throw _privateConstructorUsedError;
  @JsonKey(name: "48")
  String? get the48 => throw _privateConstructorUsedError;
  @JsonKey(name: "96")
  String? get the96 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewerAvatarUrlsCopyWith<ReviewerAvatarUrls> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewerAvatarUrlsCopyWith<$Res> {
  factory $ReviewerAvatarUrlsCopyWith(
          ReviewerAvatarUrls value, $Res Function(ReviewerAvatarUrls) then) =
      _$ReviewerAvatarUrlsCopyWithImpl<$Res, ReviewerAvatarUrls>;
  @useResult
  $Res call(
      {@JsonKey(name: "24") String? the24,
      @JsonKey(name: "48") String? the48,
      @JsonKey(name: "96") String? the96});
}

/// @nodoc
class _$ReviewerAvatarUrlsCopyWithImpl<$Res, $Val extends ReviewerAvatarUrls>
    implements $ReviewerAvatarUrlsCopyWith<$Res> {
  _$ReviewerAvatarUrlsCopyWithImpl(this._value, this._then);

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
abstract class _$$ReviewerAvatarUrlsImplCopyWith<$Res>
    implements $ReviewerAvatarUrlsCopyWith<$Res> {
  factory _$$ReviewerAvatarUrlsImplCopyWith(_$ReviewerAvatarUrlsImpl value,
          $Res Function(_$ReviewerAvatarUrlsImpl) then) =
      __$$ReviewerAvatarUrlsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "24") String? the24,
      @JsonKey(name: "48") String? the48,
      @JsonKey(name: "96") String? the96});
}

/// @nodoc
class __$$ReviewerAvatarUrlsImplCopyWithImpl<$Res>
    extends _$ReviewerAvatarUrlsCopyWithImpl<$Res, _$ReviewerAvatarUrlsImpl>
    implements _$$ReviewerAvatarUrlsImplCopyWith<$Res> {
  __$$ReviewerAvatarUrlsImplCopyWithImpl(_$ReviewerAvatarUrlsImpl _value,
      $Res Function(_$ReviewerAvatarUrlsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? the24 = freezed,
    Object? the48 = freezed,
    Object? the96 = freezed,
  }) {
    return _then(_$ReviewerAvatarUrlsImpl(
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
class _$ReviewerAvatarUrlsImpl implements _ReviewerAvatarUrls {
  const _$ReviewerAvatarUrlsImpl(
      {@JsonKey(name: "24") this.the24,
      @JsonKey(name: "48") this.the48,
      @JsonKey(name: "96") this.the96});

  factory _$ReviewerAvatarUrlsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewerAvatarUrlsImplFromJson(json);

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
    return 'ReviewerAvatarUrls(the24: $the24, the48: $the48, the96: $the96)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewerAvatarUrlsImpl &&
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
  _$$ReviewerAvatarUrlsImplCopyWith<_$ReviewerAvatarUrlsImpl> get copyWith =>
      __$$ReviewerAvatarUrlsImplCopyWithImpl<_$ReviewerAvatarUrlsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewerAvatarUrlsImplToJson(
      this,
    );
  }
}

abstract class _ReviewerAvatarUrls implements ReviewerAvatarUrls {
  const factory _ReviewerAvatarUrls(
      {@JsonKey(name: "24") final String? the24,
      @JsonKey(name: "48") final String? the48,
      @JsonKey(name: "96") final String? the96}) = _$ReviewerAvatarUrlsImpl;

  factory _ReviewerAvatarUrls.fromJson(Map<String, dynamic> json) =
      _$ReviewerAvatarUrlsImpl.fromJson;

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
  _$$ReviewerAvatarUrlsImplCopyWith<_$ReviewerAvatarUrlsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
