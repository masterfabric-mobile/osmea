// To parse this JSON data, do
//
//     final updateInventoryItemUnitCostRequest = updateInventoryItemUnitCostRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_inventory_item_unit_cost_request.freezed.dart';
part 'update_inventory_item_unit_cost_request.g.dart';

UpdateInventoryItemUnitCostRequest updateInventoryItemUnitCostRequestFromJson(String str) => UpdateInventoryItemUnitCostRequest.fromJson(json.decode(str));

String updateInventoryItemUnitCostRequestToJson(UpdateInventoryItemUnitCostRequest data) => json.encode(data.toJson());

@freezed
class UpdateInventoryItemUnitCostRequest with _$UpdateInventoryItemUnitCostRequest {
    const factory UpdateInventoryItemUnitCostRequest({
        @JsonKey(name: "inventory_item")
        InventoryItem? inventoryItem,
    }) = _UpdateInventoryItemUnitCostRequest;

    factory UpdateInventoryItemUnitCostRequest.fromJson(Map<String, dynamic> json) => _$UpdateInventoryItemUnitCostRequestFromJson(json);
}

@freezed
class InventoryItem with _$InventoryItem {
    const factory InventoryItem({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "cost")
        String? cost,
    }) = _InventoryItem;

    factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
}
