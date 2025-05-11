import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🏷️ LIST TAGS FOR SPECIFIC BLOG HANDLER 🏷️ ********
///*******************************************************************

class ListTagsSpecificBlogHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for blog tags
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

        // 📞 Call the article service API to get tags for the specified blog
        final response =
            await GetIt.I.get<ArticleService>().listTagsSpecificBlog(
                  apiVersion: ApiNetwork.apiVersion,
                  blogId: blogIdInt,
                );

        // 📋 Return the blog tags data
        return {
          "status": "success",
          "blogId": blogId,
          "tags": response.tags,
          "count": response.tags?.length ?? 0,
          "message": "Blog tags successfully retrieved",
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
        }

        // Default error response
        return {
          "status": "error",
          "message": "Failed to retrieve blog tags: $errorMessage",
          "blogId": blogId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error":
          "Method $method not supported for List Tags For Specific Blog API",
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
            hint: 'Enter blog ID to retrieve tags',
          ),
        ],
      };
}
