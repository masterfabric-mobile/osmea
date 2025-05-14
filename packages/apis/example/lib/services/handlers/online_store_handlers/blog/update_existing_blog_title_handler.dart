import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/update_existing_blog_title_request.dart' as request;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 UPDATE EXISTING BLOG TITLE ***************
///**************************************************************

class UpdateExistingBlogTitleHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating blog
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
    final handle = params['handle'];
    final commentable = params['commentable'] ?? 'no';

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

    if (handle == null || handle.isEmpty) {
      return {
        "status": "error",
        "message": "Blog handle is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // No need to validate commentable here since it's a string and any string value is valid
    // For reference, common values are "yes", "no", or "moderate"

    try {
      // Create the blog request model - ensuring all fields from the model are used correctly
      final updateRequest = request.UpdateExistingBlogTitleRequest(
        blog: request.Blog(
          id: int.parse(blogId),
          title: title,
          handle: handle,
          commentable: commentable, // Pass as-is, it accepts any string value
        ),
      );

      // Call the API method
      final response = await GetIt.I<BlogService>().updateExistingBlogTitle(
        apiVersion: ApiNetwork.apiVersion,
        blogId: blogId,
        model: updateRequest,
      );

      // Return success response with more blog details from the response
      return {
        "status": "success",
        "message": "Blog title updated successfully",
        "blog": response.blog?.toJson(),
        "params": {
          "blog_id": blogId,
          "title": title,
          "handle": handle,
          "commentable": commentable,
          "updated_at": response.blog?.updatedAt,
          "created_at": response.blog?.createdAt,
          "tags": response.blog?.tags,
        },
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
      const ApiField(
        name: 'handle',
        label: 'Handle',
        hint: 'The URL handle for the blog',
        isRequired: true,
      ),
      const ApiField(
        name: 'commentable',
        label: 'Commentable',
        hint: 'Whether the blog is commentable',
      ),
    ],
  };
}
