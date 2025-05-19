import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_with_metafield_request.dart'
    as blog_metafield_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE BLOG WITH METAFIELD ***************
///**************************************************************

class CreateEmptyBlogWithMetafieldHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for blog creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final title = params['title'];
    final commentable = params['commentable'] ?? 'no';

    // Extract metafield parameters
    final metafieldKey = params['metafield_key'];
    final metafieldValue = params['metafield_value'];
    final metafieldType = params['metafield_type'] ?? 'single_line_text_field';
    final metafieldNamespace = params['metafield_namespace'] ?? 'global';

    // Validate required parameters
    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Blog title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (metafieldKey == null || metafieldKey.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield key is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (metafieldValue == null || metafieldValue.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield value is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create metafield object
      final metafield = blog_metafield_request.Metafield(
        key: metafieldKey,
        value: metafieldValue,
        type: metafieldType,
        namespace: metafieldNamespace,
      );

      // Create the blog request model
      final blogRequest =
          blog_metafield_request.CreateEmptyBlogWithMetafieldRequest(
        blog: blog_metafield_request.Blog(
          title: title,
          metafields: [metafield],
        ),
      );

      // Call the API method
      final response =
          await GetIt.I<BlogService>().createEmptyBlogWithMetafield(
        apiVersion: ApiNetwork.apiVersion,
        model: blogRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Blog with metafield created successfully",
        "blog": response.blog!.toJson(),
        "params": {
          "title": title,
          "commentable": commentable,
          "metafield_key": metafieldKey,
          "metafield_namespace": metafieldNamespace,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create blog with metafield: ${e.toString()}",
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
            name: 'title',
            label: 'Title',
            hint: 'The title of the blog',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_key',
            label: 'Metafield Key',
            hint: 'The key for the blog metafield',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_value',
            label: 'Metafield Value',
            hint: 'The value for the blog metafield',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_type',
            label: 'Metafield Type',
            hint: 'The type of the metafield (default: single_line_text_field)',
            isRequired: true,
          ),
          const ApiField(
            name: 'metafield_namespace',
            label: 'Metafield Namespace',
            hint: 'The namespace for the metafield (default: global)',
            isRequired: true,
          ),
        ],
      };
}
