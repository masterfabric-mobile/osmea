// To parse this JSON data, do
//
//     final updateInventoryItemSkuRequest = updateInventoryItemSkuRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_inventory_item_sku_request.freezed.dart';
part 'update_inventory_item_sku_request.g.dart';

UpdateInventoryItemSkuRequest updateInventoryItemSkuRequestFromJson(String str) => UpdateInventoryItemSkuRequest.fromJson(json.decode(str));

String updateInventoryItemSkuRequestToJson(UpdateInventoryItemSkuRequest data) => json.encode(data.toJson());

@freezed
class UpdateInventoryItemSkuRequest with _$UpdateInventoryItemSkuRequest {
    const factory UpdateInventoryItemSkuRequest({
        @JsonKey(name: "inventory_item")
        InventoryItem? inventoryItem,
    }) = _UpdateInventoryItemSkuRequest;

    factory UpdateInventoryItemSkuRequest.fromJson(Map<String, dynamic> json) => _$UpdateInventoryItemSkuRequestFromJson(json);
}

@freezed
class InventoryItem with _$InventoryItem {
    const factory InventoryItem({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "sku")
        String? sku,
    }) = _InventoryItem;

    factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
}
