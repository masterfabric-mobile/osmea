// To parse this JSON data, do
//
//     final inventoryItemByIdResponse = inventoryItemByIdResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'inventory_item_by_id_response.freezed.dart';
part 'inventory_item_by_id_response.g.dart';

InventoryItemByIdResponse inventoryItemByIdResponseFromJson(String str) => InventoryItemByIdResponse.fromJson(json.decode(str));

String inventoryItemByIdResponseToJson(InventoryItemByIdResponse data) => json.encode(data.toJson());

@freezed
class InventoryItemByIdResponse with _$InventoryItemByIdResponse {
    const factory InventoryItemByIdResponse({
        @JsonKey(name: "inventory_item")
        InventoryItem? inventoryItem,
    }) = _InventoryItemByIdResponse;

    factory InventoryItemByIdResponse.fromJson(Map<String, dynamic> json) => _$InventoryItemByIdResponseFromJson(json);
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
