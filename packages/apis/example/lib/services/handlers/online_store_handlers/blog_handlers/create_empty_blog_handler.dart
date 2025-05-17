import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_request.dart'
    as blog_request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 CREATE EMPTY BLOG *************************
///**************************************************************

class CreateEmptyBlogHandler implements ApiRequestHandler {
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

    // Validate required parameters
    if (title == null || title.isEmpty) {
      return {
        "status": "error",
        "message": "Blog title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the blog request model using correct request class
      final blogRequest = blog_request.CreateEmptyBlogRequest(
        blog: blog_request.Blog(
          title: title,
        ),
      );

      // Call the API method with correct method name
      final response = await GetIt.I<BlogService>().createEmptyBlog(
        apiVersion: ApiNetwork.apiVersion,
        model: blogRequest,
      );

      // Return success response using correct response type properties
      return {
        "status": "success",
        "message": "Empty blog created successfully",
        "blog": response.blog!.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create blog: ${e.toString()}",
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
        ],
      };
}
