import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔢 COUNT ALL PAGES **************************
///**************************************************************

class CountAllPagesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for counting pages
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional filter parameters
    final publishedStatus = params['published_status'];
    final createdAtMin = params['created_at_min'];
    final createdAtMax = params['created_at_max'];
    final updatedAtMin = params['updated_at_min'];
    final updatedAtMax = params['updated_at_max'];
    final publishedAtMin = params['published_at_min'];
    final publishedAtMax = params['published_at_max'];
    final title = params['title'];

    try {
      // Call the API method
      final response = await GetIt.I<PageService>().countAllPages(
        apiVersion: ApiNetwork.apiVersion,
        publishedStatus: publishedStatus,
        createdAtMin: createdAtMin,
        createdAtMax: createdAtMax,
        updatedAtMin: updatedAtMin,
        updatedAtMax: updatedAtMax,
        publishedAtMin: publishedAtMin,
        publishedAtMax: publishedAtMax,
        title: title,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Pages counted successfully",
        "count": response.count,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to count pages: ${e.toString()}",
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
        name: 'published_status',
        label: 'Published Status',
        hint: 'Filter by published status (published, unpublished, any)',
      ),
      const ApiField(
        name: 'title',
        label: 'Title',
        hint: 'Filter pages by title',
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
    ],
  };
}
