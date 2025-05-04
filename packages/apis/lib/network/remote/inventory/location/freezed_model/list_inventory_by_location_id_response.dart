// To parse this JSON data, do
//
//     final listInventoryByLocationIdResponse = listInventoryByLocationIdResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_inventory_by_location_id_response.freezed.dart';
part 'list_inventory_by_location_id_response.g.dart';

ListInventoryByLocationIdResponse listInventoryByLocationIdResponseFromJson(String str) => ListInventoryByLocationIdResponse.fromJson(json.decode(str));

String listInventoryByLocationIdResponseToJson(ListInventoryByLocationIdResponse data) => json.encode(data.toJson());

@freezed
class ListInventoryByLocationIdResponse with _$ListInventoryByLocationIdResponse {
    const factory ListInventoryByLocationIdResponse({
        @JsonKey(name: "inventory_levels")
        List<InventoryLevel>? inventoryLevels,
    }) = _ListInventoryByLocationIdResponse;

    factory ListInventoryByLocationIdResponse.fromJson(Map<String, dynamic> json) => _$ListInventoryByLocationIdResponseFromJson(json);
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
