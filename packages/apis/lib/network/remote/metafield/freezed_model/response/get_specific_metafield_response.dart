// To parse this JSON data, do
//
//     final getSpecificMetafieldResponse = getSpecificMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_specific_metafield_response.freezed.dart';
part 'get_specific_metafield_response.g.dart';

GetSpecificMetafieldResponse getSpecificMetafieldResponseFromJson(String str) => GetSpecificMetafieldResponse.fromJson(json.decode(str));

String getSpecificMetafieldResponseToJson(GetSpecificMetafieldResponse data) => json.encode(data.toJson());

@freezed
class GetSpecificMetafieldResponse with _$GetSpecificMetafieldResponse {
    const factory GetSpecificMetafieldResponse({
        @JsonKey(name: "metafield")
        Metafield? metafield,
    }) = _GetSpecificMetafieldResponse;

    factory GetSpecificMetafieldResponse.fromJson(Map<String, dynamic> json) => _$GetSpecificMetafieldResponseFromJson(json);
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
