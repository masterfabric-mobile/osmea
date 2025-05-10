// To parse this JSON data, do
//
//     final updateMetafieldResponse = updateMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_metafield_response.freezed.dart';
part 'update_metafield_response.g.dart';

UpdateMetafieldResponse updateMetafieldResponseFromJson(String str) => UpdateMetafieldResponse.fromJson(json.decode(str));

String updateMetafieldResponseToJson(UpdateMetafieldResponse data) => json.encode(data.toJson());

@freezed
class UpdateMetafieldResponse with _$UpdateMetafieldResponse {
    const factory UpdateMetafieldResponse({
        @JsonKey(name: "metafield")
        Metafield? metafield,
    }) = _UpdateMetafieldResponse;

    factory UpdateMetafieldResponse.fromJson(Map<String, dynamic> json) => _$UpdateMetafieldResponseFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "value")
        String? value,
        @JsonKey(name: "owner_id")
        int? ownerId,
        @JsonKey(name: "namespace")
        String? namespace,
        @JsonKey(name: "key")
        String? key,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "description")
        dynamic description,
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
