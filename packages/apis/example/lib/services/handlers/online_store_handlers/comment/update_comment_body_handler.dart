import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/request/update_comment_body_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** ✏️ UPDATE COMMENT BODY **********************
///**************************************************************

class UpdateCommentBodyHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating comments
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters from API fields
    final commentId = params['comment_id'];
    final body = params['body'];
    final author = params['author'];
    final email = params['email'];
    final publishedAt = params[
        'published_at']; 

    // Validate required parameters
    if (commentId == null || commentId.isEmpty) {
      return {
        "status": "error",
        "message": "Comment ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (body == null || body.isEmpty) {
      return {
        "status": "error",
        "message": "Comment body is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the update request model with the correct fields as per API
      final updateRequest = UpdateCommentBodyRequest(
        comment: Comment(
          id: int.parse(commentId),
          body: body,
          author: author, 
          email: email,
          publishedAt:
              publishedAt, 
        ),
      );

      // Call the API method
      final response = await GetIt.I<CommentService>().updateCommentBody(
        apiVersion: ApiNetwork.apiVersion,
        commentId: commentId,
        model: updateRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Comment body updated successfully",
        "comment": response.comment?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle any errors that occur during the update
      return {
        "status": "error",
        "message": "Failed to update comment body: ${e.toString()}",
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
            name: 'comment_id',
            label: 'Comment ID',
            hint: 'The ID of the comment to update',
            isRequired: true,
          ),
          const ApiField(
            name: 'body',
            label: 'Body',
            hint: 'The new body text for the comment',
            isRequired: true,
          ),
          const ApiField(
            name: 'author', 
            label: 'Author',
            hint: 'The name of the comment author',
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'The email of the comment author',
          ),
          const ApiField(
            name: 'published_at', 
            label: 'Published At',
            hint:
                'Publication date in ISO 8601 format (e.g. 2020-01-14T15:42:13.430Z)',
          ),
        ],
      };
}
