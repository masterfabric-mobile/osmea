// To parse this JSON data, do
//
//     final createCustomCollectionWithMetafieldRequest = createCustomCollectionWithMetafieldRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_custom_collection_with_metafield_request.freezed.dart';
part 'create_custom_collection_with_metafield_request.g.dart';

CreateCustomCollectionWithMetafieldRequest createCustomCollectionWithMetafieldRequestFromJson(String str) => CreateCustomCollectionWithMetafieldRequest.fromJson(json.decode(str));

String createCustomCollectionWithMetafieldRequestToJson(CreateCustomCollectionWithMetafieldRequest data) => json.encode(data.toJson());

@freezed
class CreateCustomCollectionWithMetafieldRequest with _$CreateCustomCollectionWithMetafieldRequest {
    const factory CreateCustomCollectionWithMetafieldRequest({
        @JsonKey(name: "custom_collection")
        required CustomCollection customCollection,
    }) = _CreateCustomCollectionWithMetafieldRequest;

    factory CreateCustomCollectionWithMetafieldRequest.fromJson(Map<String, dynamic> json) => _$CreateCustomCollectionWithMetafieldRequestFromJson(json);
}

@freezed
class CustomCollection with _$CustomCollection {
    const factory CustomCollection({
        @JsonKey(name: "title")
        required String title,
        @JsonKey(name: "metafields")
        required List<Metafield> metafields,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "value")
        required String value,
        @JsonKey(name: "type")
        required String type,
        @JsonKey(name: "namespace")
        required String namespace,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
