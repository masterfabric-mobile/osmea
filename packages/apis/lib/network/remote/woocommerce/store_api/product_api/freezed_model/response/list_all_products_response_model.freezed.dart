// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_all_products_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListAllProductsResponseModel _$ListAllProductsResponseModelFromJson(
    Map<String, dynamic> json) {
  return _ListAllProductsResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ListAllProductsResponseModel {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "slug")
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: "parent")
  int? get parent => throw _privateConstructorUsedError;
  @JsonKey(name: "type")
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: "variation")
  String? get variation => throw _privateConstructorUsedError;
  @JsonKey(name: "permalink")
  String? get permalink => throw _privateConstructorUsedError;
  @JsonKey(name: "sku")
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: "short_description")
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: "description")
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: "on_sale")
  bool? get onSale => throw _privateConstructorUsedError;
  @JsonKey(name: "prices")
  Prices? get prices => throw _privateConstructorUsedError;
  @JsonKey(name: "price_html")
  String? get priceHtml => throw _privateConstructorUsedError;
  @JsonKey(name: "average_rating")
  String? get averageRating => throw _privateConstructorUsedError;
  @JsonKey(name: "review_count")
  int? get reviewCount => throw _privateConstructorUsedError;
  @JsonKey(name: "images")
  List<Image>? get images => throw _privateConstructorUsedError;
  @JsonKey(name: "categories")
  List<Category>? get categories => throw _privateConstructorUsedError;
  @JsonKey(name: "tags")
  List<dynamic>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: "brands")
  List<dynamic>? get brands => throw _privateConstructorUsedError;
  @JsonKey(name: "attributes")
  List<ListAllProductsResponseModelAttribute>? get attributes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: "variations")
  List<Variation>? get variations => throw _privateConstructorUsedError;
  @JsonKey(name: "grouped_products")
  List<dynamic>? get groupedProducts => throw _privateConstructorUsedError;
  @JsonKey(name: "has_options")
  bool? get hasOptions => throw _privateConstructorUsedError;
  @JsonKey(name: "is_purchasable")
  bool? get isPurchasable => throw _privateConstructorUsedError;
  @JsonKey(name: "is_in_stock")
  bool? get isInStock => throw _privateConstructorUsedError;
  @JsonKey(name: "is_on_backorder")
  bool? get isOnBackorder => throw _privateConstructorUsedError;
  @JsonKey(name: "low_stock_remaining")
  dynamic get lowStockRemaining => throw _privateConstructorUsedError;
  @JsonKey(name: "stock_availability")
  StockAvailability? get stockAvailability =>
      throw _privateConstructorUsedError;
  @JsonKey(name: "sold_individually")
  bool? get soldIndividually => throw _privateConstructorUsedError;
  @JsonKey(name: "add_to_cart")
  AddToCart? get addToCart => throw _privateConstructorUsedError;
  @JsonKey(name: "extensions")
  Extensions? get extensions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListAllProductsResponseModelCopyWith<ListAllProductsResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListAllProductsResponseModelCopyWith<$Res> {
  factory $ListAllProductsResponseModelCopyWith(
          ListAllProductsResponseModel value,
          $Res Function(ListAllProductsResponseModel) then) =
      _$ListAllProductsResponseModelCopyWithImpl<$Res,
          ListAllProductsResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "parent") int? parent,
      @JsonKey(name: "type") String? type,
      @JsonKey(name: "variation") String? variation,
      @JsonKey(name: "permalink") String? permalink,
      @JsonKey(name: "sku") String? sku,
      @JsonKey(name: "short_description") String? shortDescription,
      @JsonKey(name: "description") String? description,
      @JsonKey(name: "on_sale") bool? onSale,
      @JsonKey(name: "prices") Prices? prices,
      @JsonKey(name: "price_html") String? priceHtml,
      @JsonKey(name: "average_rating") String? averageRating,
      @JsonKey(name: "review_count") int? reviewCount,
      @JsonKey(name: "images") List<Image>? images,
      @JsonKey(name: "categories") List<Category>? categories,
      @JsonKey(name: "tags") List<dynamic>? tags,
      @JsonKey(name: "brands") List<dynamic>? brands,
      @JsonKey(name: "attributes")
      List<ListAllProductsResponseModelAttribute>? attributes,
      @JsonKey(name: "variations") List<Variation>? variations,
      @JsonKey(name: "grouped_products") List<dynamic>? groupedProducts,
      @JsonKey(name: "has_options") bool? hasOptions,
      @JsonKey(name: "is_purchasable") bool? isPurchasable,
      @JsonKey(name: "is_in_stock") bool? isInStock,
      @JsonKey(name: "is_on_backorder") bool? isOnBackorder,
      @JsonKey(name: "low_stock_remaining") dynamic lowStockRemaining,
      @JsonKey(name: "stock_availability") StockAvailability? stockAvailability,
      @JsonKey(name: "sold_individually") bool? soldIndividually,
      @JsonKey(name: "add_to_cart") AddToCart? addToCart,
      @JsonKey(name: "extensions") Extensions? extensions});

  $PricesCopyWith<$Res>? get prices;
  $StockAvailabilityCopyWith<$Res>? get stockAvailability;
  $AddToCartCopyWith<$Res>? get addToCart;
  $ExtensionsCopyWith<$Res>? get extensions;
}

