// To parse this JSON data, do
//
//     final createCustomCollectionBaseImageRequest = createCustomCollectionBaseImageRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_custom_collection_base_image_request.freezed.dart';
part 'create_custom_collection_base_image_request.g.dart';

CreateCustomCollectionBaseImageRequest createCustomCollectionBaseImageRequestFromJson(String str) => CreateCustomCollectionBaseImageRequest.fromJson(json.decode(str));

String createCustomCollectionBaseImageRequestToJson(CreateCustomCollectionBaseImageRequest data) => json.encode(data.toJson());

@freezed
class CreateCustomCollectionBaseImageRequest with _$CreateCustomCollectionBaseImageRequest {
    const factory CreateCustomCollectionBaseImageRequest({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
    }) = _CreateCustomCollectionBaseImageRequest;

    factory CreateCustomCollectionBaseImageRequest.fromJson(Map<String, dynamic> json) => _$CreateCustomCollectionBaseImageRequestFromJson(json);
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
        @JsonKey(name: "attachment")
        String? attachment,
        @JsonKey(name: "alt")
        String? alt,
    }) = _Image;

    factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
