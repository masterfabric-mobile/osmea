// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_filter_options_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetFilterOptionsResponseModel _$GetFilterOptionsResponseModelFromJson(
    Map<String, dynamic> json) {
  return _GetFilterOptionsResponseModel.fromJson(json);
}

/// @nodoc
mixin _$GetFilterOptionsResponseModel {
  @JsonKey(name: 'sort_options')
  List<SortOptionModel> get sortOptions => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_statuses')
  List<StockStatusModel> get stockStatuses =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'price_range')
  PriceRangeModel get priceRange => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_attributes')
  List<FilterAttributeModel>? get availableAttributes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'categories')
  List<FilterCategoryModel>? get categories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'tags')
  List<FilterTagModel>? get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetFilterOptionsResponseModelCopyWith<GetFilterOptionsResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetFilterOptionsResponseModelCopyWith<$Res> {
  factory $GetFilterOptionsResponseModelCopyWith(
          GetFilterOptionsResponseModel value,
          $Res Function(GetFilterOptionsResponseModel) then) =
      _$GetFilterOptionsResponseModelCopyWithImpl<$Res,
          GetFilterOptionsResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'sort_options') List<SortOptionModel> sortOptions,
      @JsonKey(name: 'stock_statuses') List<StockStatusModel> stockStatuses,
      @JsonKey(name: 'price_range') PriceRangeModel priceRange,
      @JsonKey(name: 'available_attributes')
      List<FilterAttributeModel>? availableAttributes,
      @JsonKey(name: 'categories') List<FilterCategoryModel>? categories,
      @JsonKey(name: 'tags') List<FilterTagModel>? tags});

  $PriceRangeModelCopyWith<$Res> get priceRange;
}

