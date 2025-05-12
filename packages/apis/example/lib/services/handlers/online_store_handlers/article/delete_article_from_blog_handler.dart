import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 🗑️ DELETE ARTICLE HANDLER 🗑️ ********************
///*******************************************************************

class DeleteArticleFromBlogHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle DELETE requests for articles
    if (method == 'DELETE') {
      // 🔍 Check if blog ID is provided - required parameter
      final blogId = params['blog_id'] ?? '';
      if (blogId.isEmpty) {
        return {
          "status": "error",
          "message": "Blog ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // 🔍 Check if article ID is provided - required parameter
      final articleId = params['article_id'] ?? '';
      if (articleId.isEmpty) {
        return {
          "status": "error",
          "message": "Article ID is required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      try {
        int blogIdInt;
        int articleIdInt;

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

        // Convert article ID to integer
        try {
          articleIdInt = int.parse(articleId);
        } catch (_) {
          return {
            "status": "error",
            "message": "Article ID must be a valid number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // 📞 Call the article service API to delete the article
        await GetIt.I.get<ArticleService>().deleteArticle(
              apiVersion: ApiNetwork.apiVersion,
              blogId: blogIdInt,
              articleId: articleIdInt,
            );

        // 📋 Return success response
        return {
          "status": "success",
          "blogId": blogId,
          "articleId": articleId,
          "message": "Article successfully deleted",
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
            "message": "Article or blog not found. Please verify the IDs exist.",
            "blogId": blogId,
            "articleId": articleId,
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
          "message": "Failed to delete article: $errorMessage",
          "blogId": blogId,
          "articleId": articleId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Delete Article API",
      "supportedMethods": supportedMethods,
    };
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'DELETE': [
          const ApiField(
            name: 'blog_id',
            label: 'Blog ID',
            hint: 'Enter blog ID containing the article to delete',
          ),
          const ApiField(
            name: 'article_id',
            label: 'Article ID',
            hint: 'Enter article ID to delete',
          ),
        ],
      };
}
