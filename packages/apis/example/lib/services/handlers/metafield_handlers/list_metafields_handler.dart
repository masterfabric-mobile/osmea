import 'package:apis/apis.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📋 LIST METAFIELDS HANDLER 📋 ******************
///*******************************************************************

class ListMetafieldsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for listing metafields
    if (method == 'GET') {
      // 🔍 Check if required parameters are provided
      final ownerId = params['owner_id'] ?? '';
      final ownerResource = params['owner_resource'] ?? '';

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

      try {
        // 📞 Call the metafield service API to list metafields
        final response = await GetIt.I.get<MetafieldService>().listMetafields(
              apiVersion: ApiNetwork.apiVersion,
              ownerResource: ownerResource,
              ownerId: ownerId,
              // Optional parameters
              namespace: params['namespace'],
              key: params['key'],
              type: params['type'],
              limit: params['limit'] != null
                  ? int.tryParse(params['limit']!)
                  : null,
              sinceId: params['since_id'],
              createdAtMin: params['created_at_min'],
              createdAtMax: params['created_at_max'],
              updatedAtMin: params['updated_at_min'],
              updatedAtMax: params['updated_at_max'],
              fields: params['fields'],
            );

        // 📋 Return the metafields data
        return {
          "status": "success",
          "metafields": response.toJson(),
          "count": response.metafields?.length ?? 0,
          "message": "Metafields successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };
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
            "message": "Owner resource not found",
            "ownerId": ownerId,
            "ownerResource": ownerResource,
            "details":
                "The specified owner resource with the given ID does not exist.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('403')) {
          statusCode = 403;
          return {
            "status": "error",
            "statusCode": 403,
            "message": "Access denied",
            "details":
                "Your API credentials don't have permission to access metafields for this resource.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to retrieve metafields: $errorMessage",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for List Metafields API",
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
            hint: 'ID of the resource to retrieve metafields for',
          ),
          const ApiField(
            name: 'owner_resource',
            label: 'Owner Resource',
            hint: 'Type of resource (product, collection, etc.)',
          ),
          // Optional fields
          const ApiField(
            name: 'namespace',
            label: 'Namespace (Optional)',
            hint: 'Filter metafields by namespace',
          ),
          const ApiField(
            name: 'key',
            label: 'Key (Optional)',
            hint: 'Filter metafields by key',
          ),
          const ApiField(
            name: 'type',
            label: 'Type (Optional)',
            hint: 'Filter metafields by type',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit (Optional)',
            hint: 'Maximum number of metafields to return (default: 50)',
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID (Optional)',
            hint: 'Retrieve metafields after the specified ID',
          ),
          const ApiField(
            name: 'created_at_min',
            label: 'Created After (Optional)',
            hint: 'Filter metafields created after this date (ISO 8601)',
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created Before (Optional)',
            hint: 'Filter metafields created before this date (ISO 8601)',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated After (Optional)',
            hint: 'Filter metafields updated after this date (ISO 8601)',
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated Before (Optional)',
            hint: 'Filter metafields updated before this date (ISO 8601)',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields (Optional)',
            hint: 'Comma-separated list of fields to include in the response',
          ),
        ],
      };
}
