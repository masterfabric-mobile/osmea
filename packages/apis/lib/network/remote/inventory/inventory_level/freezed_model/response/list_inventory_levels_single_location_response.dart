// To parse this JSON data, do
//
//     final listInventoryLevelsSingleLocationResponse = listInventoryLevelsSingleLocationResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_inventory_levels_single_location_response.freezed.dart';
part 'list_inventory_levels_single_location_response.g.dart';

ListInventoryLevelsSingleLocationResponse listInventoryLevelsSingleLocationResponseFromJson(String str) => ListInventoryLevelsSingleLocationResponse.fromJson(json.decode(str));

String listInventoryLevelsSingleLocationResponseToJson(ListInventoryLevelsSingleLocationResponse data) => json.encode(data.toJson());

@freezed
class ListInventoryLevelsSingleLocationResponse with _$ListInventoryLevelsSingleLocationResponse {
    const factory ListInventoryLevelsSingleLocationResponse({
        @JsonKey(name: "inventory_levels")
        List<InventoryLevel>? inventoryLevels,
    }) = _ListInventoryLevelsSingleLocationResponse;

    factory ListInventoryLevelsSingleLocationResponse.fromJson(Map<String, dynamic> json) => _$ListInventoryLevelsSingleLocationResponseFromJson(json);
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
