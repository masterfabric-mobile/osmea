import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/request/create_article_base_image_request.dart'
    as base_image_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE ARTICLE WITH BASE64 IMAGE **********
///**************************************************************

class CreateArticleBaseImageHandler implements ApiRequestHandler {
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
    final content = params['content'];
    final tags = params['tags'];
    final publishedAt = params['published_at'];

    // Extract base64 image data
    final base64Image = params['base64_image'];

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

    if (base64Image == null || base64Image.isEmpty) {
      return {
        "status": "error",
        "message": "Base64 image data is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the article request model matching the exact structure needed
      final articleRequest = base_image_request.CreateArticleBaseImageRequest(
        article: base_image_request.Article(
          title: title,
          author: author,
          bodyHtml: content,
          tags: tags,
          publishedAt: publishedAt,
          image: base_image_request.Image(attachment: base64Image),
        ),
      );

      // Call the API method
      final response = await GetIt.I<ArticleService>().createArticleBaseImage(
        apiVersion: ApiNetwork.apiVersion,
        blogId: int.parse(blogId),
        model: articleRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Article with base64 image created successfully",
        "article": response.article!.toJson(),
        "params": {
          "blog_id": blogId,
          "title": title,
          "has_image": true,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors with more detailed information
      return {
        "status": "error",
        "message":
            "Failed to create article with base64 image: ${e.toString()}",
        "details": "Make sure the base64 image data is correctly formatted",
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
            name: 'content',
            label: 'Content',
            hint: 'The HTML content of the article',
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
          const ApiField(
            name: 'base64_image',
            label: 'Base64 Image',
            hint: 'Base64-encoded image data',
            isRequired: true,
          ),
        ],
      };
}
