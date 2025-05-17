import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🗑️ REMOVE BLOG *********************
///**************************************************************

class RemoveBlogHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle DELETE requests for removing blogs
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only DELETE is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final blogId = params['blog_id'];
    
    // Validate required parameters
    if (blogId == null || blogId.isEmpty) {
      return {
        "status": "error",
        "message": "Blog ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method to delete the blog
      await GetIt.I<BlogService>().removeBlog(
        apiVersion: ApiNetwork.apiVersion,
        blogId: blogId,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Blog deleted successfully",
        "params": {
          "blog_id": blogId,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to delete blog: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'DELETE': [
      const ApiField(
        name: 'blog_id',
        label: 'Blog ID',
        hint: 'The ID of the blog to delete',
        isRequired: true,
      ),
    ],
  };
}
