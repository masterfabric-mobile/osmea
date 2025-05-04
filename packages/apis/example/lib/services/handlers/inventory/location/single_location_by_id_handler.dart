import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/location/abstract/location_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📍 SINGLE LOCATION BY ID HANDLER 📍 **************
///*******************************************************************

class SingleLocationByIdHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for location retrieval
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

        // 📞 Call the location service API to get location details
        final response = await GetIt.I.get<LocationService>().getLocationById(
              apiVersion: ApiNetwork.apiVersion,
              locationId: locationIdInt,
            );

        // 📋 Return the location data
        return {
          "status": "success",
          "locationId": locationId,
          "location": response.toJson(),
          "message": "Location details successfully retrieved",
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

        // ❌ General error handling
        return {
          "status": "error",
          "message": "Failed to retrieve location: ${e.toString()}",
          "locationId": locationId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Single Location By ID API",
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
            hint: 'Enter location ID to retrieve details',
          ),
        ],
      };
}
