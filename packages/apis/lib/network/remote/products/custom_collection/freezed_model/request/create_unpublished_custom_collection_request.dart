// To parse this JSON data, do
//
//     final createUnpublishedCustomCollectionRequest = createUnpublishedCustomCollectionRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_unpublished_custom_collection_request.freezed.dart';
part 'create_unpublished_custom_collection_request.g.dart';

CreateUnpublishedCustomCollectionRequest createUnpublishedCustomCollectionRequestFromJson(String str) => CreateUnpublishedCustomCollectionRequest.fromJson(json.decode(str));

String createUnpublishedCustomCollectionRequestToJson(CreateUnpublishedCustomCollectionRequest data) => json.encode(data.toJson());

@freezed
class CreateUnpublishedCustomCollectionRequest with _$CreateUnpublishedCustomCollectionRequest {
    const factory CreateUnpublishedCustomCollectionRequest({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
    }) = _CreateUnpublishedCustomCollectionRequest;

    factory CreateUnpublishedCustomCollectionRequest.fromJson(Map<String, dynamic> json) => _$CreateUnpublishedCustomCollectionRequestFromJson(json);
}

@freezed
class CustomCollection with _$CustomCollection {
    const factory CustomCollection({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "published")
        bool? published,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}
