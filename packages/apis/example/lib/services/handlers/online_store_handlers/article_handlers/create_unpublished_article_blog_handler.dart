import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/request/create_unpublished_article_blog_request.dart'
    as unpublished_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE UNPUBLISHED ARTICLE ****************
///**************************************************************

class CreateUnpublishedArticleBlogHandler implements ApiRequestHandler {
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
    final bodyHtml = params['body_html']; // Changed from 'content'
    final tags = params['tags'];
    final publishedStr = params['published'] ?? 'false';
    final published =
        publishedStr.toLowerCase() == 'true'; // Convert string to boolean

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

    try {
      // Create the article request model with the published parameter
      final articleRequest =
          unpublished_request.CreateUnpublishedArticleBlogRequest(
        article: unpublished_request.Article(
          title: title,
          author: author,
          bodyHtml: bodyHtml, // Changed from 'content'
          tags: tags,
          published: published, // Using the boolean value from params
        ),
      );

      // Call the API method with the proper method that matches the request type
      final response =
          await GetIt.I<ArticleService>().createUnpublishedArticleBlog(
        apiVersion: ApiNetwork.apiVersion,
        blogId: int.parse(blogId),
        model: articleRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Unpublished article created successfully",
        "article": response.article!.toJson(),
        "params": {
          "blog_id": blogId,
          "title": title,
          "is_published": published, // Using the boolean value from params
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create unpublished article: ${e.toString()}",
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
            name: 'body_html',
            label: 'HTML Content',
            hint: 'The HTML content of the article',
          ),
          const ApiField(
            name: 'tags',
            label: 'Tags',
            hint: 'Comma-separated tags for the article',
          ),
          const ApiField(
            name: 'published',
            label: 'Published',
            hint: 'Article publication status (true/false)',
          ),
        ],
      };
}
