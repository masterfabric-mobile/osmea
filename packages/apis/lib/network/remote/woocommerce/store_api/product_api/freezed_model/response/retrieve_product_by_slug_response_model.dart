// To parse this JSON data, do
//
//     final retrieveProductBySlugResponseModel = retrieveProductBySlugResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieve_product_by_slug_response_model.freezed.dart';
part 'retrieve_product_by_slug_response_model.g.dart';

RetrieveProductBySlugResponseModel retrieveProductBySlugResponseModelFromJson(String str) => RetrieveProductBySlugResponseModel.fromJson(json.decode(str));

String retrieveProductBySlugResponseModelToJson(RetrieveProductBySlugResponseModel data) => json.encode(data.toJson());

@freezed
class RetrieveProductBySlugResponseModel with _$RetrieveProductBySlugResponseModel {
    const factory RetrieveProductBySlugResponseModel({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "slug")
        String? slug,
        @JsonKey(name: "parent")
        int? parent,
        @JsonKey(name: "type")
        String? type,
        @JsonKey(name: "variation")
        String? variation,
        @JsonKey(name: "permalink")
        String? permalink,
        @JsonKey(name: "sku")
        String? sku,
        @JsonKey(name: "short_description")
        String? shortDescription,
        @JsonKey(name: "description")
        String? description,
        @JsonKey(name: "on_sale")
        bool? onSale,
        @JsonKey(name: "prices")
        Prices? prices,
        @JsonKey(name: "price_html")
        String? priceHtml,
        @JsonKey(name: "average_rating")
        String? averageRating,
        @JsonKey(name: "review_count")
        int? reviewCount,
        @JsonKey(name: "images")
        List<Image>? images,
        @JsonKey(name: "categories")
        List<Category>? categories,
        @JsonKey(name: "tags")
        List<dynamic>? tags,
        @JsonKey(name: "brands")
        List<dynamic>? brands,
        @JsonKey(name: "attributes")
        List<dynamic>? attributes,
        @JsonKey(name: "variations")
        List<dynamic>? variations,
        @JsonKey(name: "grouped_products")
        List<dynamic>? groupedProducts,
        @JsonKey(name: "has_options")
        bool? hasOptions,
        @JsonKey(name: "is_purchasable")
        bool? isPurchasable,
        @JsonKey(name: "is_in_stock")
        bool? isInStock,
        @JsonKey(name: "is_on_backorder")
        bool? isOnBackorder,
        @JsonKey(name: "low_stock_remaining")
        dynamic lowStockRemaining,
        @JsonKey(name: "stock_availability")
        StockAvailability? stockAvailability,
        @JsonKey(name: "sold_individually")
        bool? soldIndividually,
        @JsonKey(name: "add_to_cart")
        AddToCart? addToCart,
        @JsonKey(name: "extensions")
        Extensions? extensions,
    }) = _RetrieveProductBySlugResponseModel;

    factory RetrieveProductBySlugResponseModel.fromJson(Map<String, dynamic> json) => _$RetrieveProductBySlugResponseModelFromJson(json);
}

@freezed
class AddToCart with _$AddToCart {
    const factory AddToCart({
        @JsonKey(name: "text")
        String? text,
        @JsonKey(name: "description")
        String? description,
        @JsonKey(name: "url")
        String? url,
        @JsonKey(name: "single_text")
        String? singleText,
        @JsonKey(name: "minimum")
        int? minimum,
        @JsonKey(name: "maximum")
        int? maximum,
        @JsonKey(name: "multiple_of")
        int? multipleOf,
    }) = _AddToCart;

    factory AddToCart.fromJson(Map<String, dynamic> json) => _$AddToCartFromJson(json);
}

@freezed
class Category with _$Category {
    const factory Category({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "slug")
        String? slug,
        @JsonKey(name: "link")
        String? link,
    }) = _Category;

    factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class Extensions with _$Extensions {
    const factory Extensions() = _Extensions;

    factory Extensions.fromJson(Map<String, dynamic> json) => _$ExtensionsFromJson(json);
}

@freezed
class Image with _$Image {
    const factory Image({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "src")
        String? src,
        @JsonKey(name: "thumbnail")
        String? thumbnail,
        @JsonKey(name: "srcset")
        String? srcset,
        @JsonKey(name: "sizes")
        String? sizes,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "alt")
        String? alt,
    }) = _Image;

    factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@freezed
class Prices with _$Prices {
    const factory Prices({
        @JsonKey(name: "price")
        String? price,
        @JsonKey(name: "regular_price")
        String? regularPrice,
        @JsonKey(name: "sale_price")
        String? salePrice,
        @JsonKey(name: "price_range")
        dynamic priceRange,
        @JsonKey(name: "currency_code")
        String? currencyCode,
        @JsonKey(name: "currency_symbol")
        String? currencySymbol,
        @JsonKey(name: "currency_minor_unit")
        int? currencyMinorUnit,
        @JsonKey(name: "currency_decimal_separator")
        String? currencyDecimalSeparator,
        @JsonKey(name: "currency_thousand_separator")
        String? currencyThousandSeparator,
        @JsonKey(name: "currency_prefix")
        String? currencyPrefix,
        @JsonKey(name: "currency_suffix")
        String? currencySuffix,
    }) = _Prices;

    factory Prices.fromJson(Map<String, dynamic> json) => _$PricesFromJson(json);
}

@freezed
class StockAvailability with _$StockAvailability {
    const factory StockAvailability({
        @JsonKey(name: "text")
        String? text,
        @JsonKey(name: "class")
        String? stockAvailabilityClass,
    }) = _StockAvailability;

    factory StockAvailability.fromJson(Map<String, dynamic> json) => _$StockAvailabilityFromJson(json);
}
