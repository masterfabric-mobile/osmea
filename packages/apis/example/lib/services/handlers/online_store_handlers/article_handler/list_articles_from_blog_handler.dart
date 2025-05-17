import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📚 LIST ARTICLES FROM BLOG HANDLER 📚 *************
///*******************************************************************

class ListArticlesFromBlogHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for blog articles
    if (method == 'GET') {
      // 🔍 Check if blog ID is provided - required parameter
      final blogId = params['blog_id'] ?? '';
      // Only blog_id is required, all other parameters are optional
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

        // Extract optional query parameters - all will be null if not provided
        final limit = params['limit'];
        final sinceId = params['since_id'];
        final createdAtMin = params['created_at_min'];
        final createdAtMax = params['created_at_max'];
        final updatedAtMin = params['updated_at_min'];
        final updatedAtMax = params['updated_at_max'];
        final publishedAtMin = params['published_at_min'];
        final publishedAtMax = params['published_at_max'];
        final publishedStatus = params['published_status']?.isNotEmpty == true ? params['published_status'] : null;
        final handle = params['handle']?.isNotEmpty == true ? params['handle'] : null;
        final tag = params['tag']?.isNotEmpty == true ? params['tag'] : null;
        final author = params['author']?.isNotEmpty == true ? params['author'] : null;
        final fields = params['fields']?.isNotEmpty == true ? params['fields'] : null;
        
        // All parameters are null by default if not provided or empty,
        // ensuring they won't appear in the generated URL
        final response = await GetIt.I.get<ArticleService>().listArticlesFromBlog(
              apiVersion: ApiNetwork.apiVersion,
              blogId: blogIdInt,
              // These conversions ensure parameters are null if empty or invalid
              limit: limit != null && limit.isNotEmpty
                  ? int.tryParse(limit)
                  : null,
              sinceId: sinceId != null && sinceId.isNotEmpty
                  ? int.tryParse(sinceId)
                  : null,
              createdAtMin: createdAtMin != null ? DateTime.tryParse(createdAtMin) : null,
              createdAtMax: createdAtMax != null ? DateTime.tryParse(createdAtMax) : null,
              updatedAtMin: updatedAtMin != null ? DateTime.tryParse(updatedAtMin) : null,
              updatedAtMax: updatedAtMax != null ? DateTime.tryParse(updatedAtMax) : null,
              publishedAtMin: publishedAtMin != null ? DateTime.tryParse(publishedAtMin) : null,
              publishedAtMax: publishedAtMax != null ? DateTime.tryParse(publishedAtMax) : null,
              publishedStatus: publishedStatus,
              handle: handle,
              tag: tag,
              author: author,
              fields: fields,
            );

        // 📋 Prepare the response
        final successResponse = {
          "status": "success",
          "blogId": blogId,
          "count": response.articles?.length ?? 0,
          "message": "Blog articles successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };

        // If fields parameter was provided, filter the articles to include only those fields
        if (fields != null) {
          final fieldsList = fields.split(',');
          
          // Filter each article to only include the requested fields
          final filteredArticles = response.articles?.map((article) {
            final articleMap = article.toJson();
            final filteredArticle = <String, dynamic>{};
            
            for (final field in fieldsList) {
              final trimmedField = field.trim();
              if (articleMap.containsKey(trimmedField)) {
                filteredArticle[trimmedField] = articleMap[trimmedField];
              }
            }
            
            return filteredArticle;
          }).toList();
          
          successResponse["articles"] = filteredArticles!;
          successResponse["requestedFields"] = fields;
        } else {
          // No fields filter - include all article data
          successResponse["articles"] = response.articles!;
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
          "message": "Failed to retrieve blog articles: $errorMessage",
          "blogId": blogId,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for List Articles From Blog API",
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
            hint: 'Enter blog ID to retrieve articles',
          ),
          // Optional query parameters
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Maximum number of articles to retrieve (default: 50)',
            isRequired: false,
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Retrieve only articles after the specified ID',
            isRequired: false,
            type: ApiFieldType.number,
          ),
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
          const ApiField(
            name: 'handle',
            label: 'Handle',
            hint: 'Filter by article handle',
            isRequired: false,
          ),
          const ApiField(
            name: 'tag',
            label: 'Tag',
            hint: 'Filter by tag',
            isRequired: false,
          ),
          const ApiField(
            name: 'author',
            label: 'Author',
            hint: 'Filter by author',
            isRequired: false,
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
            isRequired: false,
          ),
        ],
      };
}
