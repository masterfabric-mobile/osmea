// To parse this JSON data, do
//
//     final createCustomCollectionRequest = createCustomCollectionRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_custom_collection_request.freezed.dart';
part 'create_custom_collection_request.g.dart';

CreateCustomCollectionRequest createCustomCollectionRequestFromJson(String str) => CreateCustomCollectionRequest.fromJson(json.decode(str));

String createCustomCollectionRequestToJson(CreateCustomCollectionRequest data) => json.encode(data.toJson());

@freezed
class CreateCustomCollectionRequest with _$CreateCustomCollectionRequest {
    const factory CreateCustomCollectionRequest({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
    }) = _CreateCustomCollectionRequest;

    factory CreateCustomCollectionRequest.fromJson(Map<String, dynamic> json) => _$CreateCustomCollectionRequestFromJson(json);
}

@freezed
class CustomCollection with _$CustomCollection {
    const factory CustomCollection({
        @JsonKey(name: "title")
        String? title,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}
