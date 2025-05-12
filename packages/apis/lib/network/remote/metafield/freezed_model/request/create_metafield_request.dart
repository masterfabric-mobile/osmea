// To parse this JSON data, do
//
//     final createMetafieldRequest = createMetafieldRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_metafield_request.freezed.dart';
part 'create_metafield_request.g.dart';

CreateMetafieldRequest createMetafieldRequestFromJson(String str) => CreateMetafieldRequest.fromJson(json.decode(str));

String createMetafieldRequestToJson(CreateMetafieldRequest data) => json.encode(data.toJson());

@freezed
class CreateMetafieldRequest with _$CreateMetafieldRequest {
    const factory CreateMetafieldRequest({
        @JsonKey(name: "metafield")
        required Metafield metafield,
    }) = _CreateMetafieldRequest;

    factory CreateMetafieldRequest.fromJson(Map<String, dynamic> json) => _$CreateMetafieldRequestFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "namespace")
        required String namespace,
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "type")
        required String type,
        @JsonKey(name: "value")
        required String value,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
