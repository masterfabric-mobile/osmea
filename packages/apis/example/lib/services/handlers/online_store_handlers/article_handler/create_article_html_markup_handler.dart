import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/request/create_article_with_metafield_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE ARTICLE HTML MARKUP ***********
///**************************************************************

class CreateArticleHtmlMarkupHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for article creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final blogId = params['blog_id'];
    final title = params['title'];
    final author = params['author'];
    final htmlMarkup = params['html_markup'];
    final tags = params['tags'];
    final publishedAt = params['published_at'];

    // Validate required parameters
    if (blogId == null || blogId.isEmpty) {
      return {
        "status": "error",
        "message": "Blog ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Article title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (htmlMarkup == null || htmlMarkup.isEmpty) {
      return {
        "status": "error",
        "message": "HTML markup content is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the proper request model
      final articleRequest = CreateArticleWithMetafieldRequest(
        article: Article(
          title: title,
          author: author,
          bodyHtml: htmlMarkup,
          tags: tags,
          publishedAt: publishedAt,
          // Removed unnecessary fields (blogId, summaryHtml, templateSuffix)
        ),
      );

      // Call the API method - using createArticleWithMetafield since we don't need a separate endpoint
      final response =
          await GetIt.I<ArticleService>().createArticleWithMetafield(
        apiVersion: ApiNetwork.apiVersion,
        blogId: int.parse(blogId),
        model: articleRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Article with HTML markup created successfully",
        "article": response.article!.toJson(),
        "params": {
          "blog_id": blogId,
          "title": title,
          // Removed unnecessary fields from params
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create article with HTML markup: ${e.toString()}",
        "details": "Error occurred while creating article with HTML content",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'blog_id',
            label: 'Blog ID',
            hint: 'The ID of the blog to create the article in',
            isRequired: true,
          ),
          const ApiField(
            name: 'title',
            label: 'Title',
            hint: 'The title of the article',
            isRequired: true,
          ),
          const ApiField(
            name: 'author',
            label: 'Author',
            hint: 'The author of the article',
          ),
          const ApiField(
            name: 'html_markup',
            label: 'HTML Markup',
            hint: 'HTML content for the article body',
            isRequired: true,
          ),
          const ApiField(
            name: 'tags',
            label: 'Tags',
            hint: 'Comma-separated tags for the article',
          ),
          const ApiField(
            name: 'published_at',
            label: 'Published At',
            hint: 'Publication date (e.g. "Thu Mar 24 15:45:47 UTC 2011")',
          ),
        ],
      };
}
