import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_item/abstract/inventory_item_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📦 INVENTORY ITEM BY ID HANDLER 📦 ****************
///*******************************************************************

class InventoryItemByIdHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for inventory item retrieval
    if (method == 'GET') {
      // 🔍 Check if inventory item ID is provided - required parameter
      final itemId = params['item_id'] ?? '';
      if (itemId.isEmpty) {
        return {
          "status": "error",
          "message": "Inventory Item ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 📞 Call the inventory service API to retrieve the item
        final response =
            await GetIt.I.get<InventoryItemService>().inventoryItemById(
                  apiVersion: ApiNetwork.apiVersion,
                  inventoryItemId: itemId.toString(),);

        // 📋 Return the inventory item data
        return {
          "status": "success",
          "itemId": itemId,
          "item": response.toJson(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling
        return {
          "status": "error",
          "message": "Failed to retrieve inventory item: ${e.toString()}",
          "itemId": itemId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Inventory Item By ID API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'item_id',
            label: 'Inventory Item ID',
            hint: 'Enter inventory item ID to retrieve details',
          ),
        ],
      };
}
