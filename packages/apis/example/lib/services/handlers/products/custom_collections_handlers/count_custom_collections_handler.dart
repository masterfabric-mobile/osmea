import 'package:apis/apis.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔢 COUNT CUSTOM COLLECTIONS *****************
///**************************************************************

class CountCustomCollectionsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for counting custom collections
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional filter parameters
    final title = params['title'];
    final productId = params['product_id'];
    final publishedStatus = params['published_status'];
    final updatedAtMin = params['updated_at_min'];
    final updatedAtMax = params['updated_at_max'];
    final publishedAtMin = params['published_at_min'];
    final publishedAtMax = params['published_at_max'];

    try {
      // Call the API method
      final response =
          await GetIt.I<CustomCollectionsService>().countCustomCollections(
        apiVersion: ApiNetwork.apiVersion,
        title: title,
        product_id: productId,
        published_status: publishedStatus,
        updatedAtMin: updatedAtMin,
        updatedAtMax: updatedAtMax,
        publishedAtMin: publishedAtMin,
        publishedAtMax: publishedAtMax,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Custom collections counted successfully",
        "count": response.count,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to count custom collections: ${e.toString()}",
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
            name: 'published_status',
            label: 'Published Status',
            hint: 'Filter by published status (published, unpublished, any)',
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
        ],
      };
}
