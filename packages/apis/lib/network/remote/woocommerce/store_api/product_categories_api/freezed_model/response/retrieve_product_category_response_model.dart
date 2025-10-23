// To parse this JSON data, do
//
//     final retrieveProductCategoryResponseModel = retrieveProductCategoryResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieve_product_category_response_model.freezed.dart';
part 'retrieve_product_category_response_model.g.dart';

RetrieveProductCategoryResponseModel retrieveProductCategoryResponseModelFromJson(String str) => RetrieveProductCategoryResponseModel.fromJson(json.decode(str));

String retrieveProductCategoryResponseModelToJson(RetrieveProductCategoryResponseModel data) => json.encode(data.toJson());

@freezed
class RetrieveProductCategoryResponseModel with _$RetrieveProductCategoryResponseModel {
    const factory RetrieveProductCategoryResponseModel({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "slug")
        String? slug,
        @JsonKey(name: "description")
        String? description,
        @JsonKey(name: "parent")
        int? parent,
        @JsonKey(name: "count")
        int? count,
        @JsonKey(name: "image")
        Image? image,
        @JsonKey(name: "review_count")
        int? reviewCount,
        @JsonKey(name: "permalink")
        String? permalink,
    }) = _RetrieveProductCategoryResponseModel;

    factory RetrieveProductCategoryResponseModel.fromJson(Map<String, dynamic> json) => _$RetrieveProductCategoryResponseModelFromJson(json);
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