/// @nodoc
class _$ListAllProductsResponseModelCopyWithImpl<$Res,
        $Val extends ListAllProductsResponseModel>
    implements $ListAllProductsResponseModelCopyWith<$Res> {
  _$ListAllProductsResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? parent = freezed,
    Object? type = freezed,
    Object? variation = freezed,
    Object? permalink = freezed,
    Object? sku = freezed,
    Object? shortDescription = freezed,
    Object? description = freezed,
    Object? onSale = freezed,
    Object? prices = freezed,
    Object? priceHtml = freezed,
    Object? averageRating = freezed,
    Object? reviewCount = freezed,
    Object? images = freezed,
    Object? categories = freezed,
    Object? tags = freezed,
    Object? brands = freezed,
    Object? attributes = freezed,
    Object? variations = freezed,
    Object? groupedProducts = freezed,
    Object? hasOptions = freezed,
    Object? isPurchasable = freezed,
    Object? isInStock = freezed,
    Object? isOnBackorder = freezed,
    Object? lowStockRemaining = freezed,
    Object? stockAvailability = freezed,
    Object? soldIndividually = freezed,
    Object? addToCart = freezed,
    Object? extensions = freezed,
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
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      variation: freezed == variation
          ? _value.variation
          : variation // ignore: cast_nullable_to_non_nullable
              as String?,
      permalink: freezed == permalink
          ? _value.permalink
          : permalink // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      onSale: freezed == onSale
          ? _value.onSale
          : onSale // ignore: cast_nullable_to_non_nullable
              as bool?,
      prices: freezed == prices
          ? _value.prices
          : prices // ignore: cast_nullable_to_non_nullable
              as Prices?,
      priceHtml: freezed == priceHtml
          ? _value.priceHtml
          : priceHtml // ignore: cast_nullable_to_non_nullable
              as String?,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<Image>?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      brands: freezed == brands
          ? _value.brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      attributes: freezed == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<ListAllProductsResponseModelAttribute>?,
      variations: freezed == variations
          ? _value.variations
          : variations // ignore: cast_nullable_to_non_nullable
              as List<Variation>?,
      groupedProducts: freezed == groupedProducts
          ? _value.groupedProducts
          : groupedProducts // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      hasOptions: freezed == hasOptions
          ? _value.hasOptions
          : hasOptions // ignore: cast_nullable_to_non_nullable
              as bool?,
      isPurchasable: freezed == isPurchasable
          ? _value.isPurchasable
          : isPurchasable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isInStock: freezed == isInStock
          ? _value.isInStock
          : isInStock // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnBackorder: freezed == isOnBackorder
          ? _value.isOnBackorder
          : isOnBackorder // ignore: cast_nullable_to_non_nullable
              as bool?,
      lowStockRemaining: freezed == lowStockRemaining
          ? _value.lowStockRemaining
          : lowStockRemaining // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stockAvailability: freezed == stockAvailability
          ? _value.stockAvailability
          : stockAvailability // ignore: cast_nullable_to_non_nullable
              as StockAvailability?,
      soldIndividually: freezed == soldIndividually
          ? _value.soldIndividually
          : soldIndividually // ignore: cast_nullable_to_non_nullable
              as bool?,
      addToCart: freezed == addToCart
          ? _value.addToCart
          : addToCart // ignore: cast_nullable_to_non_nullable
              as AddToCart?,
      extensions: freezed == extensions
          ? _value.extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Extensions?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PricesCopyWith<$Res>? get prices {
    if (_value.prices == null) {
      return null;
    }

    return $PricesCopyWith<$Res>(_value.prices!, (value) {
      return _then(_value.copyWith(prices: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StockAvailabilityCopyWith<$Res>? get stockAvailability {
    if (_value.stockAvailability == null) {
      return null;
    }

    return $StockAvailabilityCopyWith<$Res>(_value.stockAvailability!, (value) {
      return _then(_value.copyWith(stockAvailability: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AddToCartCopyWith<$Res>? get addToCart {
    if (_value.addToCart == null) {
      return null;
    }

    return $AddToCartCopyWith<$Res>(_value.addToCart!, (value) {
      return _then(_value.copyWith(addToCart: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ExtensionsCopyWith<$Res>? get extensions {
    if (_value.extensions == null) {
      return null;
    }

    return $ExtensionsCopyWith<$Res>(_value.extensions!, (value) {
      return _then(_value.copyWith(extensions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ListAllProductsResponseModelImplCopyWith<$Res>
    implements $ListAllProductsResponseModelCopyWith<$Res> {
  factory _$$ListAllProductsResponseModelImplCopyWith(
          _$ListAllProductsResponseModelImpl value,
          $Res Function(_$ListAllProductsResponseModelImpl) then) =
      __$$ListAllProductsResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "parent") int? parent,
      @JsonKey(name: "type") String? type,
      @JsonKey(name: "variation") String? variation,
      @JsonKey(name: "permalink") String? permalink,
      @JsonKey(name: "sku") String? sku,
      @JsonKey(name: "short_description") String? shortDescription,
      @JsonKey(name: "description") String? description,
      @JsonKey(name: "on_sale") bool? onSale,
      @JsonKey(name: "prices") Prices? prices,
      @JsonKey(name: "price_html") String? priceHtml,
      @JsonKey(name: "average_rating") String? averageRating,
      @JsonKey(name: "review_count") int? reviewCount,
      @JsonKey(name: "images") List<Image>? images,
      @JsonKey(name: "categories") List<Category>? categories,
      @JsonKey(name: "tags") List<dynamic>? tags,
      @JsonKey(name: "brands") List<dynamic>? brands,
      @JsonKey(name: "attributes")
      List<ListAllProductsResponseModelAttribute>? attributes,
      @JsonKey(name: "variations") List<Variation>? variations,
      @JsonKey(name: "grouped_products") List<dynamic>? groupedProducts,
      @JsonKey(name: "has_options") bool? hasOptions,
      @JsonKey(name: "is_purchasable") bool? isPurchasable,
      @JsonKey(name: "is_in_stock") bool? isInStock,
      @JsonKey(name: "is_on_backorder") bool? isOnBackorder,
      @JsonKey(name: "low_stock_remaining") dynamic lowStockRemaining,
      @JsonKey(name: "stock_availability") StockAvailability? stockAvailability,
      @JsonKey(name: "sold_individually") bool? soldIndividually,
      @JsonKey(name: "add_to_cart") AddToCart? addToCart,
      @JsonKey(name: "extensions") Extensions? extensions});

  @override
  $PricesCopyWith<$Res>? get prices;
  @override
  $StockAvailabilityCopyWith<$Res>? get stockAvailability;
  @override
  $AddToCartCopyWith<$Res>? get addToCart;
  @override
  $ExtensionsCopyWith<$Res>? get extensions;
}

/// @nodoc
class __$$ListAllProductsResponseModelImplCopyWithImpl<$Res>
    extends _$ListAllProductsResponseModelCopyWithImpl<$Res,
        _$ListAllProductsResponseModelImpl>
    implements _$$ListAllProductsResponseModelImplCopyWith<$Res> {
  __$$ListAllProductsResponseModelImplCopyWithImpl(
      _$ListAllProductsResponseModelImpl _value,
      $Res Function(_$ListAllProductsResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? parent = freezed,
    Object? type = freezed,
    Object? variation = freezed,
    Object? permalink = freezed,
    Object? sku = freezed,
    Object? shortDescription = freezed,
    Object? description = freezed,
    Object? onSale = freezed,
    Object? prices = freezed,
    Object? priceHtml = freezed,
    Object? averageRating = freezed,
    Object? reviewCount = freezed,
    Object? images = freezed,
    Object? categories = freezed,
    Object? tags = freezed,
    Object? brands = freezed,
    Object? attributes = freezed,
    Object? variations = freezed,
    Object? groupedProducts = freezed,
    Object? hasOptions = freezed,
    Object? isPurchasable = freezed,
    Object? isInStock = freezed,
    Object? isOnBackorder = freezed,
    Object? lowStockRemaining = freezed,
    Object? stockAvailability = freezed,
    Object? soldIndividually = freezed,
    Object? addToCart = freezed,
    Object? extensions = freezed,
  }) {
    return _then(_$ListAllProductsResponseModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      variation: freezed == variation
          ? _value.variation
          : variation // ignore: cast_nullable_to_non_nullable
              as String?,
      permalink: freezed == permalink
          ? _value.permalink
          : permalink // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      onSale: freezed == onSale
          ? _value.onSale
          : onSale // ignore: cast_nullable_to_non_nullable
              as bool?,
      prices: freezed == prices
          ? _value.prices
          : prices // ignore: cast_nullable_to_non_nullable
              as Prices?,
      priceHtml: freezed == priceHtml
          ? _value.priceHtml
          : priceHtml // ignore: cast_nullable_to_non_nullable
              as String?,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<Image>?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      brands: freezed == brands
          ? _value._brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      attributes: freezed == attributes
          ? _value._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<ListAllProductsResponseModelAttribute>?,
      variations: freezed == variations
          ? _value._variations
          : variations // ignore: cast_nullable_to_non_nullable
              as List<Variation>?,
      groupedProducts: freezed == groupedProducts
          ? _value._groupedProducts
          : groupedProducts // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      hasOptions: freezed == hasOptions
          ? _value.hasOptions
          : hasOptions // ignore: cast_nullable_to_non_nullable
              as bool?,
      isPurchasable: freezed == isPurchasable
          ? _value.isPurchasable
          : isPurchasable // ignore: cast_nullable_to_non_nullable
              as bool?,
      isInStock: freezed == isInStock
          ? _value.isInStock
          : isInStock // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnBackorder: freezed == isOnBackorder
          ? _value.isOnBackorder
          : isOnBackorder // ignore: cast_nullable_to_non_nullable
              as bool?,
      lowStockRemaining: freezed == lowStockRemaining
          ? _value.lowStockRemaining
          : lowStockRemaining // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stockAvailability: freezed == stockAvailability
          ? _value.stockAvailability
          : stockAvailability // ignore: cast_nullable_to_non_nullable
              as StockAvailability?,
      soldIndividually: freezed == soldIndividually
          ? _value.soldIndividually
          : soldIndividually // ignore: cast_nullable_to_non_nullable
              as bool?,
      addToCart: freezed == addToCart
          ? _value.addToCart
          : addToCart // ignore: cast_nullable_to_non_nullable
              as AddToCart?,
      extensions: freezed == extensions
          ? _value.extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Extensions?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListAllProductsResponseModelImpl
    implements _ListAllProductsResponseModel {
  const _$ListAllProductsResponseModelImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "slug") this.slug,
      @JsonKey(name: "parent") this.parent,
      @JsonKey(name: "type") this.type,
      @JsonKey(name: "variation") this.variation,
      @JsonKey(name: "permalink") this.permalink,
      @JsonKey(name: "sku") this.sku,
      @JsonKey(name: "short_description") this.shortDescription,
      @JsonKey(name: "description") this.description,
      @JsonKey(name: "on_sale") this.onSale,
      @JsonKey(name: "prices") this.prices,
      @JsonKey(name: "price_html") this.priceHtml,
      @JsonKey(name: "average_rating") this.averageRating,
      @JsonKey(name: "review_count") this.reviewCount,
      @JsonKey(name: "images") final List<Image>? images,
      @JsonKey(name: "categories") final List<Category>? categories,
      @JsonKey(name: "tags") final List<dynamic>? tags,
      @JsonKey(name: "brands") final List<dynamic>? brands,
      @JsonKey(name: "attributes")
      final List<ListAllProductsResponseModelAttribute>? attributes,
      @JsonKey(name: "variations") final List<Variation>? variations,
      @JsonKey(name: "grouped_products") final List<dynamic>? groupedProducts,
      @JsonKey(name: "has_options") this.hasOptions,
      @JsonKey(name: "is_purchasable") this.isPurchasable,
      @JsonKey(name: "is_in_stock") this.isInStock,
      @JsonKey(name: "is_on_backorder") this.isOnBackorder,
      @JsonKey(name: "low_stock_remaining") this.lowStockRemaining,
      @JsonKey(name: "stock_availability") this.stockAvailability,
      @JsonKey(name: "sold_individually") this.soldIndividually,
      @JsonKey(name: "add_to_cart") this.addToCart,
      @JsonKey(name: "extensions") this.extensions})
      : _images = images,
        _categories = categories,
        _tags = tags,
        _brands = brands,
        _attributes = attributes,
        _variations = variations,
        _groupedProducts = groupedProducts;

  factory _$ListAllProductsResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ListAllProductsResponseModelImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "slug")
  final String? slug;
  @override
  @JsonKey(name: "parent")
  final int? parent;
  @override
  @JsonKey(name: "type")
  final String? type;
  @override
  @JsonKey(name: "variation")
  final String? variation;
  @override
  @JsonKey(name: "permalink")
  final String? permalink;
  @override
  @JsonKey(name: "sku")
  final String? sku;
  @override
  @JsonKey(name: "short_description")
  final String? shortDescription;
  @override
  @JsonKey(name: "description")
  final String? description;
  @override
  @JsonKey(name: "on_sale")
  final bool? onSale;
  @override
  @JsonKey(name: "prices")
  final Prices? prices;
  @override
  @JsonKey(name: "price_html")
  final String? priceHtml;
  @override
  @JsonKey(name: "average_rating")
  final String? averageRating;
  @override
  @JsonKey(name: "review_count")
  final int? reviewCount;
  final List<Image>? _images;
  @override
  @JsonKey(name: "images")
  List<Image>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Category>? _categories;
  @override
  @JsonKey(name: "categories")
  List<Category>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _tags;
  @override
  @JsonKey(name: "tags")
  List<dynamic>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _brands;
  @override
  @JsonKey(name: "brands")
  List<dynamic>? get brands {
    final value = _brands;
    if (value == null) return null;
    if (_brands is EqualUnmodifiableListView) return _brands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ListAllProductsResponseModelAttribute>? _attributes;
  @override
  @JsonKey(name: "attributes")
  List<ListAllProductsResponseModelAttribute>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Variation>? _variations;
  @override
  @JsonKey(name: "variations")
  List<Variation>? get variations {
    final value = _variations;
    if (value == null) return null;
    if (_variations is EqualUnmodifiableListView) return _variations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _groupedProducts;
  @override
  @JsonKey(name: "grouped_products")
  List<dynamic>? get groupedProducts {
    final value = _groupedProducts;
    if (value == null) return null;
    if (_groupedProducts is EqualUnmodifiableListView) return _groupedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: "has_options")
  final bool? hasOptions;
  @override
  @JsonKey(name: "is_purchasable")
  final bool? isPurchasable;
  @override
  @JsonKey(name: "is_in_stock")
  final bool? isInStock;
  @override
  @JsonKey(name: "is_on_backorder")
  final bool? isOnBackorder;
  @override
  @JsonKey(name: "low_stock_remaining")
  final dynamic lowStockRemaining;
  @override
  @JsonKey(name: "stock_availability")
  final StockAvailability? stockAvailability;
  @override
  @JsonKey(name: "sold_individually")
  final bool? soldIndividually;
  @override
  @JsonKey(name: "add_to_cart")
  final AddToCart? addToCart;
  @override
  @JsonKey(name: "extensions")
  final Extensions? extensions;

  @override
  String toString() {
    return 'ListAllProductsResponseModel(id: $id, name: $name, slug: $slug, parent: $parent, type: $type, variation: $variation, permalink: $permalink, sku: $sku, shortDescription: $shortDescription, description: $description, onSale: $onSale, prices: $prices, priceHtml: $priceHtml, averageRating: $averageRating, reviewCount: $reviewCount, images: $images, categories: $categories, tags: $tags, brands: $brands, attributes: $attributes, variations: $variations, groupedProducts: $groupedProducts, hasOptions: $hasOptions, isPurchasable: $isPurchasable, isInStock: $isInStock, isOnBackorder: $isOnBackorder, lowStockRemaining: $lowStockRemaining, stockAvailability: $stockAvailability, soldIndividually: $soldIndividually, addToCart: $addToCart, extensions: $extensions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListAllProductsResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.variation, variation) ||
                other.variation == variation) &&
            (identical(other.permalink, permalink) ||
                other.permalink == permalink) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.onSale, onSale) || other.onSale == onSale) &&
            (identical(other.prices, prices) || other.prices == prices) &&
            (identical(other.priceHtml, priceHtml) ||
                other.priceHtml == priceHtml) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._brands, _brands) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes) &&
            const DeepCollectionEquality()
                .equals(other._variations, _variations) &&
            const DeepCollectionEquality()
                .equals(other._groupedProducts, _groupedProducts) &&
            (identical(other.hasOptions, hasOptions) ||
                other.hasOptions == hasOptions) &&
            (identical(other.isPurchasable, isPurchasable) ||
                other.isPurchasable == isPurchasable) &&
            (identical(other.isInStock, isInStock) ||
                other.isInStock == isInStock) &&
            (identical(other.isOnBackorder, isOnBackorder) ||
                other.isOnBackorder == isOnBackorder) &&
            const DeepCollectionEquality()
                .equals(other.lowStockRemaining, lowStockRemaining) &&
            (identical(other.stockAvailability, stockAvailability) ||
                other.stockAvailability == stockAvailability) &&
            (identical(other.soldIndividually, soldIndividually) ||
                other.soldIndividually == soldIndividually) &&
            (identical(other.addToCart, addToCart) ||
                other.addToCart == addToCart) &&
            (identical(other.extensions, extensions) ||
                other.extensions == extensions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        slug,
        parent,
        type,
        variation,
        permalink,
        sku,
        shortDescription,
        description,
        onSale,
        prices,
        priceHtml,
        averageRating,
        reviewCount,
        const DeepCollectionEquality().hash(_images),
        const DeepCollectionEquality().hash(_categories),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_brands),
        const DeepCollectionEquality().hash(_attributes),
        const DeepCollectionEquality().hash(_variations),
        const DeepCollectionEquality().hash(_groupedProducts),
        hasOptions,
        isPurchasable,
        isInStock,
        isOnBackorder,
        const DeepCollectionEquality().hash(lowStockRemaining),
        stockAvailability,
        soldIndividually,
        addToCart,
        extensions
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListAllProductsResponseModelImplCopyWith<
          _$ListAllProductsResponseModelImpl>
      get copyWith => __$$ListAllProductsResponseModelImplCopyWithImpl<
          _$ListAllProductsResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListAllProductsResponseModelImplToJson(
      this,
    );
  }
}

abstract class _ListAllProductsResponseModel
    implements ListAllProductsResponseModel {
  const factory _ListAllProductsResponseModel(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "name") final String? name,
      @JsonKey(name: "slug") final String? slug,
      @JsonKey(name: "parent") final int? parent,
      @JsonKey(name: "type") final String? type,
      @JsonKey(name: "variation") final String? variation,
      @JsonKey(name: "permalink") final String? permalink,
      @JsonKey(name: "sku") final String? sku,
      @JsonKey(name: "short_description") final String? shortDescription,
      @JsonKey(name: "description") final String? description,
      @JsonKey(name: "on_sale") final bool? onSale,
      @JsonKey(name: "prices") final Prices? prices,
      @JsonKey(name: "price_html") final String? priceHtml,
      @JsonKey(name: "average_rating") final String? averageRating,
      @JsonKey(name: "review_count") final int? reviewCount,
      @JsonKey(name: "images") final List<Image>? images,
      @JsonKey(name: "categories") final List<Category>? categories,
      @JsonKey(name: "tags") final List<dynamic>? tags,
      @JsonKey(name: "brands") final List<dynamic>? brands,
      @JsonKey(name: "attributes")
      final List<ListAllProductsResponseModelAttribute>? attributes,
      @JsonKey(name: "variations") final List<Variation>? variations,
      @JsonKey(name: "grouped_products") final List<dynamic>? groupedProducts,
      @JsonKey(name: "has_options") final bool? hasOptions,
      @JsonKey(name: "is_purchasable") final bool? isPurchasable,
      @JsonKey(name: "is_in_stock") final bool? isInStock,
      @JsonKey(name: "is_on_backorder") final bool? isOnBackorder,
      @JsonKey(name: "low_stock_remaining") final dynamic lowStockRemaining,
      @JsonKey(name: "stock_availability")
      final StockAvailability? stockAvailability,
      @JsonKey(name: "sold_individually") final bool? soldIndividually,
      @JsonKey(name: "add_to_cart") final AddToCart? addToCart,
      @JsonKey(name: "extensions")
      final Extensions? extensions}) = _$ListAllProductsResponseModelImpl;

  factory _ListAllProductsResponseModel.fromJson(Map<String, dynamic> json) =
      _$ListAllProductsResponseModelImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "slug")
  String? get slug;
  @override
  @JsonKey(name: "parent")
  int? get parent;
  @override
  @JsonKey(name: "type")
  String? get type;
  @override
  @JsonKey(name: "variation")
  String? get variation;
  @override
  @JsonKey(name: "permalink")
  String? get permalink;
  @override
  @JsonKey(name: "sku")
  String? get sku;
  @override
  @JsonKey(name: "short_description")
  String? get shortDescription;
  @override
  @JsonKey(name: "description")
  String? get description;
  @override
  @JsonKey(name: "on_sale")
  bool? get onSale;
  @override
  @JsonKey(name: "prices")
  Prices? get prices;
  @override
  @JsonKey(name: "price_html")
  String? get priceHtml;
  @override
  @JsonKey(name: "average_rating")
  String? get averageRating;
  @override
  @JsonKey(name: "review_count")
  int? get reviewCount;
  @override
  @JsonKey(name: "images")
  List<Image>? get images;
  @override
  @JsonKey(name: "categories")
  List<Category>? get categories;
  @override
  @JsonKey(name: "tags")
  List<dynamic>? get tags;
  @override
  @JsonKey(name: "brands")
  List<dynamic>? get brands;
  @override
  @JsonKey(name: "attributes")
  List<ListAllProductsResponseModelAttribute>? get attributes;
  @override
  @JsonKey(name: "variations")
  List<Variation>? get variations;
  @override
  @JsonKey(name: "grouped_products")
  List<dynamic>? get groupedProducts;
  @override
  @JsonKey(name: "has_options")
  bool? get hasOptions;
  @override
  @JsonKey(name: "is_purchasable")
  bool? get isPurchasable;
  @override
  @JsonKey(name: "is_in_stock")
  bool? get isInStock;
  @override
  @JsonKey(name: "is_on_backorder")
  bool? get isOnBackorder;
  @override
  @JsonKey(name: "low_stock_remaining")
  dynamic get lowStockRemaining;
  @override
  @JsonKey(name: "stock_availability")
  StockAvailability? get stockAvailability;
  @override
  @JsonKey(name: "sold_individually")
  bool? get soldIndividually;
  @override
  @JsonKey(name: "add_to_cart")
  AddToCart? get addToCart;
  @override
  @JsonKey(name: "extensions")
  Extensions? get extensions;
  @override
  @JsonKey(ignore: true)
  _$$ListAllProductsResponseModelImplCopyWith<
          _$ListAllProductsResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AddToCart _$AddToCartFromJson(Map<String, dynamic> json) {
  return _AddToCart.fromJson(json);
}

/// @nodoc
mixin _$AddToCart {
  @JsonKey(name: "text")
  String? get text => throw _privateConstructorUsedError;
  @JsonKey(name: "description")
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: "url")
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: "single_text")
  String? get singleText => throw _privateConstructorUsedError;
  @JsonKey(name: "minimum")
  int? get minimum => throw _privateConstructorUsedError;
  @JsonKey(name: "maximum")
  int? get maximum => throw _privateConstructorUsedError;
  @JsonKey(name: "multiple_of")
  int? get multipleOf => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddToCartCopyWith<AddToCart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddToCartCopyWith<$Res> {
  factory $AddToCartCopyWith(AddToCart value, $Res Function(AddToCart) then) =
      _$AddToCartCopyWithImpl<$Res, AddToCart>;
  @useResult
  $Res call(
      {@JsonKey(name: "text") String? text,
      @JsonKey(name: "description") String? description,
      @JsonKey(name: "url") String? url,
      @JsonKey(name: "single_text") String? singleText,
      @JsonKey(name: "minimum") int? minimum,
      @JsonKey(name: "maximum") int? maximum,
      @JsonKey(name: "multiple_of") int? multipleOf});
}

/// @nodoc
class _$AddToCartCopyWithImpl<$Res, $Val extends AddToCart>
    implements $AddToCartCopyWith<$Res> {
  _$AddToCartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? singleText = freezed,
    Object? minimum = freezed,
    Object? maximum = freezed,
    Object? multipleOf = freezed,
  }) {
    return _then(_value.copyWith(
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      singleText: freezed == singleText
          ? _value.singleText
          : singleText // ignore: cast_nullable_to_non_nullable
              as String?,
      minimum: freezed == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as int?,
      maximum: freezed == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as int?,
      multipleOf: freezed == multipleOf
          ? _value.multipleOf
          : multipleOf // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddToCartImplCopyWith<$Res>
    implements $AddToCartCopyWith<$Res> {
  factory _$$AddToCartImplCopyWith(
          _$AddToCartImpl value, $Res Function(_$AddToCartImpl) then) =
      __$$AddToCartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "text") String? text,
      @JsonKey(name: "description") String? description,
      @JsonKey(name: "url") String? url,
      @JsonKey(name: "single_text") String? singleText,
      @JsonKey(name: "minimum") int? minimum,
      @JsonKey(name: "maximum") int? maximum,
      @JsonKey(name: "multiple_of") int? multipleOf});
}

/// @nodoc
class __$$AddToCartImplCopyWithImpl<$Res>
    extends _$AddToCartCopyWithImpl<$Res, _$AddToCartImpl>
    implements _$$AddToCartImplCopyWith<$Res> {
  __$$AddToCartImplCopyWithImpl(
      _$AddToCartImpl _value, $Res Function(_$AddToCartImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? singleText = freezed,
    Object? minimum = freezed,
    Object? maximum = freezed,
    Object? multipleOf = freezed,
  }) {
    return _then(_$AddToCartImpl(
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      singleText: freezed == singleText
          ? _value.singleText
          : singleText // ignore: cast_nullable_to_non_nullable
              as String?,
      minimum: freezed == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as int?,
      maximum: freezed == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as int?,
      multipleOf: freezed == multipleOf
          ? _value.multipleOf
          : multipleOf // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddToCartImpl implements _AddToCart {
  const _$AddToCartImpl(
      {@JsonKey(name: "text") this.text,
      @JsonKey(name: "description") this.description,
      @JsonKey(name: "url") this.url,
      @JsonKey(name: "single_text") this.singleText,
      @JsonKey(name: "minimum") this.minimum,
      @JsonKey(name: "maximum") this.maximum,
      @JsonKey(name: "multiple_of") this.multipleOf});

  factory _$AddToCartImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddToCartImplFromJson(json);

  @override
  @JsonKey(name: "text")
  final String? text;
  @override
  @JsonKey(name: "description")
  final String? description;
  @override
  @JsonKey(name: "url")
  final String? url;
  @override
  @JsonKey(name: "single_text")
  final String? singleText;
  @override
  @JsonKey(name: "minimum")
  final int? minimum;
  @override
  @JsonKey(name: "maximum")
  final int? maximum;
  @override
  @JsonKey(name: "multiple_of")
  final int? multipleOf;

  @override
  String toString() {
    return 'AddToCart(text: $text, description: $description, url: $url, singleText: $singleText, minimum: $minimum, maximum: $maximum, multipleOf: $multipleOf)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddToCartImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.singleText, singleText) ||
                other.singleText == singleText) &&
            (identical(other.minimum, minimum) || other.minimum == minimum) &&
            (identical(other.maximum, maximum) || other.maximum == maximum) &&
            (identical(other.multipleOf, multipleOf) ||
                other.multipleOf == multipleOf));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, text, description, url,
      singleText, minimum, maximum, multipleOf);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddToCartImplCopyWith<_$AddToCartImpl> get copyWith =>
      __$$AddToCartImplCopyWithImpl<_$AddToCartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddToCartImplToJson(
      this,
    );
  }
}

abstract class _AddToCart implements AddToCart {
  const factory _AddToCart(
      {@JsonKey(name: "text") final String? text,
      @JsonKey(name: "description") final String? description,
      @JsonKey(name: "url") final String? url,
      @JsonKey(name: "single_text") final String? singleText,
      @JsonKey(name: "minimum") final int? minimum,
      @JsonKey(name: "maximum") final int? maximum,
      @JsonKey(name: "multiple_of") final int? multipleOf}) = _$AddToCartImpl;

  factory _AddToCart.fromJson(Map<String, dynamic> json) =
      _$AddToCartImpl.fromJson;

  @override
  @JsonKey(name: "text")
  String? get text;
  @override
  @JsonKey(name: "description")
  String? get description;
  @override
  @JsonKey(name: "url")
  String? get url;
  @override
  @JsonKey(name: "single_text")
  String? get singleText;
  @override
  @JsonKey(name: "minimum")
  int? get minimum;
  @override
  @JsonKey(name: "maximum")
  int? get maximum;
  @override
  @JsonKey(name: "multiple_of")
  int? get multipleOf;
  @override
  @JsonKey(ignore: true)
  _$$AddToCartImplCopyWith<_$AddToCartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ListAllProductsResponseModelAttribute
    _$ListAllProductsResponseModelAttributeFromJson(Map<String, dynamic> json) {
  return _ListAllProductsResponseModelAttribute.fromJson(json);
}

/// @nodoc
mixin _$ListAllProductsResponseModelAttribute {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "taxonomy")
  String? get taxonomy => throw _privateConstructorUsedError;
  @JsonKey(name: "has_variations")
  bool? get hasVariations => throw _privateConstructorUsedError;
  @JsonKey(name: "terms")
  List<Term>? get terms => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListAllProductsResponseModelAttributeCopyWith<
          ListAllProductsResponseModelAttribute>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListAllProductsResponseModelAttributeCopyWith<$Res> {
  factory $ListAllProductsResponseModelAttributeCopyWith(
          ListAllProductsResponseModelAttribute value,
          $Res Function(ListAllProductsResponseModelAttribute) then) =
      _$ListAllProductsResponseModelAttributeCopyWithImpl<$Res,
          ListAllProductsResponseModelAttribute>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "taxonomy") String? taxonomy,
      @JsonKey(name: "has_variations") bool? hasVariations,
      @JsonKey(name: "terms") List<Term>? terms});
}

/// @nodoc
class _$ListAllProductsResponseModelAttributeCopyWithImpl<$Res,
        $Val extends ListAllProductsResponseModelAttribute>
    implements $ListAllProductsResponseModelAttributeCopyWith<$Res> {
  _$ListAllProductsResponseModelAttributeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? taxonomy = freezed,
    Object? hasVariations = freezed,
    Object? terms = freezed,
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
      taxonomy: freezed == taxonomy
          ? _value.taxonomy
          : taxonomy // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVariations: freezed == hasVariations
          ? _value.hasVariations
          : hasVariations // ignore: cast_nullable_to_non_nullable
              as bool?,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as List<Term>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListAllProductsResponseModelAttributeImplCopyWith<$Res>
    implements $ListAllProductsResponseModelAttributeCopyWith<$Res> {
  factory _$$ListAllProductsResponseModelAttributeImplCopyWith(
          _$ListAllProductsResponseModelAttributeImpl value,
          $Res Function(_$ListAllProductsResponseModelAttributeImpl) then) =
      __$$ListAllProductsResponseModelAttributeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "taxonomy") String? taxonomy,
      @JsonKey(name: "has_variations") bool? hasVariations,
      @JsonKey(name: "terms") List<Term>? terms});
}

/// @nodoc
class __$$ListAllProductsResponseModelAttributeImplCopyWithImpl<$Res>
    extends _$ListAllProductsResponseModelAttributeCopyWithImpl<$Res,
        _$ListAllProductsResponseModelAttributeImpl>
    implements _$$ListAllProductsResponseModelAttributeImplCopyWith<$Res> {
  __$$ListAllProductsResponseModelAttributeImplCopyWithImpl(
      _$ListAllProductsResponseModelAttributeImpl _value,
      $Res Function(_$ListAllProductsResponseModelAttributeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? taxonomy = freezed,
    Object? hasVariations = freezed,
    Object? terms = freezed,
  }) {
    return _then(_$ListAllProductsResponseModelAttributeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      taxonomy: freezed == taxonomy
          ? _value.taxonomy
          : taxonomy // ignore: cast_nullable_to_non_nullable
              as String?,
      hasVariations: freezed == hasVariations
          ? _value.hasVariations
          : hasVariations // ignore: cast_nullable_to_non_nullable
              as bool?,
      terms: freezed == terms
          ? _value._terms
          : terms // ignore: cast_nullable_to_non_nullable
              as List<Term>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListAllProductsResponseModelAttributeImpl
    implements _ListAllProductsResponseModelAttribute {
  const _$ListAllProductsResponseModelAttributeImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "taxonomy") this.taxonomy,
      @JsonKey(name: "has_variations") this.hasVariations,
      @JsonKey(name: "terms") final List<Term>? terms})
      : _terms = terms;

  factory _$ListAllProductsResponseModelAttributeImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ListAllProductsResponseModelAttributeImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "taxonomy")
  final String? taxonomy;
  @override
  @JsonKey(name: "has_variations")
  final bool? hasVariations;
  final List<Term>? _terms;
  @override
  @JsonKey(name: "terms")
  List<Term>? get terms {
    final value = _terms;
    if (value == null) return null;
    if (_terms is EqualUnmodifiableListView) return _terms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ListAllProductsResponseModelAttribute(id: $id, name: $name, taxonomy: $taxonomy, hasVariations: $hasVariations, terms: $terms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListAllProductsResponseModelAttributeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.taxonomy, taxonomy) ||
                other.taxonomy == taxonomy) &&
            (identical(other.hasVariations, hasVariations) ||
                other.hasVariations == hasVariations) &&
            const DeepCollectionEquality().equals(other._terms, _terms));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, taxonomy,
      hasVariations, const DeepCollectionEquality().hash(_terms));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListAllProductsResponseModelAttributeImplCopyWith<
          _$ListAllProductsResponseModelAttributeImpl>
      get copyWith => __$$ListAllProductsResponseModelAttributeImplCopyWithImpl<
          _$ListAllProductsResponseModelAttributeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListAllProductsResponseModelAttributeImplToJson(
      this,
    );
  }
}

abstract class _ListAllProductsResponseModelAttribute
    implements ListAllProductsResponseModelAttribute {
  const factory _ListAllProductsResponseModelAttribute(
          {@JsonKey(name: "id") final int? id,
          @JsonKey(name: "name") final String? name,
          @JsonKey(name: "taxonomy") final String? taxonomy,
          @JsonKey(name: "has_variations") final bool? hasVariations,
          @JsonKey(name: "terms") final List<Term>? terms}) =
      _$ListAllProductsResponseModelAttributeImpl;

  factory _ListAllProductsResponseModelAttribute.fromJson(
          Map<String, dynamic> json) =
      _$ListAllProductsResponseModelAttributeImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "taxonomy")
  String? get taxonomy;
  @override
  @JsonKey(name: "has_variations")
  bool? get hasVariations;
  @override
  @JsonKey(name: "terms")
  List<Term>? get terms;
  @override
  @JsonKey(ignore: true)
  _$$ListAllProductsResponseModelAttributeImplCopyWith<
          _$ListAllProductsResponseModelAttributeImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Term _$TermFromJson(Map<String, dynamic> json) {
  return _Term.fromJson(json);
}

/// @nodoc
mixin _$Term {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "slug")
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: "default")
  bool? get termDefault => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TermCopyWith<Term> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TermCopyWith<$Res> {
  factory $TermCopyWith(Term value, $Res Function(Term) then) =
      _$TermCopyWithImpl<$Res, Term>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "default") bool? termDefault});
}

