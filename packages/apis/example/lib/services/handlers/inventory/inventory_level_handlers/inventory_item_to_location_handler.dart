import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_level/abstract/inventory_level_service.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_to_location_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🔗 INVENTORY ITEM TO LOCATION HANDLER 🔗 **********
///*******************************************************************

class InventoryItemToLocationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle POST requests for connecting inventory items to locations
    if (method == 'POST') {
      final inventoryItemIdStr = params['inventory_item_id'] ?? '';
      final locationIdStr = params['location_id'] ?? '';

      int inventoryItemId;
      int locationId;

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
        // 🔄 Create request model with inventory item ID, location ID, and initial quantity
        final request = InventoryItemToLocationRequest(
          inventoryItemId: inventoryItemId,
          locationId: locationId,
        );

        // 📞 Call the inventory level service API to connect item to location
        final response =
            await GetIt.I.get<InventoryLevelService>().inventoryItemToLocation(
                  apiVersion: ApiNetwork.apiVersion,
                  model: request,
                );

        // 📋 Return the inventory level connection data
        return {
          "status": "success",
          "inventoryItemId": inventoryItemId,
          "locationId": locationId,
          "inventoryLevel": response.toJson(),
          "message": "Inventory item successfully connected to location",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Enhanced error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Improved 404 error detection and handling
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
                "Either the inventory item ID or location ID does not exist. Please verify both IDs are correct.",
            "troubleshooting": [
              "Check that inventory item ID: $inventoryItemId exists in the system",
              "Verify that location ID: $locationId is valid",
              "Ensure you have permission to access these resources",
              "Try retrieving the individual items first to confirm they exist"
            ],
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('422')) {
          statusCode = 422;
          return {
            "status": "error",
            "statusCode": 422,
            "message":
                "This inventory item is already connected to this location.",
            "inventoryItemId": inventoryItemId,
            "locationId": locationId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message":
              "Failed to connect inventory item to location: $errorMessage",
          "inventoryItemId": inventoryItemId,
          "locationId": locationId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for Inventory Item To Location API",
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
            hint: 'Enter inventory item ID to connect',
          ),
          const ApiField(
            name: 'location_id',
            label: 'Location ID',
            hint: 'Enter the location ID to connect to the inventory item',
          )
        ],
      };
}
