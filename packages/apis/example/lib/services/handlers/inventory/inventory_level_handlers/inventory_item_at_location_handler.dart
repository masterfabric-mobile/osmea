import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_level/abstract/inventory_level_service.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_at_location_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📦 INVENTORY ITEM AT LOCATION HANDLER 📦 **********
///*******************************************************************

class InventoryItemAtLocationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle POST requests for inventory level queries
    if (method == 'POST') {
      final inventoryItemIdStr = params['inventory_item_id'] ?? '';
      final locationIdStr = params['location_id'] ?? '';
      final availableAdjustmentStr = params['available_adjustment'] ?? '';

      int inventoryItemId;
      int locationId;
      int availableAdjustment;

      try {
        inventoryItemId = int.parse(inventoryItemIdStr);
      } catch (_) {
        return {
          "status": "error",
          "message": "Invalid Inventory Item ID",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        locationId = int.parse(locationIdStr);
      } catch (_) {
        return {
          "status": "error",
          "message": "Invalid Location ID",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        availableAdjustment = int.parse(availableAdjustmentStr);
      } catch (_) {
        return {
          "status": "error",
          "message": "Invalid Available Adjustment",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 🔄 Create request model with inventory item ID, location ID, and available adjustment
        final request = InventoryItemAtLocationRequest(
          inventoryItemId: inventoryItemId,
          locationId: locationId,
          availableAdjustment: availableAdjustment,
        );
        // 📞 Call the inventory level service API to adjust the inventory level
        final response =
            await GetIt.I.get<InventoryLevelService>().inventoryItemAtLocation(
                  apiVersion: ApiNetwork.apiVersion,
                  model: request,
                );

        // 📋 Return the inventory level data
        return {
          "status": "success",
          "inventoryItemId": inventoryItemId,
          "locationId": locationId,
          "inventoryLevel": response.toJson(),
          "message": "Inventory level adjusted successfully",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Enhanced error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Check for common error patterns
        if (errorMessage.contains('400')) {
          statusCode = 400;

          // Check for "Not Found" error pattern
          if (errorMessage.contains('Not Found') ||
              errorMessage.contains('"errors":"Not Found"')) {
            return {
              "status": "error",
              "statusCode": 404,
              "message":
                  "Resource not found. Please verify the inventory item ID and location ID exist.",
              "inventoryItemId": inventoryItemId,
              "locationId": locationId,
              "details":
                  "The API could not find the requested inventory item or location. Verify both IDs are correct.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to adjust inventory level: $errorMessage",
          "inventoryItemId": inventoryItemId,
          "locationId": locationId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for Inventory Item At Location API",
    };
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'inventory_item_id',
            label: 'Inventory Item ID',
            hint: 'Enter inventory item ID to check',
          ),
          const ApiField(
            name: 'location_id',
            label: 'Location ID',
            hint: 'Enter the location ID to check inventory level',
          ),
          const ApiField(
            name: 'available_adjustment',
            label: 'Available Adjustment',
            hint: 'Enter available adjustment value',
          ),
        ],
      };
}