/// @nodoc
class _$TermCopyWithImpl<$Res, $Val extends Term>
    implements $TermCopyWith<$Res> {
  _$TermCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? termDefault = freezed,
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
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      termDefault: freezed == termDefault
          ? _value.termDefault
          : termDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TermImplCopyWith<$Res> implements $TermCopyWith<$Res> {
  factory _$$TermImplCopyWith(
          _$TermImpl value, $Res Function(_$TermImpl) then) =
      __$$TermImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "default") bool? termDefault});
}

/// @nodoc
class __$$TermImplCopyWithImpl<$Res>
    extends _$TermCopyWithImpl<$Res, _$TermImpl>
    implements _$$TermImplCopyWith<$Res> {
  __$$TermImplCopyWithImpl(_$TermImpl _value, $Res Function(_$TermImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? termDefault = freezed,
  }) {
    return _then(_$TermImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      termDefault: freezed == termDefault
          ? _value.termDefault
          : termDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TermImpl implements _Term {
  const _$TermImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "slug") this.slug,
      @JsonKey(name: "default") this.termDefault});

  factory _$TermImpl.fromJson(Map<String, dynamic> json) =>
      _$$TermImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "slug")
  final String? slug;
  @override
  @JsonKey(name: "default")
  final bool? termDefault;

  @override
  String toString() {
    return 'Term(id: $id, name: $name, slug: $slug, termDefault: $termDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TermImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.termDefault, termDefault) ||
                other.termDefault == termDefault));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, termDefault);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TermImplCopyWith<_$TermImpl> get copyWith =>
      __$$TermImplCopyWithImpl<_$TermImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TermImplToJson(
      this,
    );
  }
}

