import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/location/abstract/location_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📦 LIST INVENTORY BY LOCATION ID HANDLER 📦 *******
///*******************************************************************

class ListInventoryByLocationIdHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for listing inventory at location
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
        // Convert string ID to integer
        final locationIdInt = int.parse(locationId);

        // 📞 Call the inventory level service API to get inventory at location
        final response =
            await GetIt.I.get<LocationService>().listInventoryByLocationId(
                  apiVersion: ApiNetwork.apiVersion,
                  locationId: locationIdInt,
                );

        // 📋 Return the inventory data for the location
        return {
          "status": "success",
          "locationId": locationId,
          "inventoryItems": response.toJson(),
          "message": "Inventory items at location successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // Check for number format exception
        if (e is FormatException) {
          return {
            "status": "error",
            "message": "Invalid Location ID format. Must be a number.",
            "locationId": locationId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // ❌ Error handling with detailed information
        String errorMessage = e.toString();
        int statusCode = 500;

        if (errorMessage.contains('404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": 404,
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
          "message": "Failed to retrieve inventory at location: $errorMessage",
          "locationId": locationId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for List Inventory By Location ID API",
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
            hint: 'Enter location ID to list inventory items',
          ),
        ],
      };
}
