import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_filter_options_response_model.freezed.dart';
part 'get_filter_options_response_model.g.dart';

/// 🎯 WooCommerce Store API Filter Options Response Model
/// Contains available filter options for product filtering
@freezed
class GetFilterOptionsResponseModel with _$GetFilterOptionsResponseModel {
  const factory GetFilterOptionsResponseModel({
    @JsonKey(name: 'sort_options') required List<SortOptionModel> sortOptions,
    @JsonKey(name: 'stock_statuses') required List<StockStatusModel> stockStatuses,
    @JsonKey(name: 'price_range') required PriceRangeModel priceRange,
    @JsonKey(name: 'available_attributes') List<FilterAttributeModel>? availableAttributes,
    @JsonKey(name: 'categories') List<FilterCategoryModel>? categories,
    @JsonKey(name: 'tags') List<FilterTagModel>? tags,
  }) = _GetFilterOptionsResponseModel;

  factory GetFilterOptionsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetFilterOptionsResponseModelFromJson(json);
}

/// 🔄 Sort Option Model
@freezed
class SortOptionModel with _$SortOptionModel {
  const factory SortOptionModel({
    @JsonKey(name: 'key') required String key, // 'date', 'price', 'title', etc.
    @JsonKey(name: 'label') required String label, // 'Date', 'Price', 'Name', etc.
    @JsonKey(name: 'orders') required List<OrderOptionModel> orders, // Available order directions
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
  }) = _SortOptionModel;

  factory SortOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SortOptionModelFromJson(json);
}

/// 📊 Order Option Model (asc/desc)
@freezed
class OrderOptionModel with _$OrderOptionModel {
  const factory OrderOptionModel({
    @JsonKey(name: 'key') required String key, // 'asc' or 'desc'
    @JsonKey(name: 'label') required String label, // 'Ascending', 'Descending'
  }) = _OrderOptionModel;

  factory OrderOptionModel.fromJson(Map<String, dynamic> json) =>
      _$OrderOptionModelFromJson(json);
}

/// 📦 Stock Status Model
@freezed
class StockStatusModel with _$StockStatusModel {
  const factory StockStatusModel({
    @JsonKey(name: 'key') required String key, // 'instock', 'outofstock', etc.
    @JsonKey(name: 'label') required String label, // 'In Stock', 'Out of Stock', etc.
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
  }) = _StockStatusModel;

  factory StockStatusModel.fromJson(Map<String, dynamic> json) =>
      _$StockStatusModelFromJson(json);
}

/// 💰 Price Range Model
@freezed
class PriceRangeModel with _$PriceRangeModel {
  const factory PriceRangeModel({
    @JsonKey(name: 'min_price') required double minPrice,
    @JsonKey(name: 'max_price') required double maxPrice,
    @JsonKey(name: 'currency') String? currency,
    @JsonKey(name: 'currency_symbol') String? currencySymbol,
    @JsonKey(name: 'currency_minor_unit') int? currencyMinorUnit,
  }) = _PriceRangeModel;

  factory PriceRangeModel.fromJson(Map<String, dynamic> json) =>
      _$PriceRangeModelFromJson(json);
}

/// 🏷️ Filter Attribute Model
@freezed
class FilterAttributeModel with _$FilterAttributeModel {
  const factory FilterAttributeModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'slug') required String slug,
    @JsonKey(name: 'terms') required List<FilterTermModel> terms,
  }) = _FilterAttributeModel;

  factory FilterAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$FilterAttributeModelFromJson(json);
}

/// 🔖 Filter Term Model
@freezed
class FilterTermModel with _$FilterTermModel {
  const factory FilterTermModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'slug') required String slug,
    @JsonKey(name: 'count') int? count, // Number of products with this term
  }) = _FilterTermModel;

  factory FilterTermModel.fromJson(Map<String, dynamic> json) =>
      _$FilterTermModelFromJson(json);
}

/// 📂 Filter Category Model
@freezed
class FilterCategoryModel with _$FilterCategoryModel {
  const factory FilterCategoryModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'slug') required String slug,
    @JsonKey(name: 'count') int? count, // Number of products in this category
  }) = _FilterCategoryModel;

  factory FilterCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$FilterCategoryModelFromJson(json);
}

/// 🏷️ Filter Tag Model
@freezed
class FilterTagModel with _$FilterTagModel {
  const factory FilterTagModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'slug') required String slug,
    @JsonKey(name: 'count') int? count, // Number of products with this tag
  }) = _FilterTagModel;

  factory FilterTagModel.fromJson(Map<String, dynamic> json) =>
      _$FilterTagModelFromJson(json);
}