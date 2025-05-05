import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_at_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_to_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/set_inventory_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/inventory_item_at_location_response.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/inventory_item_to_location_response.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/list_inventory_levels_single_location_response.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/set_inventory_location_response.dart';

abstract class InventoryLevelService {
  /// 📦 Adjusts the inventory level for an item at a location.
  Future<InventoryItemAtLocationResponse> inventoryItemAtLocation({
    required String apiVersion,
    required InventoryItemAtLocationRequest model,
  });

  /// 📦 Connects an inventory item to a location
  Future<InventoryItemToLocationResponse> inventoryItemToLocation({
    required String apiVersion,
    required InventoryItemToLocationRequest model,
  });

  /// 📦 Sets the inventory level for an inventory item at a location
  Future<SetInventoryLocationResponse> setInventoryLocation({
    required String apiVersion,
    required SetInventoryLocationRequest model,
  });

  /// 📦 Retrieves a list of inventory levels for a single location
  Future<ListInventoryLevelsSingleLocationResponse> listInventoryLevelsSingleLocation({
    required String apiVersion,
    required String locationId,
    int? limit,
    String? updatedAtMin,
  });

}