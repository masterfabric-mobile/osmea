import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/request/create_article_with_image_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE ARTICLE WITH IMAGE *****************
///**************************************************************

class CreateArticleWithImageHandler implements ApiRequestHandler {
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

    // Extract image parameters
    final imageUrl = params['image_url'];
    final imageAlt = params['image_alt'];

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

    if (imageUrl == null || imageUrl.isEmpty) {
      return {
        "status": "error",
        "message": "Image URL is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Prepare image data
      final image = Image(
        src: imageUrl,
        alt: imageAlt,
      );

      // Create the proper request model
      final articleRequest = CreateArticleWithImageRequest(
        article: Article(
          title: title,
          author: author ?? 'Anonymous',
          bodyHtml: content ?? '',
          tags: tags ?? '',
          publishedAt: publishedAt,
          image: image,
        ),
      );

      // Call the API method
      final response = await GetIt.I<ArticleService>().createArticleWithImage(
        apiVersion: ApiNetwork.apiVersion,
        blogId: int.parse(blogId),
        model: articleRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Article with image created successfully",
        "article": response.article!.toJson(),
        "params": {
          "blog_id": blogId,
          "title": title,
          "has_image": true,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create article with image: ${e.toString()}",
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
            name: 'image_url',
            label: 'Image URL',
            hint: 'The URL of the image to attach to the article',
            isRequired: true,
          ),
          const ApiField(
            name: 'image_alt',
            label: 'Image Alt Text',
            hint: 'Alternative text for the image',
          ),
        ],
      };
}
