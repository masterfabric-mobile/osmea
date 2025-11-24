// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_filter_options_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetFilterOptionsResponseModelImpl
    _$$GetFilterOptionsResponseModelImplFromJson(Map<String, dynamic> json) =>
        _$GetFilterOptionsResponseModelImpl(
          sortOptions: (json['sort_options'] as List<dynamic>)
              .map((e) => SortOptionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          stockStatuses: (json['stock_statuses'] as List<dynamic>)
              .map((e) => StockStatusModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          priceRange: PriceRangeModel.fromJson(
              json['price_range'] as Map<String, dynamic>),
          availableAttributes: (json['available_attributes'] as List<dynamic>?)
              ?.map((e) =>
                  FilterAttributeModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          categories: (json['categories'] as List<dynamic>?)
              ?.map((e) =>
                  FilterCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => FilterTagModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$GetFilterOptionsResponseModelImplToJson(
    _$GetFilterOptionsResponseModelImpl instance) {
  final val = <String, dynamic>{
    'sort_options': instance.sortOptions.map((e) => e.toJson()).toList(),
    'stock_statuses': instance.stockStatuses.map((e) => e.toJson()).toList(),
    'price_range': instance.priceRange.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('available_attributes',
      instance.availableAttributes?.map((e) => e.toJson()).toList());
  writeNotNull(
      'categories', instance.categories?.map((e) => e.toJson()).toList());
  writeNotNull('tags', instance.tags?.map((e) => e.toJson()).toList());
  return val;
}

_$SortOptionModelImpl _$$SortOptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SortOptionModelImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$SortOptionModelImplToJson(
        _$SortOptionModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'orders': instance.orders.map((e) => e.toJson()).toList(),
      'enabled': instance.enabled,
    };

_$OrderOptionModelImpl _$$OrderOptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderOptionModelImpl(
      key: json['key'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$$OrderOptionModelImplToJson(
        _$OrderOptionModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
    };

_$StockStatusModelImpl _$$StockStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StockStatusModelImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$StockStatusModelImplToJson(
        _$StockStatusModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'enabled': instance.enabled,
    };

_$PriceRangeModelImpl _$$PriceRangeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PriceRangeModelImpl(
      minPrice: (json['min_price'] as num).toDouble(),
      maxPrice: (json['max_price'] as num).toDouble(),
      currency: json['currency'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      currencyMinorUnit: (json['currency_minor_unit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PriceRangeModelImplToJson(
    _$PriceRangeModelImpl instance) {
  final val = <String, dynamic>{
    'min_price': instance.minPrice,
    'max_price': instance.maxPrice,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('currency', instance.currency);
  writeNotNull('currency_symbol', instance.currencySymbol);
  writeNotNull('currency_minor_unit', instance.currencyMinorUnit);
  return val;
}

_$FilterAttributeModelImpl _$$FilterAttributeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FilterAttributeModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      terms: (json['terms'] as List<dynamic>)
          .map((e) => FilterTermModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FilterAttributeModelImplToJson(
        _$FilterAttributeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'terms': instance.terms.map((e) => e.toJson()).toList(),
    };

_$FilterTermModelImpl _$$FilterTermModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FilterTermModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FilterTermModelImplToJson(
    _$FilterTermModelImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'slug': instance.slug,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('count', instance.count);
  return val;
}

_$FilterCategoryModelImpl _$$FilterCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FilterCategoryModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FilterCategoryModelImplToJson(
    _$FilterCategoryModelImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'slug': instance.slug,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('count', instance.count);
  return val;
}

_$FilterTagModelImpl _$$FilterTagModelImplFromJson(Map<String, dynamic> json) =>
    _$FilterTagModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FilterTagModelImplToJson(
    _$FilterTagModelImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'slug': instance.slug,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('count', instance.count);
  return val;
}
