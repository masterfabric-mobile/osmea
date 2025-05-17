import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/metafield_existing_blog_request.dart'
    as request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*********** 🏷️ METAFIELD TO EXISTING BLOG **************
///**************************************************************

class MetafieldExistingBlogHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for adding metafields
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final blogId = params['blog_id'];
    final metafieldKey = params['metafield_key'];
    final metafieldValue = params['metafield_value'];
    final metafieldType = params['metafield_type'];
    final metafieldNamespace = params['metafield_namespace'];

    // Validate required parameters
    if (blogId == null || blogId.isEmpty) {
      return {
        "status": "error",
        "message": "Blog ID is required",
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

    if (metafieldType == null || metafieldType.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield type is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
    if (metafieldNamespace == null || metafieldNamespace.isEmpty) {
      return {
        "status": "error",
        "message": "Metafield namespace is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create metafield object
      final metafield = request.Metafield(
        key: metafieldKey,
        value: metafieldValue,
        type: metafieldType,
        namespace: metafieldNamespace,
      );

      // Create the blog object with ID and metafields
      final blog = request.Blog(
        id: int.parse(blogId),
        metafields: [metafield],
      );

      // Create the request model with the blog object
      final metafieldRequest = request.MetafieldExistingBlogRequest(
        blog: blog,
      );

      // Call the API method
      final response = await GetIt.I<BlogService>().addMetafieldToExistingBlog(
        apiVersion: ApiNetwork.apiVersion,
        blogId: blogId,
        model: metafieldRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Metafield added to blog successfully",
        "blog": response.blog?.toJson(),
        "params": {
          "blog_id": blogId,
          "metafield_key": metafieldKey,
          "metafield_namespace": metafieldNamespace,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to add metafield to blog: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'blog_id',
            label: 'Blog ID',
            hint: 'The ID of the blog to add the metafield to',
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
          ),
          const ApiField(
            name: 'metafield_namespace',
            label: 'Metafield Namespace',
            hint: 'The namespace for the metafield (default: global)',
          ),
        ],
      };
}