/// @nodoc
class _$GetFilterOptionsResponseModelCopyWithImpl<$Res,
        $Val extends GetFilterOptionsResponseModel>
    implements $GetFilterOptionsResponseModelCopyWith<$Res> {
  _$GetFilterOptionsResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortOptions = null,
    Object? stockStatuses = null,
    Object? priceRange = null,
    Object? availableAttributes = freezed,
    Object? categories = freezed,
    Object? tags = freezed,
  }) {
    return _then(_value.copyWith(
      sortOptions: null == sortOptions
          ? _value.sortOptions
          : sortOptions // ignore: cast_nullable_to_non_nullable
              as List<SortOptionModel>,
      stockStatuses: null == stockStatuses
          ? _value.stockStatuses
          : stockStatuses // ignore: cast_nullable_to_non_nullable
              as List<StockStatusModel>,
      priceRange: null == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as PriceRangeModel,
      availableAttributes: freezed == availableAttributes
          ? _value.availableAttributes
          : availableAttributes // ignore: cast_nullable_to_non_nullable
              as List<FilterAttributeModel>?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<FilterCategoryModel>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<FilterTagModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PriceRangeModelCopyWith<$Res> get priceRange {
    return $PriceRangeModelCopyWith<$Res>(_value.priceRange, (value) {
      return _then(_value.copyWith(priceRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetFilterOptionsResponseModelImplCopyWith<$Res>
    implements $GetFilterOptionsResponseModelCopyWith<$Res> {
  factory _$$GetFilterOptionsResponseModelImplCopyWith(
          _$GetFilterOptionsResponseModelImpl value,
          $Res Function(_$GetFilterOptionsResponseModelImpl) then) =
      __$$GetFilterOptionsResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'sort_options') List<SortOptionModel> sortOptions,
      @JsonKey(name: 'stock_statuses') List<StockStatusModel> stockStatuses,
      @JsonKey(name: 'price_range') PriceRangeModel priceRange,
      @JsonKey(name: 'available_attributes')
      List<FilterAttributeModel>? availableAttributes,
      @JsonKey(name: 'categories') List<FilterCategoryModel>? categories,
      @JsonKey(name: 'tags') List<FilterTagModel>? tags});

  @override
  $PriceRangeModelCopyWith<$Res> get priceRange;
}

/// @nodoc
class __$$GetFilterOptionsResponseModelImplCopyWithImpl<$Res>
    extends _$GetFilterOptionsResponseModelCopyWithImpl<$Res,
        _$GetFilterOptionsResponseModelImpl>
    implements _$$GetFilterOptionsResponseModelImplCopyWith<$Res> {
  __$$GetFilterOptionsResponseModelImplCopyWithImpl(
      _$GetFilterOptionsResponseModelImpl _value,
      $Res Function(_$GetFilterOptionsResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortOptions = null,
    Object? stockStatuses = null,
    Object? priceRange = null,
    Object? availableAttributes = freezed,
    Object? categories = freezed,
    Object? tags = freezed,
  }) {
    return _then(_$GetFilterOptionsResponseModelImpl(
      sortOptions: null == sortOptions
          ? _value._sortOptions
          : sortOptions // ignore: cast_nullable_to_non_nullable
              as List<SortOptionModel>,
      stockStatuses: null == stockStatuses
          ? _value._stockStatuses
          : stockStatuses // ignore: cast_nullable_to_non_nullable
              as List<StockStatusModel>,
      priceRange: null == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as PriceRangeModel,
      availableAttributes: freezed == availableAttributes
          ? _value._availableAttributes
          : availableAttributes // ignore: cast_nullable_to_non_nullable
              as List<FilterAttributeModel>?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<FilterCategoryModel>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<FilterTagModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetFilterOptionsResponseModelImpl
    implements _GetFilterOptionsResponseModel {
  const _$GetFilterOptionsResponseModelImpl(
      {@JsonKey(name: 'sort_options')
      required final List<SortOptionModel> sortOptions,
      @JsonKey(name: 'stock_statuses')
      required final List<StockStatusModel> stockStatuses,
      @JsonKey(name: 'price_range') required this.priceRange,
      @JsonKey(name: 'available_attributes')
      final List<FilterAttributeModel>? availableAttributes,
      @JsonKey(name: 'categories') final List<FilterCategoryModel>? categories,
      @JsonKey(name: 'tags') final List<FilterTagModel>? tags})
      : _sortOptions = sortOptions,
        _stockStatuses = stockStatuses,
        _availableAttributes = availableAttributes,
        _categories = categories,
        _tags = tags;

  factory _$GetFilterOptionsResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetFilterOptionsResponseModelImplFromJson(json);

  final List<SortOptionModel> _sortOptions;
  @override
  @JsonKey(name: 'sort_options')
  List<SortOptionModel> get sortOptions {
    if (_sortOptions is EqualUnmodifiableListView) return _sortOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sortOptions);
  }

  final List<StockStatusModel> _stockStatuses;
  @override
  @JsonKey(name: 'stock_statuses')
  List<StockStatusModel> get stockStatuses {
    if (_stockStatuses is EqualUnmodifiableListView) return _stockStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockStatuses);
  }

  @override
  @JsonKey(name: 'price_range')
  final PriceRangeModel priceRange;
  final List<FilterAttributeModel>? _availableAttributes;
  @override
  @JsonKey(name: 'available_attributes')
  List<FilterAttributeModel>? get availableAttributes {
    final value = _availableAttributes;
    if (value == null) return null;
    if (_availableAttributes is EqualUnmodifiableListView)
      return _availableAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<FilterCategoryModel>? _categories;
  @override
  @JsonKey(name: 'categories')
  List<FilterCategoryModel>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<FilterTagModel>? _tags;
  @override
  @JsonKey(name: 'tags')
  List<FilterTagModel>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GetFilterOptionsResponseModel(sortOptions: $sortOptions, stockStatuses: $stockStatuses, priceRange: $priceRange, availableAttributes: $availableAttributes, categories: $categories, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetFilterOptionsResponseModelImpl &&
            const DeepCollectionEquality()
                .equals(other._sortOptions, _sortOptions) &&
            const DeepCollectionEquality()
                .equals(other._stockStatuses, _stockStatuses) &&
            (identical(other.priceRange, priceRange) ||
                other.priceRange == priceRange) &&
            const DeepCollectionEquality()
                .equals(other._availableAttributes, _availableAttributes) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sortOptions),
      const DeepCollectionEquality().hash(_stockStatuses),
      priceRange,
      const DeepCollectionEquality().hash(_availableAttributes),
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetFilterOptionsResponseModelImplCopyWith<
          _$GetFilterOptionsResponseModelImpl>
      get copyWith => __$$GetFilterOptionsResponseModelImplCopyWithImpl<
          _$GetFilterOptionsResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetFilterOptionsResponseModelImplToJson(
      this,
    );
  }
}

abstract class _GetFilterOptionsResponseModel
    implements GetFilterOptionsResponseModel {
  const factory _GetFilterOptionsResponseModel(
      {@JsonKey(name: 'sort_options')
      required final List<SortOptionModel> sortOptions,
      @JsonKey(name: 'stock_statuses')
      required final List<StockStatusModel> stockStatuses,
      @JsonKey(name: 'price_range') required final PriceRangeModel priceRange,
      @JsonKey(name: 'available_attributes')
      final List<FilterAttributeModel>? availableAttributes,
      @JsonKey(name: 'categories') final List<FilterCategoryModel>? categories,
      @JsonKey(name: 'tags')
      final List<FilterTagModel>? tags}) = _$GetFilterOptionsResponseModelImpl;

  factory _GetFilterOptionsResponseModel.fromJson(Map<String, dynamic> json) =
      _$GetFilterOptionsResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'sort_options')
  List<SortOptionModel> get sortOptions;
  @override
  @JsonKey(name: 'stock_statuses')
  List<StockStatusModel> get stockStatuses;
  @override
  @JsonKey(name: 'price_range')
  PriceRangeModel get priceRange;
  @override
  @JsonKey(name: 'available_attributes')
  List<FilterAttributeModel>? get availableAttributes;
  @override
  @JsonKey(name: 'categories')
  List<FilterCategoryModel>? get categories;
  @override
  @JsonKey(name: 'tags')
  List<FilterTagModel>? get tags;
  @override
  @JsonKey(ignore: true)
  _$$GetFilterOptionsResponseModelImplCopyWith<
          _$GetFilterOptionsResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SortOptionModel _$SortOptionModelFromJson(Map<String, dynamic> json) {
  return _SortOptionModel.fromJson(json);
}

/// @nodoc
mixin _$SortOptionModel {
  @JsonKey(name: 'key')
  String get key =>
      throw _privateConstructorUsedError; // 'date', 'price', 'title', etc.
  @JsonKey(name: 'label')
  String get label =>
      throw _privateConstructorUsedError; // 'Date', 'Price', 'Name', etc.
  @JsonKey(name: 'orders')
  List<OrderOptionModel> get orders =>
      throw _privateConstructorUsedError; // Available order directions
  @JsonKey(name: 'enabled')
  bool get enabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SortOptionModelCopyWith<SortOptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortOptionModelCopyWith<$Res> {
  factory $SortOptionModelCopyWith(
          SortOptionModel value, $Res Function(SortOptionModel) then) =
      _$SortOptionModelCopyWithImpl<$Res, SortOptionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String key,
      @JsonKey(name: 'label') String label,
      @JsonKey(name: 'orders') List<OrderOptionModel> orders,
      @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class _$SortOptionModelCopyWithImpl<$Res, $Val extends SortOptionModel>
    implements $SortOptionModelCopyWith<$Res> {
  _$SortOptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? orders = null,
    Object? enabled = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderOptionModel>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SortOptionModelImplCopyWith<$Res>
    implements $SortOptionModelCopyWith<$Res> {
  factory _$$SortOptionModelImplCopyWith(_$SortOptionModelImpl value,
          $Res Function(_$SortOptionModelImpl) then) =
      __$$SortOptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String key,
      @JsonKey(name: 'label') String label,
      @JsonKey(name: 'orders') List<OrderOptionModel> orders,
      @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class __$$SortOptionModelImplCopyWithImpl<$Res>
    extends _$SortOptionModelCopyWithImpl<$Res, _$SortOptionModelImpl>
    implements _$$SortOptionModelImplCopyWith<$Res> {
  __$$SortOptionModelImplCopyWithImpl(
      _$SortOptionModelImpl _value, $Res Function(_$SortOptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? orders = null,
    Object? enabled = null,
  }) {
    return _then(_$SortOptionModelImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderOptionModel>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SortOptionModelImpl implements _SortOptionModel {
  const _$SortOptionModelImpl(
      {@JsonKey(name: 'key') required this.key,
      @JsonKey(name: 'label') required this.label,
      @JsonKey(name: 'orders') required final List<OrderOptionModel> orders,
      @JsonKey(name: 'enabled') this.enabled = true})
      : _orders = orders;

  factory _$SortOptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SortOptionModelImplFromJson(json);

  @override
  @JsonKey(name: 'key')
  final String key;
// 'date', 'price', 'title', etc.
  @override
  @JsonKey(name: 'label')
  final String label;
// 'Date', 'Price', 'Name', etc.
  final List<OrderOptionModel> _orders;
// 'Date', 'Price', 'Name', etc.
  @override
  @JsonKey(name: 'orders')
  List<OrderOptionModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

// Available order directions
  @override
  @JsonKey(name: 'enabled')
  final bool enabled;

  @override
  String toString() {
    return 'SortOptionModel(key: $key, label: $label, orders: $orders, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortOptionModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, label,
      const DeepCollectionEquality().hash(_orders), enabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SortOptionModelImplCopyWith<_$SortOptionModelImpl> get copyWith =>
      __$$SortOptionModelImplCopyWithImpl<_$SortOptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SortOptionModelImplToJson(
      this,
    );
  }
}

abstract class _SortOptionModel implements SortOptionModel {
  const factory _SortOptionModel(
      {@JsonKey(name: 'key') required final String key,
      @JsonKey(name: 'label') required final String label,
      @JsonKey(name: 'orders') required final List<OrderOptionModel> orders,
      @JsonKey(name: 'enabled') final bool enabled}) = _$SortOptionModelImpl;

  factory _SortOptionModel.fromJson(Map<String, dynamic> json) =
      _$SortOptionModelImpl.fromJson;

  @override
  @JsonKey(name: 'key')
  String get key;
  @override // 'date', 'price', 'title', etc.
  @JsonKey(name: 'label')
  String get label;
  @override // 'Date', 'Price', 'Name', etc.
  @JsonKey(name: 'orders')
  List<OrderOptionModel> get orders;
  @override // Available order directions
  @JsonKey(name: 'enabled')
  bool get enabled;
  @override
  @JsonKey(ignore: true)
  _$$SortOptionModelImplCopyWith<_$SortOptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderOptionModel _$OrderOptionModelFromJson(Map<String, dynamic> json) {
  return _OrderOptionModel.fromJson(json);
}

/// @nodoc
mixin _$OrderOptionModel {
  @JsonKey(name: 'key')
  String get key => throw _privateConstructorUsedError; // 'asc' or 'desc'
  @JsonKey(name: 'label')
  String get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderOptionModelCopyWith<OrderOptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderOptionModelCopyWith<$Res> {
  factory $OrderOptionModelCopyWith(
          OrderOptionModel value, $Res Function(OrderOptionModel) then) =
      _$OrderOptionModelCopyWithImpl<$Res, OrderOptionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String key, @JsonKey(name: 'label') String label});
}

/// @nodoc
class _$OrderOptionModelCopyWithImpl<$Res, $Val extends OrderOptionModel>
    implements $OrderOptionModelCopyWith<$Res> {
  _$OrderOptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderOptionModelImplCopyWith<$Res>
    implements $OrderOptionModelCopyWith<$Res> {
  factory _$$OrderOptionModelImplCopyWith(_$OrderOptionModelImpl value,
          $Res Function(_$OrderOptionModelImpl) then) =
      __$$OrderOptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String key, @JsonKey(name: 'label') String label});
}

/// @nodoc
class __$$OrderOptionModelImplCopyWithImpl<$Res>
    extends _$OrderOptionModelCopyWithImpl<$Res, _$OrderOptionModelImpl>
    implements _$$OrderOptionModelImplCopyWith<$Res> {
  __$$OrderOptionModelImplCopyWithImpl(_$OrderOptionModelImpl _value,
      $Res Function(_$OrderOptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
  }) {
    return _then(_$OrderOptionModelImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderOptionModelImpl implements _OrderOptionModel {
  const _$OrderOptionModelImpl(
      {@JsonKey(name: 'key') required this.key,
      @JsonKey(name: 'label') required this.label});

  factory _$OrderOptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderOptionModelImplFromJson(json);

  @override
  @JsonKey(name: 'key')
  final String key;
// 'asc' or 'desc'
  @override
  @JsonKey(name: 'label')
  final String label;

  @override
  String toString() {
    return 'OrderOptionModel(key: $key, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderOptionModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderOptionModelImplCopyWith<_$OrderOptionModelImpl> get copyWith =>
      __$$OrderOptionModelImplCopyWithImpl<_$OrderOptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderOptionModelImplToJson(
      this,
    );
  }
}

abstract class _OrderOptionModel implements OrderOptionModel {
  const factory _OrderOptionModel(
          {@JsonKey(name: 'key') required final String key,
          @JsonKey(name: 'label') required final String label}) =
      _$OrderOptionModelImpl;

  factory _OrderOptionModel.fromJson(Map<String, dynamic> json) =
      _$OrderOptionModelImpl.fromJson;

  @override
  @JsonKey(name: 'key')
  String get key;
  @override // 'asc' or 'desc'
  @JsonKey(name: 'label')
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$OrderOptionModelImplCopyWith<_$OrderOptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockStatusModel _$StockStatusModelFromJson(Map<String, dynamic> json) {
  return _StockStatusModel.fromJson(json);
}

/// @nodoc
mixin _$StockStatusModel {
  @JsonKey(name: 'key')
  String get key =>
      throw _privateConstructorUsedError; // 'instock', 'outofstock', etc.
  @JsonKey(name: 'label')
  String get label =>
      throw _privateConstructorUsedError; // 'In Stock', 'Out of Stock', etc.
  @JsonKey(name: 'enabled')
  bool get enabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockStatusModelCopyWith<StockStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockStatusModelCopyWith<$Res> {
  factory $StockStatusModelCopyWith(
          StockStatusModel value, $Res Function(StockStatusModel) then) =
      _$StockStatusModelCopyWithImpl<$Res, StockStatusModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String key,
      @JsonKey(name: 'label') String label,
      @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class _$StockStatusModelCopyWithImpl<$Res, $Val extends StockStatusModel>
    implements $StockStatusModelCopyWith<$Res> {
  _$StockStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? enabled = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockStatusModelImplCopyWith<$Res>
    implements $StockStatusModelCopyWith<$Res> {
  factory _$$StockStatusModelImplCopyWith(_$StockStatusModelImpl value,
          $Res Function(_$StockStatusModelImpl) then) =
      __$$StockStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String key,
      @JsonKey(name: 'label') String label,
      @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class __$$StockStatusModelImplCopyWithImpl<$Res>
    extends _$StockStatusModelCopyWithImpl<$Res, _$StockStatusModelImpl>
    implements _$$StockStatusModelImplCopyWith<$Res> {
  __$$StockStatusModelImplCopyWithImpl(_$StockStatusModelImpl _value,
      $Res Function(_$StockStatusModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? enabled = null,
  }) {
    return _then(_$StockStatusModelImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockStatusModelImpl implements _StockStatusModel {
  const _$StockStatusModelImpl(
      {@JsonKey(name: 'key') required this.key,
      @JsonKey(name: 'label') required this.label,
      @JsonKey(name: 'enabled') this.enabled = true});

  factory _$StockStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockStatusModelImplFromJson(json);

  @override
  @JsonKey(name: 'key')
  final String key;
// 'instock', 'outofstock', etc.
  @override
  @JsonKey(name: 'label')
  final String label;
// 'In Stock', 'Out of Stock', etc.
  @override
  @JsonKey(name: 'enabled')
  final bool enabled;

  @override
  String toString() {
    return 'StockStatusModel(key: $key, label: $label, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockStatusModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, label, enabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockStatusModelImplCopyWith<_$StockStatusModelImpl> get copyWith =>
      __$$StockStatusModelImplCopyWithImpl<_$StockStatusModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockStatusModelImplToJson(
      this,
    );
  }
}

abstract class _StockStatusModel implements StockStatusModel {
  const factory _StockStatusModel(
      {@JsonKey(name: 'key') required final String key,
      @JsonKey(name: 'label') required final String label,
      @JsonKey(name: 'enabled') final bool enabled}) = _$StockStatusModelImpl;

  factory _StockStatusModel.fromJson(Map<String, dynamic> json) =
      _$StockStatusModelImpl.fromJson;

  @override
  @JsonKey(name: 'key')
  String get key;
  @override // 'instock', 'outofstock', etc.
  @JsonKey(name: 'label')
  String get label;
  @override // 'In Stock', 'Out of Stock', etc.
  @JsonKey(name: 'enabled')
  bool get enabled;
  @override
  @JsonKey(ignore: true)
  _$$StockStatusModelImplCopyWith<_$StockStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceRangeModel _$PriceRangeModelFromJson(Map<String, dynamic> json) {
  return _PriceRangeModel.fromJson(json);
}

/// @nodoc
mixin _$PriceRangeModel {
  @JsonKey(name: 'min_price')
  double get minPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_price')
  double get maxPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_symbol')
  String? get currencySymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_minor_unit')
  int? get currencyMinorUnit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PriceRangeModelCopyWith<PriceRangeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceRangeModelCopyWith<$Res> {
  factory $PriceRangeModelCopyWith(
          PriceRangeModel value, $Res Function(PriceRangeModel) then) =
      _$PriceRangeModelCopyWithImpl<$Res, PriceRangeModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'min_price') double minPrice,
      @JsonKey(name: 'max_price') double maxPrice,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'currency_symbol') String? currencySymbol,
      @JsonKey(name: 'currency_minor_unit') int? currencyMinorUnit});
}

/// @nodoc
class _$PriceRangeModelCopyWithImpl<$Res, $Val extends PriceRangeModel>
    implements $PriceRangeModelCopyWith<$Res> {
  _$PriceRangeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minPrice = null,
    Object? maxPrice = null,
    Object? currency = freezed,
    Object? currencySymbol = freezed,
    Object? currencyMinorUnit = freezed,
  }) {
    return _then(_value.copyWith(
      minPrice: null == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxPrice: null == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyMinorUnit: freezed == currencyMinorUnit
          ? _value.currencyMinorUnit
          : currencyMinorUnit // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceRangeModelImplCopyWith<$Res>
    implements $PriceRangeModelCopyWith<$Res> {
  factory _$$PriceRangeModelImplCopyWith(_$PriceRangeModelImpl value,
          $Res Function(_$PriceRangeModelImpl) then) =
      __$$PriceRangeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'min_price') double minPrice,
      @JsonKey(name: 'max_price') double maxPrice,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'currency_symbol') String? currencySymbol,
      @JsonKey(name: 'currency_minor_unit') int? currencyMinorUnit});
}

/// @nodoc
class __$$PriceRangeModelImplCopyWithImpl<$Res>
    extends _$PriceRangeModelCopyWithImpl<$Res, _$PriceRangeModelImpl>
    implements _$$PriceRangeModelImplCopyWith<$Res> {
  __$$PriceRangeModelImplCopyWithImpl(
      _$PriceRangeModelImpl _value, $Res Function(_$PriceRangeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minPrice = null,
    Object? maxPrice = null,
    Object? currency = freezed,
    Object? currencySymbol = freezed,
    Object? currencyMinorUnit = freezed,
  }) {
    return _then(_$PriceRangeModelImpl(
      minPrice: null == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxPrice: null == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyMinorUnit: freezed == currencyMinorUnit
          ? _value.currencyMinorUnit
          : currencyMinorUnit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceRangeModelImpl implements _PriceRangeModel {
  const _$PriceRangeModelImpl(
      {@JsonKey(name: 'min_price') required this.minPrice,
      @JsonKey(name: 'max_price') required this.maxPrice,
      @JsonKey(name: 'currency') this.currency,
      @JsonKey(name: 'currency_symbol') this.currencySymbol,
      @JsonKey(name: 'currency_minor_unit') this.currencyMinorUnit});

  factory _$PriceRangeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceRangeModelImplFromJson(json);

  @override
  @JsonKey(name: 'min_price')
  final double minPrice;
  @override
  @JsonKey(name: 'max_price')
  final double maxPrice;
  @override
  @JsonKey(name: 'currency')
  final String? currency;
  @override
  @JsonKey(name: 'currency_symbol')
  final String? currencySymbol;
  @override
  @JsonKey(name: 'currency_minor_unit')
  final int? currencyMinorUnit;

  @override
  String toString() {
    return 'PriceRangeModel(minPrice: $minPrice, maxPrice: $maxPrice, currency: $currency, currencySymbol: $currencySymbol, currencyMinorUnit: $currencyMinorUnit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceRangeModelImpl &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyMinorUnit, currencyMinorUnit) ||
                other.currencyMinorUnit == currencyMinorUnit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, minPrice, maxPrice, currency,
      currencySymbol, currencyMinorUnit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceRangeModelImplCopyWith<_$PriceRangeModelImpl> get copyWith =>
      __$$PriceRangeModelImplCopyWithImpl<_$PriceRangeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceRangeModelImplToJson(
      this,
    );
  }
}

abstract class _PriceRangeModel implements PriceRangeModel {
  const factory _PriceRangeModel(
          {@JsonKey(name: 'min_price') required final double minPrice,
          @JsonKey(name: 'max_price') required final double maxPrice,
          @JsonKey(name: 'currency') final String? currency,
          @JsonKey(name: 'currency_symbol') final String? currencySymbol,
          @JsonKey(name: 'currency_minor_unit') final int? currencyMinorUnit}) =
      _$PriceRangeModelImpl;

  factory _PriceRangeModel.fromJson(Map<String, dynamic> json) =
      _$PriceRangeModelImpl.fromJson;

  @override
  @JsonKey(name: 'min_price')
  double get minPrice;
  @override
  @JsonKey(name: 'max_price')
  double get maxPrice;
  @override
  @JsonKey(name: 'currency')
  String? get currency;
  @override
  @JsonKey(name: 'currency_symbol')
  String? get currencySymbol;
  @override
  @JsonKey(name: 'currency_minor_unit')
  int? get currencyMinorUnit;
  @override
  @JsonKey(ignore: true)
  _$$PriceRangeModelImplCopyWith<_$PriceRangeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FilterAttributeModel _$FilterAttributeModelFromJson(Map<String, dynamic> json) {
  return _FilterAttributeModel.fromJson(json);
}

/// @nodoc
mixin _$FilterAttributeModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'terms')
  List<FilterTermModel> get terms => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterAttributeModelCopyWith<FilterAttributeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterAttributeModelCopyWith<$Res> {
  factory $FilterAttributeModelCopyWith(FilterAttributeModel value,
          $Res Function(FilterAttributeModel) then) =
      _$FilterAttributeModelCopyWithImpl<$Res, FilterAttributeModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'terms') List<FilterTermModel> terms});
}

/// @nodoc
class _$FilterAttributeModelCopyWithImpl<$Res,
        $Val extends FilterAttributeModel>
    implements $FilterAttributeModelCopyWith<$Res> {
  _$FilterAttributeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? terms = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      terms: null == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as List<FilterTermModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterAttributeModelImplCopyWith<$Res>
    implements $FilterAttributeModelCopyWith<$Res> {
  factory _$$FilterAttributeModelImplCopyWith(_$FilterAttributeModelImpl value,
          $Res Function(_$FilterAttributeModelImpl) then) =
      __$$FilterAttributeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'terms') List<FilterTermModel> terms});
}

/// @nodoc
class __$$FilterAttributeModelImplCopyWithImpl<$Res>
    extends _$FilterAttributeModelCopyWithImpl<$Res, _$FilterAttributeModelImpl>
    implements _$$FilterAttributeModelImplCopyWith<$Res> {
  __$$FilterAttributeModelImplCopyWithImpl(_$FilterAttributeModelImpl _value,
      $Res Function(_$FilterAttributeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? terms = null,
  }) {
    return _then(_$FilterAttributeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      terms: null == terms
          ? _value._terms
          : terms // ignore: cast_nullable_to_non_nullable
              as List<FilterTermModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterAttributeModelImpl implements _FilterAttributeModel {
  const _$FilterAttributeModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'slug') required this.slug,
      @JsonKey(name: 'terms') required final List<FilterTermModel> terms})
      : _terms = terms;

  factory _$FilterAttributeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterAttributeModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'slug')
  final String slug;
  final List<FilterTermModel> _terms;
  @override
  @JsonKey(name: 'terms')
  List<FilterTermModel> get terms {
    if (_terms is EqualUnmodifiableListView) return _terms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_terms);
  }

  @override
  String toString() {
    return 'FilterAttributeModel(id: $id, name: $name, slug: $slug, terms: $terms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterAttributeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            const DeepCollectionEquality().equals(other._terms, _terms));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, slug, const DeepCollectionEquality().hash(_terms));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterAttributeModelImplCopyWith<_$FilterAttributeModelImpl>
      get copyWith =>
          __$$FilterAttributeModelImplCopyWithImpl<_$FilterAttributeModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterAttributeModelImplToJson(
      this,
    );
  }
}

abstract class _FilterAttributeModel implements FilterAttributeModel {
  const factory _FilterAttributeModel(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'slug') required final String slug,
          @JsonKey(name: 'terms') required final List<FilterTermModel> terms}) =
      _$FilterAttributeModelImpl;

  factory _FilterAttributeModel.fromJson(Map<String, dynamic> json) =
      _$FilterAttributeModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'slug')
  String get slug;
  @override
  @JsonKey(name: 'terms')
  List<FilterTermModel> get terms;
  @override
  @JsonKey(ignore: true)
  _$$FilterAttributeModelImplCopyWith<_$FilterAttributeModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FilterTermModel _$FilterTermModelFromJson(Map<String, dynamic> json) {
  return _FilterTermModel.fromJson(json);
}

/// @nodoc
mixin _$FilterTermModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  int? get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterTermModelCopyWith<FilterTermModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterTermModelCopyWith<$Res> {
  factory $FilterTermModelCopyWith(
          FilterTermModel value, $Res Function(FilterTermModel) then) =
      _$FilterTermModelCopyWithImpl<$Res, FilterTermModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'count') int? count});
}

/// @nodoc
class _$FilterTermModelCopyWithImpl<$Res, $Val extends FilterTermModel>
    implements $FilterTermModelCopyWith<$Res> {
  _$FilterTermModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? count = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterTermModelImplCopyWith<$Res>
    implements $FilterTermModelCopyWith<$Res> {
  factory _$$FilterTermModelImplCopyWith(_$FilterTermModelImpl value,
          $Res Function(_$FilterTermModelImpl) then) =
      __$$FilterTermModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'count') int? count});
}

/// @nodoc
class __$$FilterTermModelImplCopyWithImpl<$Res>
    extends _$FilterTermModelCopyWithImpl<$Res, _$FilterTermModelImpl>
    implements _$$FilterTermModelImplCopyWith<$Res> {
  __$$FilterTermModelImplCopyWithImpl(
      _$FilterTermModelImpl _value, $Res Function(_$FilterTermModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? count = freezed,
  }) {
    return _then(_$FilterTermModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterTermModelImpl implements _FilterTermModel {
  const _$FilterTermModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'slug') required this.slug,
      @JsonKey(name: 'count') this.count});

  factory _$FilterTermModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterTermModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'slug')
  final String slug;
  @override
  @JsonKey(name: 'count')
  final int? count;

  @override
  String toString() {
    return 'FilterTermModel(id: $id, name: $name, slug: $slug, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterTermModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterTermModelImplCopyWith<_$FilterTermModelImpl> get copyWith =>
      __$$FilterTermModelImplCopyWithImpl<_$FilterTermModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterTermModelImplToJson(
      this,
    );
  }
}

abstract class _FilterTermModel implements FilterTermModel {
  const factory _FilterTermModel(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'slug') required final String slug,
      @JsonKey(name: 'count') final int? count}) = _$FilterTermModelImpl;

  factory _FilterTermModel.fromJson(Map<String, dynamic> json) =
      _$FilterTermModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'slug')
  String get slug;
  @override
  @JsonKey(name: 'count')
  int? get count;
  @override
  @JsonKey(ignore: true)
  _$$FilterTermModelImplCopyWith<_$FilterTermModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FilterCategoryModel _$FilterCategoryModelFromJson(Map<String, dynamic> json) {
  return _FilterCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$FilterCategoryModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  int? get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterCategoryModelCopyWith<FilterCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterCategoryModelCopyWith<$Res> {
  factory $FilterCategoryModelCopyWith(
          FilterCategoryModel value, $Res Function(FilterCategoryModel) then) =
      _$FilterCategoryModelCopyWithImpl<$Res, FilterCategoryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'count') int? count});
}

/// @nodoc
class _$FilterCategoryModelCopyWithImpl<$Res, $Val extends FilterCategoryModel>
    implements $FilterCategoryModelCopyWith<$Res> {
  _$FilterCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? count = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterCategoryModelImplCopyWith<$Res>
    implements $FilterCategoryModelCopyWith<$Res> {
  factory _$$FilterCategoryModelImplCopyWith(_$FilterCategoryModelImpl value,
          $Res Function(_$FilterCategoryModelImpl) then) =
      __$$FilterCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'count') int? count});
}

/// @nodoc
class __$$FilterCategoryModelImplCopyWithImpl<$Res>
    extends _$FilterCategoryModelCopyWithImpl<$Res, _$FilterCategoryModelImpl>
    implements _$$FilterCategoryModelImplCopyWith<$Res> {
  __$$FilterCategoryModelImplCopyWithImpl(_$FilterCategoryModelImpl _value,
      $Res Function(_$FilterCategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? count = freezed,
  }) {
    return _then(_$FilterCategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterCategoryModelImpl implements _FilterCategoryModel {
  const _$FilterCategoryModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'slug') required this.slug,
      @JsonKey(name: 'count') this.count});

  factory _$FilterCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterCategoryModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'slug')
  final String slug;
  @override
  @JsonKey(name: 'count')
  final int? count;

  @override
  String toString() {
    return 'FilterCategoryModel(id: $id, name: $name, slug: $slug, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterCategoryModelImplCopyWith<_$FilterCategoryModelImpl> get copyWith =>
      __$$FilterCategoryModelImplCopyWithImpl<_$FilterCategoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _FilterCategoryModel implements FilterCategoryModel {
  const factory _FilterCategoryModel(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'slug') required final String slug,
      @JsonKey(name: 'count') final int? count}) = _$FilterCategoryModelImpl;

  factory _FilterCategoryModel.fromJson(Map<String, dynamic> json) =
      _$FilterCategoryModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'slug')
  String get slug;
  @override
  @JsonKey(name: 'count')
  int? get count;
  @override
  @JsonKey(ignore: true)
  _$$FilterCategoryModelImplCopyWith<_$FilterCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FilterTagModel _$FilterTagModelFromJson(Map<String, dynamic> json) {
  return _FilterTagModel.fromJson(json);
}

/// @nodoc
mixin _$FilterTagModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  int? get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterTagModelCopyWith<FilterTagModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterTagModelCopyWith<$Res> {
  factory $FilterTagModelCopyWith(
          FilterTagModel value, $Res Function(FilterTagModel) then) =
      _$FilterTagModelCopyWithImpl<$Res, FilterTagModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'count') int? count});
}

