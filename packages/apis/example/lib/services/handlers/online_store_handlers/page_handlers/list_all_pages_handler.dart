import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 LIST ALL PAGES ***************************
///**************************************************************

class ListAllPagesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for listing pages
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional parameters
    final limit = params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final sinceId = params['since_id'];
    final title = params['title'];
    final handle = params['handle'];
    final createdAtMin = params['created_at_min'];
    final createdAtMax = params['created_at_max'];
    final updatedAtMin = params['updated_at_min'];
    final updatedAtMax = params['updated_at_max'];
    final publishedAtMin = params['published_at_min'];
    final publishedAtMax = params['published_at_max'];
    final fields = params['fields'];
    final publishedStatus = params['published_status'];

    try {
      // Call the API method
      final response = await GetIt.I<PageService>().listAllPages(
        apiVersion: ApiNetwork.apiVersion,
        limit: limit,
        sinceId: sinceId,
        title: title,
        handle: handle,
        createdAtMin: createdAtMin,
        createdAtMax: createdAtMax,
        updatedAtMin: updatedAtMin,
        updatedAtMax: updatedAtMax,
        publishedAtMin: publishedAtMin,
        publishedAtMax: publishedAtMax,
        fields: fields,
        publishedStatus: publishedStatus,
      );

      // Process the response based on fields parameter
      List<Map<String, dynamic>> pagesData;
      if (fields == null || fields.isEmpty) {
        // Return full page objects if no fields specified
        pagesData = response.pages?.map((page) => page.toJson()).toList() ?? [];
      } else {
        // Filter the response to only include requested fields
        pagesData = response.pages?.map((page) {
          final json = page.toJson();
          final filteredJson = <String, dynamic>{};
          final fieldsList = fields.split(',').map((f) => f.trim()).toList();
          
          for (final field in fieldsList) {
            if (json.containsKey(field)) {
              filteredJson[field] = json[field];
            }
          }
          
          return filteredJson;
        }).toList() ?? [];
      }

      // Return success response
      return {
        "status": "success",
        "message": "Pages retrieved successfully",
        "pages": pagesData,
        "count": response.pages?.length ?? 0,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve pages: ${e.toString()}",
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
        hint: 'Maximum number of pages to retrieve (max: 250)',
      ),
      const ApiField(
        name: 'since_id',
        label: 'Since ID',
        hint: 'Retrieve pages after the specified ID',
      ),
      const ApiField(
        name: 'title',
        label: 'Title',
        hint: 'Filter pages by title',
      ),
      const ApiField(
        name: 'handle',
        label: 'Handle',
        hint: 'Filter pages by handle',
      ),
      const ApiField(
        name: 'created_at_min',
        label: 'Created At Min',
        hint: 'Filter pages created after date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'created_at_max',
        label: 'Created At Max',
        hint: 'Filter pages created before date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'updated_at_min',
        label: 'Updated At Min',
        hint: 'Filter pages updated after date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'updated_at_max',
        label: 'Updated At Max',
        hint: 'Filter pages updated before date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'published_at_min',
        label: 'Published At Min',
        hint: 'Filter pages published after date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'published_at_max',
        label: 'Published At Max',
        hint: 'Filter pages published before date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include in the response',
      ),
      const ApiField(
        name: 'published_status',
        label: 'Published Status',
        hint: 'Filter by published status (published, unpublished, any)',
      ),
    ],
  };
}
