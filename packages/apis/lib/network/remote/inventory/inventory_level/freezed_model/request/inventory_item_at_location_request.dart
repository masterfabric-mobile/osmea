// To parse this JSON data, do
//
//     final inventoryItemAtLocationRequest = inventoryItemAtLocationRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'inventory_item_at_location_request.freezed.dart';
part 'inventory_item_at_location_request.g.dart';

InventoryItemAtLocationRequest inventoryItemAtLocationRequestFromJson(String str) => InventoryItemAtLocationRequest.fromJson(json.decode(str));

String inventoryItemAtLocationRequestToJson(InventoryItemAtLocationRequest data) => json.encode(data.toJson());

@freezed
class InventoryItemAtLocationRequest with _$InventoryItemAtLocationRequest {
    const factory InventoryItemAtLocationRequest({
        @JsonKey(name: "location_id")
        int? locationId,
        @JsonKey(name: "inventory_item_id")
        int? inventoryItemId,
        @JsonKey(name: "available_adjustment")
        int? availableAdjustment,
    }) = _InventoryItemAtLocationRequest;

    factory InventoryItemAtLocationRequest.fromJson(Map<String, dynamic> json) => _$InventoryItemAtLocationRequestFromJson(json);
}