/// @nodoc
class _$FilterTagModelCopyWithImpl<$Res, $Val extends FilterTagModel>
    implements $FilterTagModelCopyWith<$Res> {
  _$FilterTagModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? count = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterTagModelImplCopyWith<$Res>
    implements $FilterTagModelCopyWith<$Res> {
  factory _$$FilterTagModelImplCopyWith(_$FilterTagModelImpl value,
          $Res Function(_$FilterTagModelImpl) then) =
      __$$FilterTagModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'count') int? count});
}

/// @nodoc
class __$$FilterTagModelImplCopyWithImpl<$Res>
    extends _$FilterTagModelCopyWithImpl<$Res, _$FilterTagModelImpl>
    implements _$$FilterTagModelImplCopyWith<$Res> {
  __$$FilterTagModelImplCopyWithImpl(
      _$FilterTagModelImpl _value, $Res Function(_$FilterTagModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? count = freezed,
  }) {
    return _then(_$FilterTagModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterTagModelImpl implements _FilterTagModel {
  const _$FilterTagModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'slug') required this.slug,
      @JsonKey(name: 'count') this.count});

  factory _$FilterTagModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterTagModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'slug')
  final String slug;
  @override
  @JsonKey(name: 'count')
  final int? count;

  @override
  String toString() {
    return 'FilterTagModel(id: $id, name: $name, slug: $slug, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterTagModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterTagModelImplCopyWith<_$FilterTagModelImpl> get copyWith =>
      __$$FilterTagModelImplCopyWithImpl<_$FilterTagModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterTagModelImplToJson(
      this,
    );
  }
}

abstract class _FilterTagModel implements FilterTagModel {
  const factory _FilterTagModel(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'slug') required final String slug,
      @JsonKey(name: 'count') final int? count}) = _$FilterTagModelImpl;

  factory _FilterTagModel.fromJson(Map<String, dynamic> json) =
      _$FilterTagModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'slug')
  String get slug;
  @override
  @JsonKey(name: 'count')
  int? get count;
  @override
  @JsonKey(ignore: true)
  _$$FilterTagModelImplCopyWith<_$FilterTagModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
