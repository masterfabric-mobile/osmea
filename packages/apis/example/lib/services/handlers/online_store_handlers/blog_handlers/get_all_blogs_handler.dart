import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 GET ALL BLOGS ****************************
///**************************************************************

class GetAllBlogsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for retrieving blogs
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional parameters
    final sinceId = params['since_id'];
    final limit =
        params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final fields = params['fields'];
    final handlePrefix = params['handle'];

    try {
      // Call the API method
      final response = await GetIt.I<BlogService>().getAllBlogs(
        apiVersion: ApiNetwork.apiVersion,
        sinceId: sinceId,
        limit: limit,
        fields: fields,
        handle: handlePrefix,
      );

      // Determine what to return based on fields parameter
      List<Map<String, dynamic>>? blogsData;
      if (fields == null || fields.isEmpty) {
        // Return full blog objects if no fields specified
        blogsData = response.blogs?.map((blog) => blog.toJson()).toList();
      } else {
        // Filter the response to only include requested fields
        blogsData = response.blogs?.map((blog) {
          final json = blog.toJson();
          final filteredJson = <String, dynamic>{};
          final fieldsList = fields.split(',').map((f) => f.trim()).toList();

          for (final field in fieldsList) {
            if (json.containsKey(field)) {
              filteredJson[field] = json[field];
            }
          }

          return filteredJson;
        }).toList();
      }

      // Return success response
      return {
        "status": "success",
        "message": "Blogs retrieved successfully",
        "blogs": blogsData,
        "count": response.blogs?.length ?? 0,
        "params": {
          "since_id": sinceId,
          "limit": limit,
          "fields": fields,
          "handle": handlePrefix,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve blogs: ${e.toString()}",
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
            name: 'since_id',
            label: 'Since ID',
            hint: 'Retrieve blogs after the specified ID',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Number of blogs to retrieve (max: 250)',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include',
          ),
          const ApiField(
            name: 'handle',
            label: 'Handle Prefix',
            hint: 'Filter blogs by handle prefix',
          ),
        ],
      };
}
