// To parse this JSON data, do
//
//     final updateInventoryItemUnitCostResponse = updateInventoryItemUnitCostResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_inventory_item_unit_cost_response.freezed.dart';
part 'update_inventory_item_unit_cost_response.g.dart';

UpdateInventoryItemUnitCostResponse updateInventoryItemUnitCostResponseFromJson(String str) => UpdateInventoryItemUnitCostResponse.fromJson(json.decode(str));

String updateInventoryItemUnitCostResponseToJson(UpdateInventoryItemUnitCostResponse data) => json.encode(data.toJson());

@freezed
class UpdateInventoryItemUnitCostResponse with _$UpdateInventoryItemUnitCostResponse {
    const factory UpdateInventoryItemUnitCostResponse({
        @JsonKey(name: "inventory_item")
        InventoryItem? inventoryItem,
    }) = _UpdateInventoryItemUnitCostResponse;

    factory UpdateInventoryItemUnitCostResponse.fromJson(Map<String, dynamic> json) => _$UpdateInventoryItemUnitCostResponseFromJson(json);
}

@freezed
class InventoryItem with _$InventoryItem {
    const factory InventoryItem({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "sku")
        String? sku,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "requires_shipping")
        bool? requiresShipping,
        @JsonKey(name: "cost")
        String? cost,
        @JsonKey(name: "country_code_of_origin")
        dynamic countryCodeOfOrigin,
        @JsonKey(name: "province_code_of_origin")
        dynamic provinceCodeOfOrigin,
        @JsonKey(name: "harmonized_system_code")
        dynamic harmonizedSystemCode,
        @JsonKey(name: "tracked")
        bool? tracked,
        @JsonKey(name: "country_harmonized_system_codes")
        List<dynamic>? countryHarmonizedSystemCodes,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
    }) = _InventoryItem;

    factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
}
