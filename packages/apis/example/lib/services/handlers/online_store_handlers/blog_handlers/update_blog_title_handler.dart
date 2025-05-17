import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/update_blog_title_request.dart' as blog_title;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 UPDATE BLOG TITLE ************************
///**************************************************************

class UpdateBlogTitleHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating blog title
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final blogId = params['blog_id'];
    final title = params['title'];

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
        "message": "New title is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the blog request model
      final updateRequest = blog_title.UpdateBlogTitleRequest(
        blog: blog_title.Blog(
          id: int.parse(blogId),
          title: title,
        ),
      );

      // Call the API method
      final response = await GetIt.I<BlogService>().updateBlogTitle(
        apiVersion: ApiNetwork.apiVersion,
        blogId: blogId,
        model: updateRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Blog title updated successfully",
        "blog": response.blog?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to update blog title: ${e.toString()}",
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
            hint: 'The ID of the blog to update',
            isRequired: true,
          ),
          const ApiField(
            name: 'title',
            label: 'Title',
            hint: 'The new title for the blog',
            isRequired: true,
          ),
        ],
      };
}
