import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_item/abstract/inventory_item_service.dart';
import 'package:apis/network/remote/inventory/inventory_item/freezed_model/request/update_inventory_item_sku_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🔄 UPDATE INVENTORY ITEM SKU HANDLER 🔄 **********
///*******************************************************************

class UpdateInventoryItemSkuHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle PUT requests for inventory item SKU updates
    if (method == 'PUT') {
      // 🔍 Check if inventory item ID is provided - required parameter
      final itemId = params['item_id'] ?? '';
      if (itemId.isEmpty) {
        return {
          "status": "error",
          "message": "Inventory Item ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // 🔍 Check if SKU is provided - required parameter
      final sku = params['sku'] ?? '';
      if (sku.isEmpty) {
        return {
          "status": "error",
          "message": "SKU is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 🔄 Create request model with SKU value
        final request = UpdateInventoryItemSkuRequest(
          inventoryItem: InventoryItem(
            sku: sku,
          ),
        );

        // 📞 Call the inventory service API to update the item SKU
        final response =
            await GetIt.I.get<InventoryItemService>().updateInventoryItemSku(
                  apiVersion: ApiNetwork.apiVersion,
                  inventoryItemId: itemId,
                  model: request,
                );

        // 📋 Return the updated inventory item data
        return {
          "status": "success",
          "itemId": itemId,
          "updatedItem": response.toJson(),
          "message": "Inventory item SKU successfully updated",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling
        return {
          "status": "error",
          "message": "Failed to update inventory item SKU: ${e.toString()}",
          "itemId": itemId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Update Inventory Item SKU API",
    };
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'item_id',
            label: 'Inventory Item ID',
            hint: 'Enter inventory item ID to update',
          ),
          const ApiField(
            name: 'sku',
            label: 'Stock Keeping Unit (SKU)',
            hint: 'Enter the new SKU for the inventory item',
          ),
        ],
      };
}
