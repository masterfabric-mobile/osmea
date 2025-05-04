// To parse this JSON data, do
//
//     final inventoryItemToLocationResponse = inventoryItemToLocationResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'inventory_item_to_location_response.freezed.dart';
part 'inventory_item_to_location_response.g.dart';

InventoryItemToLocationResponse inventoryItemToLocationResponseFromJson(String str) => InventoryItemToLocationResponse.fromJson(json.decode(str));

String inventoryItemToLocationResponseToJson(InventoryItemToLocationResponse data) => json.encode(data.toJson());

@freezed
class InventoryItemToLocationResponse with _$InventoryItemToLocationResponse {
    const factory InventoryItemToLocationResponse({
        @JsonKey(name: "inventory_level")
        InventoryLevel? inventoryLevel,
        @JsonKey(name: "errors")
        List<String>? errors,
    }) = _InventoryItemToLocationResponse;

    factory InventoryItemToLocationResponse.fromJson(Map<String, dynamic> json) => _$InventoryItemToLocationResponseFromJson(json);
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
