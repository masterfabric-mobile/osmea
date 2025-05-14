import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/request/create_article_with_metafield_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE ARTICLE WITH METAFIELD *************
///**************************************************************

class CreateArticleWithMetafieldHandler implements ApiRequestHandler {
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

    // Extract metafield parameters
    final metafieldKey = params['metafield_key'];
    final metafieldValue = params['metafield_value'];
    final metafieldType = params['metafield_type'] ?? 'single_line_text_field';
    final metafieldNamespace = params['metafield_namespace'] ?? 'global';

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
      // Prepare metafields array if metafield data is provided
      List<Metafield>? metafields;
      if (metafieldKey != null &&
          metafieldKey.isNotEmpty &&
          metafieldValue != null &&
          metafieldValue.isNotEmpty) {
        metafields = [
          Metafield(
            key: metafieldKey,
            value: metafieldValue,
            type: metafieldType,
            namespace: metafieldNamespace,
          ),
        ];
      }

      // Create the proper request model
      final articleRequest = CreateArticleWithMetafieldRequest(
        article: Article(
          title: title,
          author: author,
          bodyHtml: content,
          tags: tags,
          publishedAt: publishedAt,
          metafields: metafields,
        ),
      );

      // Call the correct API method
      final response =
          await GetIt.I<ArticleService>().createArticleWithMetafield(
        apiVersion: ApiNetwork.apiVersion,
        blogId: int.parse(blogId),
        model: articleRequest,
      );

      // Return success response without unnecessary null-aware operator
      return {
        "status": "success",
        "message": "Article created successfully",
        "article": response.article,
        "params": {
          "blog_id": blogId,
          "title": title,
          "has_metafield": metafields != null,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create article: ${e.toString()}",
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
            name: 'metafield_key',
            label: 'Metafield Key',
            hint: 'The key for the article metafield',
          ),
          const ApiField(
            name: 'metafield_value',
            label: 'Metafield Value',
            hint: 'The value for the article metafield',
          ),
          const ApiField(
            name: 'metafield_type',
            label: 'Metafield Type',
            hint: 'The type of the metafield (default: single_line_text_field)',
          ),
          const ApiField(
            name: 'metafield_namespace',
            label: 'Metafield Namespace',
            hint: 'The namespace for the metafield (default: global)',
          ),
        ],
      };
}
