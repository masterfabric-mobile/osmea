import 'package:apis/apis.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 LIST ALL CUSTOM COLLECTIONS **************
///**************************************************************

class ListAllCustomCollectionsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for listing custom collections
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional parameters
    final limit =
        params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final sinceId = params['since_id'];
    final title = params['title'];
    final productId = params['product_id'];
    final handle = params['handle'];
    final updatedAtMin = params['updated_at_min'];
    final updatedAtMax = params['updated_at_max'];
    final publishedAtMin = params['published_at_min'];
    final publishedAtMax = params['published_at_max'];
    final publishedStatus = params['published_status'];
    final fields = params['fields'];

    try {
      // Call the API method
      final response =
          await GetIt.I<CustomCollectionsService>().listAllCustomCollections(
        apiVersion: ApiNetwork.apiVersion,
        limit: limit,
        since_id: sinceId,
        title: title,
        product_id: productId,
        handle: handle,
        updatedAtMin: updatedAtMin,
        updatedAtMax: updatedAtMax,
        publishedAtMin: publishedAtMin,
        publishedAtMax: publishedAtMax,
        published_status: publishedStatus,
        fields: fields,
      );

      // Process the response based on fields parameter
      // ignore: prefer_typing_uninitialized_variables
      var collectionsData;
      if (fields == null || fields.isEmpty) {
        // Return full collection objects if no fields specified
        collectionsData = response.customCollections
                ?.map((collection) => collection.toJson())
                .toList() ??
            [];
      } else {
        // Filter the response to only include requested fields
        collectionsData = response.customCollections?.map((collection) {
              final json = collection.toJson();
              final filteredJson = <String, dynamic>{};
              final fieldsList =
                  fields.split(',').map((f) => f.trim()).toList();

              for (final field in fieldsList) {
                if (json.containsKey(field)) {
                  filteredJson[field] = json[field];
                }
              }

              return filteredJson;
            }).toList() ??
            [];
      }

      // Return success response
      return {
        "status": "success",
        "message": "Custom collections retrieved successfully",
        "custom_collections": collectionsData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve custom collections: ${e.toString()}",
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
            name: 'limit',
            label: 'Limit',
            hint: 'Maximum number of custom collections to retrieve (max: 250)',
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Retrieve collections after the specified ID',
          ),
          const ApiField(
            name: 'title',
            label: 'Title',
            hint: 'Filter collections by title',
          ),
          const ApiField(
            name: 'product_id',
            label: 'Product ID',
            hint: 'Filter collections by product ID',
          ),
          const ApiField(
            name: 'collection_type',
            label: 'Collection Type',
            hint: 'Filter by collection type',
          ),
          const ApiField(
            name: 'handle',
            label: 'Handle',
            hint: 'Filter collections by handle',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated At Min',
            hint:
                'Filter collections updated after date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated At Max',
            hint:
                'Filter collections updated before date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'published_at_min',
            label: 'Published At Min',
            hint:
                'Filter collections published after date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'published_at_max',
            label: 'Published At Max',
            hint:
                'Filter collections published before date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'published_status',
            label: 'Published Status',
            hint: 'Filter by published status (published, unpublished, any)',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
          ),
        ],
      };
}
