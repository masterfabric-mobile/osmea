import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/request/update_article_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** ✏️ UPDATE ARTICLE HANDLER ✏️ **********************
///*******************************************************************

class UpdateArticleHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle PUT requests for updating articles
    if (method == 'PUT') {
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

        
        // Extract metafield parameters if provided
        List<Metafield>? metafields;
        if (params['metafield_key']?.isNotEmpty == true && 
            params['metafield_value']?.isNotEmpty == true) {
          metafields = [
            Metafield(
              key: params['metafield_key']!,
              value: params['metafield_value']!,
              type: params['metafield_type'] ?? 'single_line_text_field',
              namespace: params['metafield_namespace'] ?? 'global',
            )
          ];
        }

        // Create request that matches the expected JSON structure
        final updateRequest = UpdateArticleRequest(
          article: Article(
            id: articleIdInt,
            metafields: metafields ?? []
          ),
        );

        // 📞 Call the article service API to update the article
        final response = await GetIt.I.get<ArticleService>().updateArticle(
              apiVersion: ApiNetwork.apiVersion,
              blogId: blogIdInt,
              articleId: articleIdInt,
              model: updateRequest,
            );

        // 📋 Return the updated article data
        return {
          "status": "success",
          "blogId": blogId,
          "articleId": articleId,
          "article": response.article?.toJson(),
          "message": "Article successfully updated",
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
        } else if (errorMessage.contains('422')) {
          statusCode = 422;
          return {
            "status": "error",
            "statusCode": statusCode,
            "message": "Validation error. Please check your article data.",
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
          "message": "Failed to update article: $errorMessage",
          "blogId": blogId,
          "articleId": articleId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Update Article API",
      "supportedMethods": supportedMethods,
    };
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'blog_id',
            label: 'Blog ID',
            hint: 'Enter blog ID containing the article to update',
          ),
          const ApiField(
            name: 'article_id',
            label: 'Article ID',
            hint: 'Enter article ID to update',
          ),
          const ApiField(
            name: 'metafield_key',
            label: 'Metafield Key',
            hint: 'Key for the metafield to add/update',
            isRequired: false,
          ),
          const ApiField(
            name: 'metafield_value',
            label: 'Metafield Value',
            hint: 'Value for the metafield',
            isRequired: false,
          ),
          const ApiField(
            name: 'metafield_type',
            label: 'Metafield Type',
            hint: 'Type of metafield (default: single_line_text_field)',
            isRequired: false,
          ),
          const ApiField(
            name: 'metafield_namespace',
            label: 'Metafield Namespace',
            hint: 'Namespace for the metafield (default: global)',
            isRequired: false,
          ),
        ],
      };
}
