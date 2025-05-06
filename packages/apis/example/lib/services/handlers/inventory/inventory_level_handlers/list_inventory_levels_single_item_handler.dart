import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_level/abstract/inventory_level_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📋 LIST INVENTORY LEVELS BY ITEM HANDLER 📋 ******
///*******************************************************************

class ListInventoryLevelsSingleItemHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for inventory levels by item
    if (method == 'GET') {
      // 🔍 Check if inventory item ID is provided - required parameter
      final inventoryItemId = params['inventory_item_id'] ?? '';
      if (inventoryItemId.isEmpty) {
        return {
          "status": "error",
          "message": "Inventory Item ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        int inventoryItemIdInt;

        // Convert inventory item ID to integer
        try {
          inventoryItemIdInt = int.parse(inventoryItemId);
        } catch (_) {
          return {
            "status": "error",
            "message": "Inventory Item ID must be a valid number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Extract optional query parameters
        final limit = params['limit'];
        final updatedAtMin = params['updated_at_min'];

        // 📞 Call the inventory level service API to get levels for this item
        final response = await GetIt.I
            .get<InventoryLevelService>()
            .listInventoryLevelsSingleItem(
              apiVersion: ApiNetwork.apiVersion,
              inventoryItemId: inventoryItemIdInt.toString(),
              limit: limit != null && limit.isNotEmpty
                  ? int.tryParse(limit)
                  : null,
              updatedAtMin: updatedAtMin,
            );

        // 📋 Return the inventory levels data
        return {
          "status": "success",
          "inventoryItemId": inventoryItemId,
          "inventoryLevels": response.toJson(),
          "count": response.inventoryLevels?.length ?? 0,
          "message": "Inventory levels for item successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling with status code detection
        String errorMessage = e.toString();
        int statusCode = 500;

        if (errorMessage.contains('404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message":
                "Inventory item not found. Please verify the item ID exists.",
            "inventoryItemId": inventoryItemId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to retrieve inventory levels: $errorMessage",
          "inventoryItemId": inventoryItemId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for List Inventory Levels by Item API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'inventory_item_id',
            label: 'Inventory Item ID',
            hint: 'Enter inventory item ID to retrieve levels across locations',
          ),
          // Optional fields
          const ApiField(
            name: 'limit',
            label: 'Results Limit',
            hint: 'Maximum number of results to return (default: 50)',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated After',
            hint:
                'Filter for inventory updated after this timestamp (ISO 8601)',
          ),
        ],
      };
}
