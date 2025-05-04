// To parse this JSON data, do
//
//     final setInventoryLocationResponse = setInventoryLocationResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'set_inventory_location_response.freezed.dart';
part 'set_inventory_location_response.g.dart';

SetInventoryLocationResponse setInventoryLocationResponseFromJson(String str) => SetInventoryLocationResponse.fromJson(json.decode(str));

String setInventoryLocationResponseToJson(SetInventoryLocationResponse data) => json.encode(data.toJson());

@freezed
class SetInventoryLocationResponse with _$SetInventoryLocationResponse {
    const factory SetInventoryLocationResponse({
        @JsonKey(name: "inventory_level")
        InventoryLevel? inventoryLevel,
        @JsonKey(name: "errors")
        List<String>? errors,
    }) = _SetInventoryLocationResponse;

    factory SetInventoryLocationResponse.fromJson(Map<String, dynamic> json) => _$SetInventoryLocationResponseFromJson(json);
}

@freezed
class InventoryLevel with _$InventoryLevel {
    const factory InventoryLevel({
        @JsonKey(name: "inventory_item_id")
        int? inventoryItemId,
        @JsonKey(name: "location_id")
        int? locationId,
        @JsonKey(name: "available")
        int? available,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _InventoryLevel;

    factory InventoryLevel.fromJson(Map<String, dynamic> json) => _$InventoryLevelFromJson(json);
}
