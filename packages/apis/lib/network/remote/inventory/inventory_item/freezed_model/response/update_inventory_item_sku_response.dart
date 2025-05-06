// To parse this JSON data, do
//
//     final updateInventoryItemSkuResponse = updateInventoryItemSkuResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_inventory_item_sku_response.freezed.dart';
part 'update_inventory_item_sku_response.g.dart';

UpdateInventoryItemSkuResponse updateInventoryItemSkuResponseFromJson(String str) => UpdateInventoryItemSkuResponse.fromJson(json.decode(str));

String updateInventoryItemSkuResponseToJson(UpdateInventoryItemSkuResponse data) => json.encode(data.toJson());

@freezed
class UpdateInventoryItemSkuResponse with _$UpdateInventoryItemSkuResponse {
    const factory UpdateInventoryItemSkuResponse({
        @JsonKey(name: "inventory_item")
        InventoryItem? inventoryItem,
    }) = _UpdateInventoryItemSkuResponse;

    factory UpdateInventoryItemSkuResponse.fromJson(Map<String, dynamic> json) => _$UpdateInventoryItemSkuResponseFromJson(json);
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
        dynamic cost,
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
