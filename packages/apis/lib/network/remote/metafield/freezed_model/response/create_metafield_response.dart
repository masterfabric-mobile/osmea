// To parse this JSON data, do
//
//     final createMetafieldResponse = createMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_metafield_response.freezed.dart';
part 'create_metafield_response.g.dart';

CreateMetafieldResponse createMetafieldResponseFromJson(String str) => CreateMetafieldResponse.fromJson(json.decode(str));

String createMetafieldResponseToJson(CreateMetafieldResponse data) => json.encode(data.toJson());

@freezed
class CreateMetafieldResponse with _$CreateMetafieldResponse {
    const factory CreateMetafieldResponse({
        @JsonKey(name: "metafield")
        Metafield? metafield,
    }) = _CreateMetafieldResponse;

    factory CreateMetafieldResponse.fromJson(Map<String, dynamic> json) => _$CreateMetafieldResponseFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "namespace")
        String? namespace,
        @JsonKey(name: "key")
        String? key,
        @JsonKey(name: "value")
        String? value,
        @JsonKey(name: "description")
        dynamic description,
        @JsonKey(name: "owner_id")
        int? ownerId,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "owner_resource")
        String? ownerResource,
        @JsonKey(name: "type")
        String? type,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
