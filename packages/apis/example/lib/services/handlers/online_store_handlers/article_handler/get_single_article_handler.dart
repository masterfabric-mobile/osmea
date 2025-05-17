import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📝 GET SINGLE ARTICLE HANDLER 📝 ******************
///*******************************************************************

class GetSingleArticleHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for single article
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

        // Extract optional query parameters
        final fields = params['fields']?.isNotEmpty == true ? params['fields'] : null;
        
        // 📞 Call the article service API to get the article
        final response = await GetIt.I.get<ArticleService>().getSingleArticle(
              apiVersion: ApiNetwork.apiVersion,
              blogId: blogIdInt,
              articleId: articleIdInt,
              fields: fields,
            );

        // 📋 Prepare the response
        final successResponse = <String, dynamic>{
          "status": "success",
          "blogId": blogId,
          "articleId": articleId,
          "message": "Article successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };

        // If fields parameter was provided, filter the article to include only those fields
        if (fields != null) {
          final fieldsList = fields.split(',');
          
          // Filter the article to only include the requested fields
          final articleMap = response.article?.toJson() ?? {};
          final filteredArticle = <String, dynamic>{};
          
          for (final field in fieldsList) {
            final trimmedField = field.trim();
            if (articleMap.containsKey(trimmedField)) {
              filteredArticle[trimmedField] = articleMap[trimmedField];
            }
          }
          
          // Fix: Add the filtered article as a Map directly, not trying to cast to String
          successResponse["article"] = filteredArticle;
          successResponse["requestedFields"] = fields;
        } else {
          // Fix: Add the article object directly, not trying to cast to String
          successResponse["article"] = response.article?.toJson();
        }
        
        return successResponse;
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
          "message": "Failed to retrieve article: $errorMessage",
          "blogId": blogId,
          "articleId": articleId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for Get Single Article API",
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
            hint: 'Enter blog ID that contains the article',
          ),
          const ApiField(
            name: 'article_id',
            label: 'Article ID',
            hint: 'Enter article ID to retrieve',
          ),
          // Optional query parameters
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
            isRequired: false,
          ),
        ],
      };
}
