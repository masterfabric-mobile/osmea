// To parse this JSON data, do
//
//     final createCollectionWithCollectRequest = createCollectionWithCollectRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_collection_with_collect_request.freezed.dart';
part 'create_collection_with_collect_request.g.dart';

CreateCollectionWithCollectRequest createCollectionWithCollectRequestFromJson(String str) => CreateCollectionWithCollectRequest.fromJson(json.decode(str));

String createCollectionWithCollectRequestToJson(CreateCollectionWithCollectRequest data) => json.encode(data.toJson());

@freezed
class CreateCollectionWithCollectRequest with _$CreateCollectionWithCollectRequest {
    const factory CreateCollectionWithCollectRequest({
        @JsonKey(name: "custom_collection")
        CustomCollection? customCollection,
    }) = _CreateCollectionWithCollectRequest;

    factory CreateCollectionWithCollectRequest.fromJson(Map<String, dynamic> json) => _$CreateCollectionWithCollectRequestFromJson(json);
}

@freezed
class CustomCollection with _$CustomCollection {
    const factory CustomCollection({
        @JsonKey(name: "title")
        String? title,
        @JsonKey(name: "collects")
        List<Collect>? collects,
    }) = _CustomCollection;

    factory CustomCollection.fromJson(Map<String, dynamic> json) => _$CustomCollectionFromJson(json);
}

@freezed
class Collect with _$Collect {
    const factory Collect({
        @JsonKey(name: "product_id")
        int? productId,
    }) = _Collect;

    factory Collect.fromJson(Map<String, dynamic> json) => _$CollectFromJson(json);
}
