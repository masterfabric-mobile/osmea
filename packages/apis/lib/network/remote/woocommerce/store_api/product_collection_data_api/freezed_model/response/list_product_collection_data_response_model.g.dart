// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_product_collection_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListProductCollectionDataResponseModelImpl
    _$$ListProductCollectionDataResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$ListProductCollectionDataResponseModelImpl(
          priceRange: json['price_range'] == null
              ? null
              : PriceRange.fromJson(
                  json['price_range'] as Map<String, dynamic>),
          attributeCounts: (json['attribute_counts'] as List<dynamic>?)
              ?.map((e) => Count.fromJson(e as Map<String, dynamic>))
              .toList(),
          ratingCounts: (json['rating_counts'] as List<dynamic>?)
              ?.map((e) => RatingCount.fromJson(e as Map<String, dynamic>))
              .toList(),
          taxonomyCounts: (json['taxonomy_counts'] as List<dynamic>?)
              ?.map((e) => Count.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$ListProductCollectionDataResponseModelImplToJson(
    _$ListProductCollectionDataResponseModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('price_range', instance.priceRange?.toJson());
  writeNotNull('attribute_counts',
      instance.attributeCounts?.map((e) => e.toJson()).toList());
  writeNotNull(
      'rating_counts', instance.ratingCounts?.map((e) => e.toJson()).toList());
  writeNotNull('taxonomy_counts',
      instance.taxonomyCounts?.map((e) => e.toJson()).toList());
  return val;
}

_$CountImpl _$$CountImplFromJson(Map<String, dynamic> json) => _$CountImpl(
      term: (json['term'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CountImplToJson(_$CountImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('term', instance.term);
  writeNotNull('count', instance.count);
  return val;
}

_$PriceRangeImpl _$$PriceRangeImplFromJson(Map<String, dynamic> json) =>
    _$PriceRangeImpl(
      currencyMinorUnit: (json['currency_minor_unit'] as num?)?.toInt(),
      minPrice: json['min_price'] as String?,
      maxPrice: json['max_price'] as String?,
      currencyCode: json['currency_code'] as String?,
      currencyDecimalSeparator: json['currency_decimal_separator'] as String?,
      currencyPrefix: json['currency_prefix'] as String?,
      currencySuffix: json['currency_suffix'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      currencyThousandSeparator: json['currency_thousand_separator'] as String?,
    );

Map<String, dynamic> _$$PriceRangeImplToJson(_$PriceRangeImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('currency_minor_unit', instance.currencyMinorUnit);
  writeNotNull('min_price', instance.minPrice);
  writeNotNull('max_price', instance.maxPrice);
  writeNotNull('currency_code', instance.currencyCode);
  writeNotNull('currency_decimal_separator', instance.currencyDecimalSeparator);
  writeNotNull('currency_prefix', instance.currencyPrefix);
  writeNotNull('currency_suffix', instance.currencySuffix);
  writeNotNull('currency_symbol', instance.currencySymbol);
  writeNotNull(
      'currency_thousand_separator', instance.currencyThousandSeparator);
  return val;
}

_$RatingCountImpl _$$RatingCountImplFromJson(Map<String, dynamic> json) =>
    _$RatingCountImpl(
      rating: (json['rating'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RatingCountImplToJson(_$RatingCountImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('rating', instance.rating);
  writeNotNull('count', instance.count);
  return val;
}