abstract class _Term implements Term {
  const factory _Term(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "name") final String? name,
      @JsonKey(name: "slug") final String? slug,
      @JsonKey(name: "default") final bool? termDefault}) = _$TermImpl;

  factory _Term.fromJson(Map<String, dynamic> json) = _$TermImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "slug")
  String? get slug;
  @override
  @JsonKey(name: "default")
  bool? get termDefault;
  @override
  @JsonKey(ignore: true)
  _$$TermImplCopyWith<_$TermImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "slug")
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: "link")
  String? get link => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "link") String? link});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? link = freezed,
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
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
          _$CategoryImpl value, $Res Function(_$CategoryImpl) then) =
      __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "slug") String? slug,
      @JsonKey(name: "link") String? link});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
      _$CategoryImpl _value, $Res Function(_$CategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? link = freezed,
  }) {
    return _then(_$CategoryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryImpl implements _Category {
  const _$CategoryImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "slug") this.slug,
      @JsonKey(name: "link") this.link});

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "slug")
  final String? slug;
  @override
  @JsonKey(name: "link")
  final String? link;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, slug: $slug, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.link, link) || other.link == link));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, link);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(
      this,
    );
  }
}

abstract class _Category implements Category {
  const factory _Category(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "name") final String? name,
      @JsonKey(name: "slug") final String? slug,
      @JsonKey(name: "link") final String? link}) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "slug")
  String? get slug;
  @override
  @JsonKey(name: "link")
  String? get link;
  @override
  @JsonKey(ignore: true)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Extensions _$ExtensionsFromJson(Map<String, dynamic> json) {
  return _Extensions.fromJson(json);
}

