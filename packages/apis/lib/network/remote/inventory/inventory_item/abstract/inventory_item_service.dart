import 'package:apis/network/remote/inventory/inventory_item/freezed_model/response/inventory_item_by_id_response.dart';

abstract class InventoryItemService {
  /// 📦 Retrieves a list of inventory items from the API.
  Future<InventoryItemByIdResponse> inventoryItemById({
    required String apiVersion,
    required String inventoryItemId,
  });
}
