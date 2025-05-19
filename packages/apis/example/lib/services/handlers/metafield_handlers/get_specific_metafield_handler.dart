import 'package:apis/apis.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🏷️ GET SPECIFIC METAFIELD HANDLER 🏷️ ****************
///*******************************************************************

class GetSpecificMetafieldHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for retrieving a specific metafield
    if (method == 'GET') {
      // 🔍 Check if required parameters are provided
      final ownerId = params['owner_id'] ?? '';
      final ownerResource = params['owner_resource'] ?? '';
      final metafieldId = params['metafield_id'] ?? '';

      // Validate required parameters
      if (ownerId.isEmpty) {
        return {
          "status": "error",
          "message": "Owner ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (ownerResource.isEmpty) {
        return {
          "status": "error",
          "message": "Owner resource is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (metafieldId.isEmpty) {
        return {
          "status": "error",
          "message": "Metafield ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        // 📞 Call the metafield service API to get a specific metafield
        final response =
            await GetIt.I.get<MetafieldService>().getSpecificMetafield(
                  apiVersion: ApiNetwork.apiVersion,
                  ownerResource: ownerResource,
                  ownerId: ownerId,
                  metafieldId: metafieldId,
                  fields: params['fields'],
                );

        // 📋 Return the metafield data with field filtering if specified
        if (params['fields'] != null && params['fields']!.isNotEmpty) {
          try {
            // Parse the fields parameter (comma-separated)
            final requestedFields =
                params['fields']!.split(',').map((f) => f.trim()).toSet();

            // Filter response directly on the metafield object
            final fullJson = response.metafield?.toJson();

            // Create a new map with only the requested fields
            final filteredMetafield = Map<String, dynamic>.fromEntries(fullJson
                !.entries
                .where((entry) => requestedFields.contains(entry.key)));

            return {
              "status": "success",
              "metafield": filteredMetafield,
              "message":
                  "Metafield successfully retrieved with filtered fields",
              "fields_filtered": requestedFields.toList(),
              "timestamp": DateTime.now().toIso8601String(),
            };
          } catch (filterError) {
            // If filtering fails, return the full response
            return {
              "status": "success",
              "metafield": response.toJson(),
              "message":
                  "Metafield successfully retrieved, but field filtering failed",
              "error": filterError.toString(),
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
        } else {
          // Return full response if no fields filter specified
          return {
            "status": "success",
            "metafield": response.toJson(),
            "message": "Metafield successfully retrieved",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      } catch (e) {
        // ❌ Enhanced error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Check for specific error types
        if (errorMessage.contains('404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": 404,
            "message": "Metafield not found",
            "metafieldId": metafieldId,
            "ownerId": ownerId,
            "ownerResource": ownerResource,
            "details":
                "The specified metafield does not exist for this resource.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('403')) {
          statusCode = 403;
          return {
            "status": "error",
            "statusCode": 403,
            "message": "Access denied",
            "details":
                "Your API credentials don't have permission to access this metafield.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to retrieve metafield: $errorMessage",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Get Specific Metafield API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'owner_id',
            label: 'Owner ID',
            hint: 'ID of the resource that owns the metafield',
          ),
          const ApiField(
            name: 'owner_resource',
            label: 'Owner Resource',
            hint: 'Type of resource (product, collection, etc.)',
          ),
          const ApiField(
            name: 'metafield_id',
            label: 'Metafield ID',
            hint: 'ID of the metafield to retrieve',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields (Optional)',
            hint: 'Comma-separated list of fields to include in the response',
          ),
        ],
      };
}
