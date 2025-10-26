// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_product_variations_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListProductVariationsResponseModelImpl
    _$$ListProductVariationsResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$ListProductVariationsResponseModelImpl(
          id: (json['id'] as num?)?.toInt(),
          name: json['name'] as String?,
          slug: json['slug'] as String?,
          parent: (json['parent'] as num?)?.toInt(),
          type: json['type'] as String?,
          variation: json['variation'] as String?,
          permalink: json['permalink'] as String?,
          sku: json['sku'] as String?,
          shortDescription: json['short_description'] as String?,
          description: json['description'] as String?,
          onSale: json['on_sale'] as bool?,
          prices: json['prices'] == null
              ? null
              : Prices.fromJson(json['prices'] as Map<String, dynamic>),
          priceHtml: json['price_html'] as String?,
          averageRating: json['average_rating'] as String?,
          reviewCount: (json['review_count'] as num?)?.toInt(),
          images: (json['images'] as List<dynamic>?)
              ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
              .toList(),
          categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList(),
          tags: json['tags'] as List<dynamic>?,
          brands: json['brands'] as List<dynamic>?,
          attributes: json['attributes'] as List<dynamic>?,
          variations: json['variations'] as List<dynamic>?,
          groupedProducts: json['grouped_products'] as List<dynamic>?,
          hasOptions: json['has_options'] as bool?,
          isPurchasable: json['is_purchasable'] as bool?,
          isInStock: json['is_in_stock'] as bool?,
          isOnBackorder: json['is_on_backorder'] as bool?,
          lowStockRemaining: json['low_stock_remaining'],
          stockAvailability: json['stock_availability'] == null
              ? null
              : StockAvailability.fromJson(
                  json['stock_availability'] as Map<String, dynamic>),
          soldIndividually: json['sold_individually'] as bool?,
          addToCart: json['add_to_cart'] == null
              ? null
              : AddToCart.fromJson(json['add_to_cart'] as Map<String, dynamic>),
          extensions: json['extensions'] == null
              ? null
              : Extensions.fromJson(json['extensions'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$ListProductVariationsResponseModelImplToJson(
    _$ListProductVariationsResponseModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('slug', instance.slug);
  writeNotNull('parent', instance.parent);
  writeNotNull('type', instance.type);
  writeNotNull('variation', instance.variation);
  writeNotNull('permalink', instance.permalink);
  writeNotNull('sku', instance.sku);
  writeNotNull('short_description', instance.shortDescription);
  writeNotNull('description', instance.description);
  writeNotNull('on_sale', instance.onSale);
  writeNotNull('prices', instance.prices?.toJson());
  writeNotNull('price_html', instance.priceHtml);
  writeNotNull('average_rating', instance.averageRating);
  writeNotNull('review_count', instance.reviewCount);
  writeNotNull('images', instance.images?.map((e) => e.toJson()).toList());
  writeNotNull(
      'categories', instance.categories?.map((e) => e.toJson()).toList());
  writeNotNull('tags', instance.tags);
  writeNotNull('brands', instance.brands);
  writeNotNull('attributes', instance.attributes);
  writeNotNull('variations', instance.variations);
  writeNotNull('grouped_products', instance.groupedProducts);
  writeNotNull('has_options', instance.hasOptions);
  writeNotNull('is_purchasable', instance.isPurchasable);
  writeNotNull('is_in_stock', instance.isInStock);
  writeNotNull('is_on_backorder', instance.isOnBackorder);
  writeNotNull('low_stock_remaining', instance.lowStockRemaining);
  writeNotNull('stock_availability', instance.stockAvailability?.toJson());
  writeNotNull('sold_individually', instance.soldIndividually);
  writeNotNull('add_to_cart', instance.addToCart?.toJson());
  writeNotNull('extensions', instance.extensions?.toJson());
  return val;
}

_$AddToCartImpl _$$AddToCartImplFromJson(Map<String, dynamic> json) =>
    _$AddToCartImpl(
      text: json['text'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      singleText: json['single_text'] as String?,
      minimum: (json['minimum'] as num?)?.toInt(),
      maximum: (json['maximum'] as num?)?.toInt(),
      multipleOf: (json['multiple_of'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AddToCartImplToJson(_$AddToCartImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  writeNotNull('description', instance.description);
  writeNotNull('url', instance.url);
  writeNotNull('single_text', instance.singleText);
  writeNotNull('minimum', instance.minimum);
  writeNotNull('maximum', instance.maximum);
  writeNotNull('multiple_of', instance.multipleOf);
  return val;
}

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('slug', instance.slug);
  writeNotNull('link', instance.link);
  return val;
}

_$ExtensionsImpl _$$ExtensionsImplFromJson(Map<String, dynamic> json) =>
    _$ExtensionsImpl();

Map<String, dynamic> _$$ExtensionsImplToJson(_$ExtensionsImpl instance) =>
    <String, dynamic>{};

_$ImageImpl _$$ImageImplFromJson(Map<String, dynamic> json) => _$ImageImpl(
      id: (json['id'] as num?)?.toInt(),
      src: json['src'] as String?,
      thumbnail: json['thumbnail'] as String?,
      srcset: json['srcset'] as String?,
      sizes: json['sizes'] as String?,
      name: json['name'] as String?,
      alt: json['alt'] as String?,
    );

Map<String, dynamic> _$$ImageImplToJson(_$ImageImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('src', instance.src);
  writeNotNull('thumbnail', instance.thumbnail);
  writeNotNull('srcset', instance.srcset);
  writeNotNull('sizes', instance.sizes);
  writeNotNull('name', instance.name);
  writeNotNull('alt', instance.alt);
  return val;
}

_$PricesImpl _$$PricesImplFromJson(Map<String, dynamic> json) => _$PricesImpl(
      price: json['price'] as String?,
      regularPrice: json['regular_price'] as String?,
      salePrice: json['sale_price'] as String?,
      priceRange: json['price_range'],
      currencyCode: json['currency_code'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      currencyMinorUnit: (json['currency_minor_unit'] as num?)?.toInt(),
      currencyDecimalSeparator: json['currency_decimal_separator'] as String?,
      currencyThousandSeparator: json['currency_thousand_separator'] as String?,
      currencyPrefix: json['currency_prefix'] as String?,
      currencySuffix: json['currency_suffix'] as String?,
    );

Map<String, dynamic> _$$PricesImplToJson(_$PricesImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('price', instance.price);
  writeNotNull('regular_price', instance.regularPrice);
  writeNotNull('sale_price', instance.salePrice);
  writeNotNull('price_range', instance.priceRange);
  writeNotNull('currency_code', instance.currencyCode);
  writeNotNull('currency_symbol', instance.currencySymbol);
  writeNotNull('currency_minor_unit', instance.currencyMinorUnit);
  writeNotNull('currency_decimal_separator', instance.currencyDecimalSeparator);
  writeNotNull(
      'currency_thousand_separator', instance.currencyThousandSeparator);
  writeNotNull('currency_prefix', instance.currencyPrefix);
  writeNotNull('currency_suffix', instance.currencySuffix);
  return val;
}

_$StockAvailabilityImpl _$$StockAvailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$StockAvailabilityImpl(
      text: json['text'] as String?,
      stockAvailabilityClass: json['class'] as String?,
    );

Map<String, dynamic> _$$StockAvailabilityImplToJson(
    _$StockAvailabilityImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  writeNotNull('class', instance.stockAvailabilityClass);
  return val;
}