/// @nodoc
mixin _$Extensions {
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtensionsCopyWith<$Res> {
  factory $ExtensionsCopyWith(
          Extensions value, $Res Function(Extensions) then) =
      _$ExtensionsCopyWithImpl<$Res, Extensions>;
}

/// @nodoc
class _$ExtensionsCopyWithImpl<$Res, $Val extends Extensions>
    implements $ExtensionsCopyWith<$Res> {
  _$ExtensionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExtensionsImplCopyWith<$Res> {
  factory _$$ExtensionsImplCopyWith(
          _$ExtensionsImpl value, $Res Function(_$ExtensionsImpl) then) =
      __$$ExtensionsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExtensionsImplCopyWithImpl<$Res>
    extends _$ExtensionsCopyWithImpl<$Res, _$ExtensionsImpl>
    implements _$$ExtensionsImplCopyWith<$Res> {
  __$$ExtensionsImplCopyWithImpl(
      _$ExtensionsImpl _value, $Res Function(_$ExtensionsImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$ExtensionsImpl implements _Extensions {
  const _$ExtensionsImpl();

  factory _$ExtensionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtensionsImplFromJson(json);

  @override
  String toString() {
    return 'Extensions()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ExtensionsImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtensionsImplToJson(
      this,
    );
  }
}

abstract class _Extensions implements Extensions {
  const factory _Extensions() = _$ExtensionsImpl;

  factory _Extensions.fromJson(Map<String, dynamic> json) =
      _$ExtensionsImpl.fromJson;
}

Image _$ImageFromJson(Map<String, dynamic> json) {
  return _Image.fromJson(json);
}

/// @nodoc
mixin _$Image {
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
  $ImageCopyWith<Image> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageCopyWith<$Res> {
  factory $ImageCopyWith(Image value, $Res Function(Image) then) =
      _$ImageCopyWithImpl<$Res, Image>;
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
class _$ImageCopyWithImpl<$Res, $Val extends Image>
    implements $ImageCopyWith<$Res> {
  _$ImageCopyWithImpl(this._value, this._then);

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
abstract class _$$ImageImplCopyWith<$Res> implements $ImageCopyWith<$Res> {
  factory _$$ImageImplCopyWith(
          _$ImageImpl value, $Res Function(_$ImageImpl) then) =
      __$$ImageImplCopyWithImpl<$Res>;
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
class __$$ImageImplCopyWithImpl<$Res>
    extends _$ImageCopyWithImpl<$Res, _$ImageImpl>
    implements _$$ImageImplCopyWith<$Res> {
  __$$ImageImplCopyWithImpl(
      _$ImageImpl _value, $Res Function(_$ImageImpl) _then)
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
    return _then(_$ImageImpl(
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
class _$ImageImpl implements _Image {
  const _$ImageImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "src") this.src,
      @JsonKey(name: "thumbnail") this.thumbnail,
      @JsonKey(name: "srcset") this.srcset,
      @JsonKey(name: "sizes") this.sizes,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "alt") this.alt});

  factory _$ImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageImplFromJson(json);

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
    return 'Image(id: $id, src: $src, thumbnail: $thumbnail, srcset: $srcset, sizes: $sizes, name: $name, alt: $alt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageImpl &&
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
  _$$ImageImplCopyWith<_$ImageImpl> get copyWith =>
      __$$ImageImplCopyWithImpl<_$ImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageImplToJson(
      this,
    );
  }
}

abstract class _Image implements Image {
  const factory _Image(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "src") final String? src,
      @JsonKey(name: "thumbnail") final String? thumbnail,
      @JsonKey(name: "srcset") final String? srcset,
      @JsonKey(name: "sizes") final String? sizes,
      @JsonKey(name: "name") final String? name,
      @JsonKey(name: "alt") final String? alt}) = _$ImageImpl;

  factory _Image.fromJson(Map<String, dynamic> json) = _$ImageImpl.fromJson;

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
  _$$ImageImplCopyWith<_$ImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Prices _$PricesFromJson(Map<String, dynamic> json) {
  return _Prices.fromJson(json);
}

/// @nodoc
mixin _$Prices {
  @JsonKey(name: "price")
  String? get price => throw _privateConstructorUsedError;
  @JsonKey(name: "regular_price")
  String? get regularPrice => throw _privateConstructorUsedError;
  @JsonKey(name: "sale_price")
  String? get salePrice => throw _privateConstructorUsedError;
  @JsonKey(name: "price_range")
  dynamic get priceRange => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_code")
  String? get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_symbol")
  String? get currencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_minor_unit")
  int? get currencyMinorUnit => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_decimal_separator")
  String? get currencyDecimalSeparator => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_thousand_separator")
  String? get currencyThousandSeparator => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_prefix")
  String? get currencyPrefix => throw _privateConstructorUsedError;
  @JsonKey(name: "currency_suffix")
  String? get currencySuffix => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PricesCopyWith<Prices> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PricesCopyWith<$Res> {
  factory $PricesCopyWith(Prices value, $Res Function(Prices) then) =
      _$PricesCopyWithImpl<$Res, Prices>;
  @useResult
  $Res call(
      {@JsonKey(name: "price") String? price,
      @JsonKey(name: "regular_price") String? regularPrice,
      @JsonKey(name: "sale_price") String? salePrice,
      @JsonKey(name: "price_range") dynamic priceRange,
      @JsonKey(name: "currency_code") String? currencyCode,
      @JsonKey(name: "currency_symbol") String? currencySymbol,
      @JsonKey(name: "currency_minor_unit") int? currencyMinorUnit,
      @JsonKey(name: "currency_decimal_separator")
      String? currencyDecimalSeparator,
      @JsonKey(name: "currency_thousand_separator")
      String? currencyThousandSeparator,
      @JsonKey(name: "currency_prefix") String? currencyPrefix,
      @JsonKey(name: "currency_suffix") String? currencySuffix});
}

/// @nodoc
class _$PricesCopyWithImpl<$Res, $Val extends Prices>
    implements $PricesCopyWith<$Res> {
  _$PricesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = freezed,
    Object? regularPrice = freezed,
    Object? salePrice = freezed,
    Object? priceRange = freezed,
    Object? currencyCode = freezed,
    Object? currencySymbol = freezed,
    Object? currencyMinorUnit = freezed,
    Object? currencyDecimalSeparator = freezed,
    Object? currencyThousandSeparator = freezed,
    Object? currencyPrefix = freezed,
    Object? currencySuffix = freezed,
  }) {
    return _then(_value.copyWith(
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      regularPrice: freezed == regularPrice
          ? _value.regularPrice
          : regularPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      priceRange: freezed == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as dynamic,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyMinorUnit: freezed == currencyMinorUnit
          ? _value.currencyMinorUnit
          : currencyMinorUnit // ignore: cast_nullable_to_non_nullable
              as int?,
      currencyDecimalSeparator: freezed == currencyDecimalSeparator
          ? _value.currencyDecimalSeparator
          : currencyDecimalSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyThousandSeparator: freezed == currencyThousandSeparator
          ? _value.currencyThousandSeparator
          : currencyThousandSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyPrefix: freezed == currencyPrefix
          ? _value.currencyPrefix
          : currencyPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySuffix: freezed == currencySuffix
          ? _value.currencySuffix
          : currencySuffix // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PricesImplCopyWith<$Res> implements $PricesCopyWith<$Res> {
  factory _$$PricesImplCopyWith(
          _$PricesImpl value, $Res Function(_$PricesImpl) then) =
      __$$PricesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "price") String? price,
      @JsonKey(name: "regular_price") String? regularPrice,
      @JsonKey(name: "sale_price") String? salePrice,
      @JsonKey(name: "price_range") dynamic priceRange,
      @JsonKey(name: "currency_code") String? currencyCode,
      @JsonKey(name: "currency_symbol") String? currencySymbol,
      @JsonKey(name: "currency_minor_unit") int? currencyMinorUnit,
      @JsonKey(name: "currency_decimal_separator")
      String? currencyDecimalSeparator,
      @JsonKey(name: "currency_thousand_separator")
      String? currencyThousandSeparator,
      @JsonKey(name: "currency_prefix") String? currencyPrefix,
      @JsonKey(name: "currency_suffix") String? currencySuffix});
}

/// @nodoc
class __$$PricesImplCopyWithImpl<$Res>
    extends _$PricesCopyWithImpl<$Res, _$PricesImpl>
    implements _$$PricesImplCopyWith<$Res> {
  __$$PricesImplCopyWithImpl(
      _$PricesImpl _value, $Res Function(_$PricesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = freezed,
    Object? regularPrice = freezed,
    Object? salePrice = freezed,
    Object? priceRange = freezed,
    Object? currencyCode = freezed,
    Object? currencySymbol = freezed,
    Object? currencyMinorUnit = freezed,
    Object? currencyDecimalSeparator = freezed,
    Object? currencyThousandSeparator = freezed,
    Object? currencyPrefix = freezed,
    Object? currencySuffix = freezed,
  }) {
    return _then(_$PricesImpl(
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      regularPrice: freezed == regularPrice
          ? _value.regularPrice
          : regularPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      priceRange: freezed == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as dynamic,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyMinorUnit: freezed == currencyMinorUnit
          ? _value.currencyMinorUnit
          : currencyMinorUnit // ignore: cast_nullable_to_non_nullable
              as int?,
      currencyDecimalSeparator: freezed == currencyDecimalSeparator
          ? _value.currencyDecimalSeparator
          : currencyDecimalSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyThousandSeparator: freezed == currencyThousandSeparator
          ? _value.currencyThousandSeparator
          : currencyThousandSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyPrefix: freezed == currencyPrefix
          ? _value.currencyPrefix
          : currencyPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySuffix: freezed == currencySuffix
          ? _value.currencySuffix
          : currencySuffix // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PricesImpl implements _Prices {
  const _$PricesImpl(
      {@JsonKey(name: "price") this.price,
      @JsonKey(name: "regular_price") this.regularPrice,
      @JsonKey(name: "sale_price") this.salePrice,
      @JsonKey(name: "price_range") this.priceRange,
      @JsonKey(name: "currency_code") this.currencyCode,
      @JsonKey(name: "currency_symbol") this.currencySymbol,
      @JsonKey(name: "currency_minor_unit") this.currencyMinorUnit,
      @JsonKey(name: "currency_decimal_separator")
      this.currencyDecimalSeparator,
      @JsonKey(name: "currency_thousand_separator")
      this.currencyThousandSeparator,
      @JsonKey(name: "currency_prefix") this.currencyPrefix,
      @JsonKey(name: "currency_suffix") this.currencySuffix});

  factory _$PricesImpl.fromJson(Map<String, dynamic> json) =>
      _$$PricesImplFromJson(json);

  @override
  @JsonKey(name: "price")
  final String? price;
  @override
  @JsonKey(name: "regular_price")
  final String? regularPrice;
  @override
  @JsonKey(name: "sale_price")
  final String? salePrice;
  @override
  @JsonKey(name: "price_range")
  final dynamic priceRange;
  @override
  @JsonKey(name: "currency_code")
  final String? currencyCode;
  @override
  @JsonKey(name: "currency_symbol")
  final String? currencySymbol;
  @override
  @JsonKey(name: "currency_minor_unit")
  final int? currencyMinorUnit;
  @override
  @JsonKey(name: "currency_decimal_separator")
  final String? currencyDecimalSeparator;
  @override
  @JsonKey(name: "currency_thousand_separator")
  final String? currencyThousandSeparator;
  @override
  @JsonKey(name: "currency_prefix")
  final String? currencyPrefix;
  @override
  @JsonKey(name: "currency_suffix")
  final String? currencySuffix;

  @override
  String toString() {
    return 'Prices(price: $price, regularPrice: $regularPrice, salePrice: $salePrice, priceRange: $priceRange, currencyCode: $currencyCode, currencySymbol: $currencySymbol, currencyMinorUnit: $currencyMinorUnit, currencyDecimalSeparator: $currencyDecimalSeparator, currencyThousandSeparator: $currencyThousandSeparator, currencyPrefix: $currencyPrefix, currencySuffix: $currencySuffix)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PricesImpl &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.regularPrice, regularPrice) ||
                other.regularPrice == regularPrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            const DeepCollectionEquality()
                .equals(other.priceRange, priceRange) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyMinorUnit, currencyMinorUnit) ||
                other.currencyMinorUnit == currencyMinorUnit) &&
            (identical(
                    other.currencyDecimalSeparator, currencyDecimalSeparator) ||
                other.currencyDecimalSeparator == currencyDecimalSeparator) &&
            (identical(other.currencyThousandSeparator,
                    currencyThousandSeparator) ||
                other.currencyThousandSeparator == currencyThousandSeparator) &&
            (identical(other.currencyPrefix, currencyPrefix) ||
                other.currencyPrefix == currencyPrefix) &&
            (identical(other.currencySuffix, currencySuffix) ||
                other.currencySuffix == currencySuffix));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      price,
      regularPrice,
      salePrice,
      const DeepCollectionEquality().hash(priceRange),
      currencyCode,
      currencySymbol,
      currencyMinorUnit,
      currencyDecimalSeparator,
      currencyThousandSeparator,
      currencyPrefix,
      currencySuffix);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PricesImplCopyWith<_$PricesImpl> get copyWith =>
      __$$PricesImplCopyWithImpl<_$PricesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PricesImplToJson(
      this,
    );
  }
}

abstract class _Prices implements Prices {
  const factory _Prices(
          {@JsonKey(name: "price") final String? price,
          @JsonKey(name: "regular_price") final String? regularPrice,
          @JsonKey(name: "sale_price") final String? salePrice,
          @JsonKey(name: "price_range") final dynamic priceRange,
          @JsonKey(name: "currency_code") final String? currencyCode,
          @JsonKey(name: "currency_symbol") final String? currencySymbol,
          @JsonKey(name: "currency_minor_unit") final int? currencyMinorUnit,
          @JsonKey(name: "currency_decimal_separator")
          final String? currencyDecimalSeparator,
          @JsonKey(name: "currency_thousand_separator")
          final String? currencyThousandSeparator,
          @JsonKey(name: "currency_prefix") final String? currencyPrefix,
          @JsonKey(name: "currency_suffix") final String? currencySuffix}) =
      _$PricesImpl;

  factory _Prices.fromJson(Map<String, dynamic> json) = _$PricesImpl.fromJson;

  @override
  @JsonKey(name: "price")
  String? get price;
  @override
  @JsonKey(name: "regular_price")
  String? get regularPrice;
  @override
  @JsonKey(name: "sale_price")
  String? get salePrice;
  @override
  @JsonKey(name: "price_range")
  dynamic get priceRange;
  @override
  @JsonKey(name: "currency_code")
  String? get currencyCode;
  @override
  @JsonKey(name: "currency_symbol")
  String? get currencySymbol;
  @override
  @JsonKey(name: "currency_minor_unit")
  int? get currencyMinorUnit;
  @override
  @JsonKey(name: "currency_decimal_separator")
  String? get currencyDecimalSeparator;
  @override
  @JsonKey(name: "currency_thousand_separator")
  String? get currencyThousandSeparator;
  @override
  @JsonKey(name: "currency_prefix")
  String? get currencyPrefix;
  @override
  @JsonKey(name: "currency_suffix")
  String? get currencySuffix;
  @override
  @JsonKey(ignore: true)
  _$$PricesImplCopyWith<_$PricesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockAvailability _$StockAvailabilityFromJson(Map<String, dynamic> json) {
  return _StockAvailability.fromJson(json);
}

/// @nodoc
mixin _$StockAvailability {
  @JsonKey(name: "text")
  String? get text => throw _privateConstructorUsedError;
  @JsonKey(name: "class")
  String? get stockAvailabilityClass => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockAvailabilityCopyWith<StockAvailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAvailabilityCopyWith<$Res> {
  factory $StockAvailabilityCopyWith(
          StockAvailability value, $Res Function(StockAvailability) then) =
      _$StockAvailabilityCopyWithImpl<$Res, StockAvailability>;
  @useResult
  $Res call(
      {@JsonKey(name: "text") String? text,
      @JsonKey(name: "class") String? stockAvailabilityClass});
}

/// @nodoc
class _$StockAvailabilityCopyWithImpl<$Res, $Val extends StockAvailability>
    implements $StockAvailabilityCopyWith<$Res> {
  _$StockAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = freezed,
    Object? stockAvailabilityClass = freezed,
  }) {
    return _then(_value.copyWith(
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      stockAvailabilityClass: freezed == stockAvailabilityClass
          ? _value.stockAvailabilityClass
          : stockAvailabilityClass // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockAvailabilityImplCopyWith<$Res>
    implements $StockAvailabilityCopyWith<$Res> {
  factory _$$StockAvailabilityImplCopyWith(_$StockAvailabilityImpl value,
          $Res Function(_$StockAvailabilityImpl) then) =
      __$$StockAvailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "text") String? text,
      @JsonKey(name: "class") String? stockAvailabilityClass});
}

/// @nodoc
class __$$StockAvailabilityImplCopyWithImpl<$Res>
    extends _$StockAvailabilityCopyWithImpl<$Res, _$StockAvailabilityImpl>
    implements _$$StockAvailabilityImplCopyWith<$Res> {
  __$$StockAvailabilityImplCopyWithImpl(_$StockAvailabilityImpl _value,
      $Res Function(_$StockAvailabilityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = freezed,
    Object? stockAvailabilityClass = freezed,
  }) {
    return _then(_$StockAvailabilityImpl(
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      stockAvailabilityClass: freezed == stockAvailabilityClass
          ? _value.stockAvailabilityClass
          : stockAvailabilityClass // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAvailabilityImpl implements _StockAvailability {
  const _$StockAvailabilityImpl(
      {@JsonKey(name: "text") this.text,
      @JsonKey(name: "class") this.stockAvailabilityClass});

  factory _$StockAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAvailabilityImplFromJson(json);

  @override
  @JsonKey(name: "text")
  final String? text;
  @override
  @JsonKey(name: "class")
  final String? stockAvailabilityClass;

  @override
  String toString() {
    return 'StockAvailability(text: $text, stockAvailabilityClass: $stockAvailabilityClass)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAvailabilityImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.stockAvailabilityClass, stockAvailabilityClass) ||
                other.stockAvailabilityClass == stockAvailabilityClass));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, text, stockAvailabilityClass);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAvailabilityImplCopyWith<_$StockAvailabilityImpl> get copyWith =>
      __$$StockAvailabilityImplCopyWithImpl<_$StockAvailabilityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAvailabilityImplToJson(
      this,
    );
  }
}

abstract class _StockAvailability implements StockAvailability {
  const factory _StockAvailability(
          {@JsonKey(name: "text") final String? text,
          @JsonKey(name: "class") final String? stockAvailabilityClass}) =
      _$StockAvailabilityImpl;

  factory _StockAvailability.fromJson(Map<String, dynamic> json) =
      _$StockAvailabilityImpl.fromJson;

  @override
  @JsonKey(name: "text")
  String? get text;
  @override
  @JsonKey(name: "class")
  String? get stockAvailabilityClass;
  @override
  @JsonKey(ignore: true)
  _$$StockAvailabilityImplCopyWith<_$StockAvailabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Variation _$VariationFromJson(Map<String, dynamic> json) {
  return _Variation.fromJson(json);
}

/// @nodoc
mixin _$Variation {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "attributes")
  List<VariationAttribute>? get attributes =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VariationCopyWith<Variation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariationCopyWith<$Res> {
  factory $VariationCopyWith(Variation value, $Res Function(Variation) then) =
      _$VariationCopyWithImpl<$Res, Variation>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "attributes") List<VariationAttribute>? attributes});
}

/// @nodoc
class _$VariationCopyWithImpl<$Res, $Val extends Variation>
    implements $VariationCopyWith<$Res> {
  _$VariationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? attributes = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      attributes: freezed == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<VariationAttribute>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VariationImplCopyWith<$Res>
    implements $VariationCopyWith<$Res> {
  factory _$$VariationImplCopyWith(
          _$VariationImpl value, $Res Function(_$VariationImpl) then) =
      __$$VariationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "attributes") List<VariationAttribute>? attributes});
}

/// @nodoc
class __$$VariationImplCopyWithImpl<$Res>
    extends _$VariationCopyWithImpl<$Res, _$VariationImpl>
    implements _$$VariationImplCopyWith<$Res> {
  __$$VariationImplCopyWithImpl(
      _$VariationImpl _value, $Res Function(_$VariationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? attributes = freezed,
  }) {
    return _then(_$VariationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      attributes: freezed == attributes
          ? _value._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<VariationAttribute>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VariationImpl implements _Variation {
  const _$VariationImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "attributes") final List<VariationAttribute>? attributes})
      : _attributes = attributes;

  factory _$VariationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariationImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  final List<VariationAttribute>? _attributes;
  @override
  @JsonKey(name: "attributes")
  List<VariationAttribute>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Variation(id: $id, attributes: $attributes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariationImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, const DeepCollectionEquality().hash(_attributes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VariationImplCopyWith<_$VariationImpl> get copyWith =>
      __$$VariationImplCopyWithImpl<_$VariationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariationImplToJson(
      this,
    );
  }
}

abstract class _Variation implements Variation {
  const factory _Variation(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "attributes")
      final List<VariationAttribute>? attributes}) = _$VariationImpl;

  factory _Variation.fromJson(Map<String, dynamic> json) =
      _$VariationImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id;
  @override
  @JsonKey(name: "attributes")
  List<VariationAttribute>? get attributes;
  @override
  @JsonKey(ignore: true)
  _$$VariationImplCopyWith<_$VariationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VariationAttribute _$VariationAttributeFromJson(Map<String, dynamic> json) {
  return _VariationAttribute.fromJson(json);
}

/// @nodoc
mixin _$VariationAttribute {
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "value")
  String? get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VariationAttributeCopyWith<VariationAttribute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariationAttributeCopyWith<$Res> {
  factory $VariationAttributeCopyWith(
          VariationAttribute value, $Res Function(VariationAttribute) then) =
      _$VariationAttributeCopyWithImpl<$Res, VariationAttribute>;
  @useResult
  $Res call(
      {@JsonKey(name: "name") String? name,
      @JsonKey(name: "value") String? value});
}

/// @nodoc
class _$VariationAttributeCopyWithImpl<$Res, $Val extends VariationAttribute>
    implements $VariationAttributeCopyWith<$Res> {
  _$VariationAttributeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VariationAttributeImplCopyWith<$Res>
    implements $VariationAttributeCopyWith<$Res> {
  factory _$$VariationAttributeImplCopyWith(_$VariationAttributeImpl value,
          $Res Function(_$VariationAttributeImpl) then) =
      __$$VariationAttributeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "name") String? name,
      @JsonKey(name: "value") String? value});
}

