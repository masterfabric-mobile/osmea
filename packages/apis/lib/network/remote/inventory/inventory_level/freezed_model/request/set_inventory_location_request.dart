// To parse this JSON data, do
//
//     final setInventoryLocationRequest = setInventoryLocationRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'set_inventory_location_request.freezed.dart';
part 'set_inventory_location_request.g.dart';

SetInventoryLocationRequest setInventoryLocationRequestFromJson(String str) => SetInventoryLocationRequest.fromJson(json.decode(str));

String setInventoryLocationRequestToJson(SetInventoryLocationRequest data) => json.encode(data.toJson());

@freezed
class SetInventoryLocationRequest with _$SetInventoryLocationRequest {
    const factory SetInventoryLocationRequest({
        @JsonKey(name: "location_id")
        int? locationId,
        @JsonKey(name: "inventory_item_id")
        int? inventoryItemId,
        @JsonKey(name: "available")
        int? available,
    }) = _SetInventoryLocationRequest;

    factory SetInventoryLocationRequest.fromJson(Map<String, dynamic> json) => _$SetInventoryLocationRequestFromJson(json);
}
