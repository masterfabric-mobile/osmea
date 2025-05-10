// To parse this JSON data, do
//
//     final listMetafieldsResponse = listMetafieldsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_metafields_response.freezed.dart';
part 'list_metafields_response.g.dart';

ListMetafieldsResponse listMetafieldsResponseFromJson(String str) => ListMetafieldsResponse.fromJson(json.decode(str));

String listMetafieldsResponseToJson(ListMetafieldsResponse data) => json.encode(data.toJson());

@freezed
class ListMetafieldsResponse with _$ListMetafieldsResponse {
    const factory ListMetafieldsResponse({
        @JsonKey(name: "metafields")
        List<Metafield>? metafields,
    }) = _ListMetafieldsResponse;

    factory ListMetafieldsResponse.fromJson(Map<String, dynamic> json) => _$ListMetafieldsResponseFromJson(json);
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
