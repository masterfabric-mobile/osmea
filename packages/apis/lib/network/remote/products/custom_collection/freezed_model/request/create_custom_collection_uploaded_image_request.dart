// To parse this JSON data, do
//
//     final createCustomCollectionUploadedImageRequest = createCustomCollectionUploadedImageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_custom_collection_uploaded_image_request.freezed.dart';
part 'create_custom_collection_uploaded_image_request.g.dart';

CreateCustomCollectionUploadedImageRequest createCustomCollectionUploadedImageRequestFromJson(String str) => CreateCustomCollectionUploadedImageRequest.fromJson(json.decode(str));

String createCustomCollectionUploadedImageRequestToJson(CreateCustomCollectionUploadedImageRequest data) => json.encode(data.toJson());

@freezed
class CreateCustomCollectionUploadedImageRequest with _$CreateCustomCollectionUploadedImageRequest {
    const factory CreateCustomCollectionUploadedImageRequest({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
    }) = _CreateCustomCollectionUploadedImageRequest;

    factory CreateCustomCollectionUploadedImageRequest.fromJson(Map<String, dynamic> json) => _$CreateCustomCollectionUploadedImageRequestFromJson(json);
}

@freezed
class CustomCollection with _$CustomCollection {
    const factory CustomCollection({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "image")
        Image? image,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}

@freezed
class Image with _$Image {
    const factory Image({
        @JsonKey(name: "src")
        String? src,
        @JsonKey(name: "alt")
        String? alt,
    }) = _Image;

    factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
