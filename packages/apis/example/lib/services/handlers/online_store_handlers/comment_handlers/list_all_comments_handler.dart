import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 LIST ALL COMMENTS ************************
///**************************************************************

class ListAllCommentsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for listing comments
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract all query parameters from the request
    final limit =
        params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final sinceId = params['since_id'];
    final createdAtMin = params['created_at_min'];
    final createdAtMax = params['created_at_max'];
    final updatedAtMin = params['updated_at_min'];
    final updatedAtMax = params['updated_at_max'];
    final publishedAtMin = params['published_at_min'];
    final publishedAtMax = params['published_at_max'];
    final fields = params['fields'];
    final publishedStatus = params['published_status'];
    final status = params['status'];

    try {
      // Call the API method with all possible parameters
      final response = await GetIt.I<CommentService>().listAllComments(
        apiVersion: ApiNetwork.apiVersion,
        limit: limit,
        sinceId: sinceId,
        createdAtMin: createdAtMin,
        createdAtMax: createdAtMax,
        updatedAtMin: updatedAtMin,
        updatedAtMax: updatedAtMax,
        publishedAtMin: publishedAtMin,
        publishedAtMax: publishedAtMax,
        fields: fields,
        publishedStatus: publishedStatus,
        status: status,
      );

      // Build query parameters for response
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (sinceId != null) queryParams['since_id'] = sinceId;
      if (createdAtMin != null) queryParams['created_at_min'] = createdAtMin;
      if (createdAtMax != null) queryParams['created_at_max'] = createdAtMax;
      if (updatedAtMin != null) queryParams['updated_at_min'] = updatedAtMin;
      if (updatedAtMax != null) queryParams['updated_at_max'] = updatedAtMax;
      if (publishedAtMin != null) {
        queryParams['published_at_min'] = publishedAtMin;
      }
      if (publishedAtMax != null) {
        queryParams['published_at_max'] = publishedAtMax;
      }
      if (fields != null) queryParams['fields'] = fields;
      if (publishedStatus != null) {
        queryParams['published_status'] = publishedStatus;
      }
      if (status != null) queryParams['status'] = status;

      // Return success response with field filtering if specified
      List<Map<String, dynamic>> commentsData;
      if (fields == null || fields.isEmpty) {
        // Return full comment objects if no fields specified
        commentsData = response.comments?.map((comment) => comment.toJson()).toList() ?? [];
      } else {
        // Filter the response to only include requested fields
        commentsData = response.comments?.map((comment) {
          final json = comment.toJson();
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

      return {
        "status": "success",
        "message": "Comments retrieved successfully",
        "comments": commentsData,
        "count": response.comments?.length ?? 0,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve comments: ${e.toString()}",
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
            hint: 'Maximum number of comments to retrieve (max: 250)',
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Retrieve comments after the specified ID',
          ),
          const ApiField(
            name: 'created_at_min',
            label: 'Created At Min',
            hint:
                'Filter comments created after date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created At Max',
            hint:
                'Filter comments created before date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated At Min',
            hint:
                'Filter comments updated after date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated At Max',
            hint:
                'Filter comments updated before date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'published_at_min',
            label: 'Published At Min',
            hint:
                'Filter comments published after date (format: 2023-01-01T00:00:00Z)',
          ),
          const ApiField(
            name: 'published_at_max',
            label: 'Published At Max',
            hint:
                'Filter comments published before date (format: 2023-01-01T00:00:00Z)',
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
          const ApiField(
            name: 'status',
            label: 'Status',
            hint:
                'Filter by comment status (pending, approved, spam, removed, etc)',
          ),
        ],
      };
}
