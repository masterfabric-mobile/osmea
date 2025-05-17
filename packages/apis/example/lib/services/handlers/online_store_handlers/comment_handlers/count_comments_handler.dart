import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔢 COUNT COMMENTS ***************************
///**************************************************************

class CountCommentsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for counting comments
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
    final status = params['status'];

    try {
      // Call the API method
      final response = await GetIt.I<CommentService>().countComments(
        apiVersion: ApiNetwork.apiVersion,
        publishedStatus: publishedStatus,
        createdAtMin: createdAtMin,
        createdAtMax: createdAtMax,
        updatedAtMin: updatedAtMin,
        updatedAtMax: updatedAtMax,
        status: status,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Comments counted successfully",
        "count": response.count,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to count comments: ${e.toString()}",
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
        name: 'created_at_min',
        label: 'Created At Min',
        hint: 'Filter comments created after date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'created_at_max',
        label: 'Created At Max',
        hint: 'Filter comments created before date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'updated_at_min',
        label: 'Updated At Min',
        hint: 'Filter comments updated after date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'updated_at_max',
        label: 'Updated At Max',
        hint: 'Filter comments updated before date (format: 2023-01-01T00:00:00Z)',
      ),
      const ApiField(
        name: 'status',
        label: 'Status',
        hint: 'Filter by comment status (pending, approved, spam, removed)',
      ),
    ],
  };
}
