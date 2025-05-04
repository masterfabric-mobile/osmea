// To parse this JSON data, do
//
//     final inventoryItemToLocationRequest = inventoryItemToLocationRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'inventory_item_to_location_request.freezed.dart';
part 'inventory_item_to_location_request.g.dart';

InventoryItemToLocationRequest inventoryItemToLocationRequestFromJson(String str) => InventoryItemToLocationRequest.fromJson(json.decode(str));

String inventoryItemToLocationRequestToJson(InventoryItemToLocationRequest data) => json.encode(data.toJson());

@freezed
class InventoryItemToLocationRequest with _$InventoryItemToLocationRequest {
    const factory InventoryItemToLocationRequest({
        @JsonKey(name: "location_id")
        int? locationId,
        @JsonKey(name: "inventory_item_id")
        int? inventoryItemId,
    }) = _InventoryItemToLocationRequest;

    factory InventoryItemToLocationRequest.fromJson(Map<String, dynamic> json) => _$InventoryItemToLocationRequestFromJson(json);
}
