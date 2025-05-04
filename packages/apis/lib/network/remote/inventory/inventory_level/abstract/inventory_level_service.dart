import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_at_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/inventory_item_at_location_response.dart';

abstract class InventoryLevelService {
  /// 📦 Adjusts the inventory level for an item at a location.
  Future<InventoryItemAtLocationResponse> inventoryItemAtLocation({
    required String apiVersion,
    required InventoryItemAtLocationRequest model,
  });


}