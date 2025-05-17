import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🔢 COUNT BLOG ARTICLES HANDLER 🔢 *****************
///*******************************************************************

class CountBlogArticlesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for counting blog articles
    if (method == 'GET') {
      // 🔍 Check if blog ID is provided - required parameter
      final blogId = params['blog_id'] ?? '';
      if (blogId.isEmpty) {
        return {
          "status": "error",
          "message": "Blog ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        int blogIdInt;

        // Convert blog ID to integer
        try {
          blogIdInt = int.parse(blogId);
        } catch (_) {
          return {
            "status": "error",
            "message": "Blog ID must be a valid number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Extract optional query parameters
        final createdAtMin = params['created_at_min'];
        final createdAtMax = params['created_at_max'];
        final updatedAtMin = params['updated_at_min'];
        final updatedAtMax = params['updated_at_max'];
        final publishedAtMin = params['published_at_min'];
        final publishedAtMax = params['published_at_max'];
        final publishedStatus = params['published_status']?.isNotEmpty == true ? params['published_status'] : null;
        
        // 📞 Call the article service API to count blog articles
        final response = await GetIt.I.get<ArticleService>().countBlogArticles(
              apiVersion: ApiNetwork.apiVersion,
              blogId: blogIdInt,
              createdAtMin: createdAtMin != null ? DateTime.tryParse(createdAtMin) : null,
              createdAtMax: createdAtMax != null ? DateTime.tryParse(createdAtMax) : null,
              updatedAtMin: updatedAtMin != null ? DateTime.tryParse(updatedAtMin) : null,
              updatedAtMax: updatedAtMax != null ? DateTime.tryParse(updatedAtMax) : null,
              publishedAtMin: publishedAtMin != null ? DateTime.tryParse(publishedAtMin) : null,
              publishedAtMax: publishedAtMax != null ? DateTime.tryParse(publishedAtMax) : null,
              publishedStatus: publishedStatus,
            );

        // 📋 Return the count data
        return {
          "status": "success",
          "blogId": blogId,
          "count": response.count,
          "message": "Article count successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling with status code detection
        String errorMessage = e.toString();
        int statusCode = 500;

        if (errorMessage.contains('404')) {
          statusCode = 404;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Blog not found. Please verify the blog ID exists.",
            "blogId": blogId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else if (errorMessage.contains('429')) {
          statusCode = 429;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Rate limit exceeded. Please try again later.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Default error response
        return {
          "status": "error",
          "statusCode": statusCode,
          "message": "Failed to retrieve article count: $errorMessage",
          "blogId": blogId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Count Blog Articles API",
      "supportedMethods": supportedMethods,
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'blog_id',
            label: 'Blog ID',
            hint: 'Enter blog ID to count articles',
          ),
          // Optional query parameters
          const ApiField(
            name: 'created_at_min',
            label: 'Created After',
            hint: 'Filter for articles created after date (ISO 8601)',
            isRequired: false,
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created Before',
            hint: 'Filter for articles created before date (ISO 8601)',
            isRequired: false,
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated After',
            hint: 'Filter for articles updated after date (ISO 8601)',
            isRequired: false,
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated Before',
            hint: 'Filter for articles updated before date (ISO 8601)',
            isRequired: false,
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'published_at_min',
            label: 'Published After',
            hint: 'Filter for articles published after date (ISO 8601)',
            isRequired: false,
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'published_at_max',
            label: 'Published Before',
            hint: 'Filter for articles published before date (ISO 8601)',
            isRequired: false,
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'published_status',
            label: 'Published Status',
            hint: 'Filter by published status (published, unpublished, any)',
            isRequired: false,
          ),
        ],
      };
}
