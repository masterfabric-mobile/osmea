import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_level/abstract/inventory_level_service.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/set_inventory_location_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📦 SET INVENTORY LEVEL HANDLER 📦 ****************
///*******************************************************************

class SetInventoryLocationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle POST requests for setting inventory levels
    if (method == 'POST') {
      final inventoryItemIdStr = params['inventory_item_id'] ?? '';
      final locationIdStr = params['location_id'] ?? '';
      final availableStr = params['available'] ?? '';

      int inventoryItemId;
      int locationId;
      int available;

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
        available = int.parse(availableStr);
      } catch (_) {
        return {
          "status": "error",
          "message": "Invalid Available quantity",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 🔄 Create request model for setting inventory level
        final request = SetInventoryLocationRequest(
          inventoryItemId: inventoryItemId,
          locationId: locationId,
          available: available,
        );

        // 📞 Call the inventory level service API to set the level
        final response =
            await GetIt.I.get<InventoryLevelService>().setInventoryLocation(
                  apiVersion: ApiNetwork.apiVersion,
                  model: request,
                );

        // 📋 Return the inventory level data
        return {
          "status": "success",
          "inventoryItemId": inventoryItemId,
          "locationId": locationId,
          "available": available,
          "inventoryLevel": response.toJson(),
          "message": "Inventory level successfully set",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Enhanced error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Check for specific error types
        if (errorMessage.contains('404') ||
            errorMessage.contains('status code of 404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": 404,
            "message": "The requested resource was not found.",
            "inventoryItemId": inventoryItemId,
            "locationId": locationId,
            "details":
                "Either the inventory item ID or location ID does not exist, or they are not connected.",
            "troubleshooting": [
              "Check that inventory item ID: $inventoryItemId exists",
              "Verify that location ID: $locationId is valid",
              "Ensure the inventory item is connected to this location first",
              "Try retrieving the individual items to confirm they exist"
            ],
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('422')) {
          statusCode = 422;
          return {
            "status": "error",
            "statusCode": 422,
            "message":
                "The request was well-formed but could not be processed.",
            "inventoryItemId": inventoryItemId,
            "locationId": locationId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to set inventory level: $errorMessage",
          "inventoryItemId": inventoryItemId,
          "locationId": locationId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Set Inventory Level API",
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
            hint: 'Enter inventory item ID',
          ),
          const ApiField(
            name: 'location_id',
            label: 'Location ID',
            hint: 'Enter the location ID',
          ),
          const ApiField(
            name: 'available',
            label: 'Available Quantity',
            hint: 'Enter the available quantity to set',
          ),
        ],
      };
}
