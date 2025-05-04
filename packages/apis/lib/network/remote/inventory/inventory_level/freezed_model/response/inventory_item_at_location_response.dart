// To parse this JSON data, do
//
//     final inventoryItemAtLocationResponse = inventoryItemAtLocationResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'inventory_item_at_location_response.freezed.dart';
part 'inventory_item_at_location_response.g.dart';

InventoryItemAtLocationResponse inventoryItemAtLocationResponseFromJson(String str) => InventoryItemAtLocationResponse.fromJson(json.decode(str));

String inventoryItemAtLocationResponseToJson(InventoryItemAtLocationResponse data) => json.encode(data.toJson());

@freezed
class InventoryItemAtLocationResponse with _$InventoryItemAtLocationResponse {
    const factory InventoryItemAtLocationResponse({
        @JsonKey(name: "inventory_level")
        InventoryLevel? inventoryLevel,
        @JsonKey(name: "errors")
        String? errors,
    }) = _InventoryItemAtLocationResponse;

    factory InventoryItemAtLocationResponse.fromJson(Map<String, dynamic> json) => _$InventoryItemAtLocationResponseFromJson(json);
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
