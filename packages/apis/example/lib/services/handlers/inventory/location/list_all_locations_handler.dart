import 'package:apis/apis.dart';
import 'package:apis/network/remote/inventory/location/abstract/location_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📍 LIST ALL LOCATIONS HANDLER 📍 *****************
///*******************************************************************

class ListAllLocationsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for listing locations
    if (method == 'GET') {
      try {
        // 📞 Call the location service API to get all locations
        final response = await GetIt.I.get<LocationService>().listAllLocations(
              apiVersion: ApiNetwork.apiVersion,
            );

        // 📋 Return the locations data
        return {
          "status": "success",
          "locations": response.toJson(),
          "locationsCount": response.locations?.length ?? 0,
          "message": "Successfully retrieved all locations",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling with more detailed information
        String errorMessage = e.toString();
        int statusCode = 500;

        if (errorMessage.contains('401')) {
          statusCode = 401;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message":
                "Authentication failed. Please check your API credentials.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('403')) {
          statusCode = 403;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Insufficient permissions to access location data.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to retrieve locations: $errorMessage",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for List All Locations API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [], // No required fields for listing all locations
      };
}
