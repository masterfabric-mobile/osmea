import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_item/abstract/inventory_item_service.dart';
import 'package:apis/network/remote/inventory/inventory_item/freezed_model/request/update_inventory_item_unit_cost_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///********** 💲 UPDATE INVENTORY ITEM UNIT COST HANDLER 💲 ********
///*******************************************************************

class UpdateInventoryItemUnitCostHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle PUT requests for inventory item unit cost updates
    if (method == 'PUT') {
      // 🔍 Check if inventory item ID is provided - required parameter
      final inventoryItemId = params['id'] ?? '';
      if (inventoryItemId.isEmpty) {
        return {
          "status": "error",
          "message": "Inventory Item ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // 🔍 Check if unit cost is provided - required parameter
      final unitCostStr = params['unit_cost'] ?? '';
      if (unitCostStr.isEmpty) {
        return {
          "status": "error",
          "message": "Unit cost is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Parse unit cost value
      final double? unitCost = double.tryParse(unitCostStr);
      if (unitCost == null) {
        return {
          "status": "error",
          "message": "Unit cost must be a valid number",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 🔄 Create request model with unit cost value
        final request = UpdateInventoryItemUnitCostRequest(
          inventoryItem: InventoryItem(
            cost: unitCost.toString(),
          ),
        );

        // 📞 Call the inventory service API to update the item unit cost
        final response = await GetIt.I
            .get<InventoryItemService>()
            .updateInventoryItemUnitCost(
              apiVersion: ApiNetwork.apiVersion,
              inventoryItemId: inventoryItemId,
              model: request,
            );

        // 📋 Return the updated inventory item data
        return {
          "status": "success",
          "inventoryItemId": inventoryItemId,
          "updatedItem": response.toJson(),
          "message": "Inventory item unit cost successfully updated",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling
        return {
          "status": "error",
          "message":
              "Failed to update inventory item unit cost: ${e.toString()}",
          "inventoryItemId": inventoryItemId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for Update Inventory Item Unit Cost API",
    };
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'id',
            label: 'Inventory Item ID',
            hint: 'Enter inventory item ID to update',
          ),
          const ApiField(
            name: 'unit_cost',
            label: 'Unit Cost',
            hint: 'Enter the new unit cost value (numeric)',
          ),
        ],
      };
}