/// @nodoc
class __$$VariationAttributeImplCopyWithImpl<$Res>
    extends _$VariationAttributeCopyWithImpl<$Res, _$VariationAttributeImpl>
    implements _$$VariationAttributeImplCopyWith<$Res> {
  __$$VariationAttributeImplCopyWithImpl(_$VariationAttributeImpl _value,
      $Res Function(_$VariationAttributeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
  }) {
    return _then(_$VariationAttributeImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VariationAttributeImpl implements _VariationAttribute {
  const _$VariationAttributeImpl(
      {@JsonKey(name: "name") this.name, @JsonKey(name: "value") this.value});

  factory _$VariationAttributeImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariationAttributeImplFromJson(json);

  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "value")
  final String? value;

  @override
  String toString() {
    return 'VariationAttribute(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariationAttributeImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VariationAttributeImplCopyWith<_$VariationAttributeImpl> get copyWith =>
      __$$VariationAttributeImplCopyWithImpl<_$VariationAttributeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariationAttributeImplToJson(
      this,
    );
  }
}

abstract class _VariationAttribute implements VariationAttribute {
  const factory _VariationAttribute(
      {@JsonKey(name: "name") final String? name,
      @JsonKey(name: "value") final String? value}) = _$VariationAttributeImpl;

  factory _VariationAttribute.fromJson(Map<String, dynamic> json) =
      _$VariationAttributeImpl.fromJson;

  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "value")
  String? get value;
  @override
  @JsonKey(ignore: true)
  _$$VariationAttributeImplCopyWith<_$VariationAttributeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
