// To parse this JSON data, do
//
//     final listProductReviewsResponseModel = listProductReviewsResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_product_reviews_response_model.freezed.dart';
part 'list_product_reviews_response_model.g.dart';

List<ListProductReviewsResponseModel> listProductReviewsResponseModelFromJson(String str) => List<ListProductReviewsResponseModel>.from(json.decode(str).map((x) => ListProductReviewsResponseModel.fromJson(x)));

String listProductReviewsResponseModelToJson(List<ListProductReviewsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
class ListProductReviewsResponseModel with _$ListProductReviewsResponseModel {
    const factory ListProductReviewsResponseModel({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "date_created")
        String? dateCreated,
        @JsonKey(name: "formatted_date_created")
        String? formattedDateCreated,
        @JsonKey(name: "date_created_gmt")
        String? dateCreatedGmt,
        @JsonKey(name: "product_id")
        int? productId,
        @JsonKey(name: "product_name")
        String? productName,
        @JsonKey(name: "product_permalink")
        String? productPermalink,
        @JsonKey(name: "product_image")
        ProductImage? productImage,
        @JsonKey(name: "reviewer")
        String? reviewer,
        @JsonKey(name: "review")
        String? review,
        @JsonKey(name: "rating")
        int? rating,
        @JsonKey(name: "verified")
        bool? verified,
        @JsonKey(name: "reviewer_avatar_urls")
        ReviewerAvatarUrls? reviewerAvatarUrls,
    }) = _ListProductReviewsResponseModel;

    factory ListProductReviewsResponseModel.fromJson(Map<String, dynamic> json) => _$ListProductReviewsResponseModelFromJson(json);
}

@freezed
class ProductImage with _$ProductImage {
    const factory ProductImage({
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
    }) = _ProductImage;

    factory ProductImage.fromJson(Map<String, dynamic> json) => _$ProductImageFromJson(json);
}

@freezed
class ReviewerAvatarUrls with _$ReviewerAvatarUrls {
    const factory ReviewerAvatarUrls({
        @JsonKey(name: "24")
        String? the24,
        @JsonKey(name: "48")
        String? the48,
        @JsonKey(name: "96")
        String? the96,
    }) = _ReviewerAvatarUrls;

    factory ReviewerAvatarUrls.fromJson(Map<String, dynamic> json) => _$ReviewerAvatarUrlsFromJson(json);
}
