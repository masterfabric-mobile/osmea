import 'package:apis/apis.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 SPECIFIC CUSTOM COLLECTION ****************
///**************************************************************

class SpecificCustomCollectionsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for retrieving a custom collection
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final collectionId = params['collection_id'];

    // Extract optional parameters
    final fields = params['fields'];

    // Validate required parameters
    if (collectionId == null || collectionId.isEmpty) {
      return {
        "status": "error",
        "message": "Collection ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method
      final response =
          await GetIt.I<CustomCollectionsService>().specificCustomCollections(
        apiVersion: ApiNetwork.apiVersion,
        custom_collection_id: int.parse(collectionId),
        fields: fields,
      );

      // Process the collection data based on fields parameter
      Map<String, dynamic>? collectionData;
      if (fields == null || fields.isEmpty) {
        // Return full collection object if no fields specified
        collectionData = response.customCollection?.toJson();
      } else {
        // Filter the response to only include requested fields
        final json = response.customCollection?.toJson() ?? {};
        final filteredJson = <String, dynamic>{};
        final fieldsList = fields.split(',').map((f) => f.trim()).toList();

        for (final field in fieldsList) {
          if (json.containsKey(field)) {
            filteredJson[field] = json[field];
          }
        }

        collectionData = filteredJson;
      }

      // Return success response
      return {
        "status": "success",
        "message": "Custom collection retrieved successfully",
        "custom_collection": collectionData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve custom collection: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'collection_id',
            label: 'Collection ID',
            hint: 'The ID of the custom collection to retrieve',
            isRequired: true,
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
          ),
        ],
      };
}
