// To parse this JSON data, do
//
//     final listInventoryLevelsSingleItemResponse = listInventoryLevelsSingleItemResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_inventory_levels_single_item_response.freezed.dart';
part 'list_inventory_levels_single_item_response.g.dart';

ListInventoryLevelsSingleItemResponse listInventoryLevelsSingleItemResponseFromJson(String str) => ListInventoryLevelsSingleItemResponse.fromJson(json.decode(str));

String listInventoryLevelsSingleItemResponseToJson(ListInventoryLevelsSingleItemResponse data) => json.encode(data.toJson());

@freezed
class ListInventoryLevelsSingleItemResponse with _$ListInventoryLevelsSingleItemResponse {
    const factory ListInventoryLevelsSingleItemResponse({
        @JsonKey(name: "inventory_levels")
        List<InventoryLevel>? inventoryLevels,
    }) = _ListInventoryLevelsSingleItemResponse;

    factory ListInventoryLevelsSingleItemResponse.fromJson(Map<String, dynamic> json) => _$ListInventoryLevelsSingleItemResponseFromJson(json);
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
