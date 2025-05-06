import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/inventory_level/abstract/inventory_level_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📋 LIST INVENTORY LEVELS AT LOCATION HANDLER 📋 ***
///*******************************************************************

class ListInventoryLevelsSingleLocationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for inventory levels at location
    if (method == 'GET') {
      // 🔍 Check if location ID is provided - required parameter
      final locationId = params['location_id'] ?? '';
      if (locationId.isEmpty) {
        return {
          "status": "error",
          "message": "Location ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        int locationIdInt;

        // Convert location ID to integer
        try {
          locationIdInt = int.parse(locationId);
        } catch (_) {
          return {
            "status": "error",
            "message": "Location ID must be a valid number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Extract optional query parameters
        final limit = params['limit'];
        final updatedAtMin = params['updated_at_min'];

        // 📞 Call the inventory level service API to get levels at this location
        final response = await GetIt.I
            .get<InventoryLevelService>()
            .listInventoryLevelsSingleLocation(
              apiVersion: ApiNetwork.apiVersion,
              locationId: locationIdInt.toString(),
              limit: limit != null && limit.isNotEmpty
                  ? int.tryParse(limit)
                  : null,
              updatedAtMin: updatedAtMin,
            );

        // 📋 Return the inventory levels data
        return {
          "status": "success",
          "locationId": locationId,
          "inventoryLevels": response.toJson(),
          "count": response.inventoryLevels?.length ?? 0,
          "message": "Inventory levels at location successfully retrieved",
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
                "Location not found. Please verify the location ID exists.",
            "locationId": locationId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to retrieve inventory levels: $errorMessage",
          "locationId": locationId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for List Inventory Levels at Location API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'location_id',
            label: 'Location ID',
            hint: 'Enter location ID to retrieve inventory levels',
          ),
          // Optional fields
          const ApiField(
            name: 'limit',
            label: 'Results Limit',
            hint: 'Maximum number of results to return',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated After',
            hint:
                'Filter for inventory updated after this timestamp',
          ),
        ],
      };
}
