// To parse this JSON data, do
//
//     final listProductBrandsResponseModel = listProductBrandsResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_product_brands_response_model.freezed.dart';
part 'list_product_brands_response_model.g.dart';

List<ListProductBrandsResponseModel> listProductBrandsResponseModelFromJson(String str) => List<ListProductBrandsResponseModel>.from(json.decode(str).map((x) => ListProductBrandsResponseModel.fromJson(x)));

String listProductBrandsResponseModelToJson(List<ListProductBrandsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
class ListProductBrandsResponseModel with _$ListProductBrandsResponseModel {
    const factory ListProductBrandsResponseModel({
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
    }) = _ListProductBrandsResponseModel;

    factory ListProductBrandsResponseModel.fromJson(Map<String, dynamic> json) => _$ListProductBrandsResponseModelFromJson(json);
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
