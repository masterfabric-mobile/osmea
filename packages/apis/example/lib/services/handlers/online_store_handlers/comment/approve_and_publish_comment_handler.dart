import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** ✅ APPROVE AND PUBLISH COMMENT ***************
///**************************************************************

class ApproveAndPublishCommentHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for approving comments
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final commentId = params['comment_id'];

    // Validate required parameters
    if (commentId == null || commentId.isEmpty) {
      return {
        "status": "error",
        "message": "Comment ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method
      final response = await GetIt.I<CommentService>().approveAndPublishComment(
        apiVersion: ApiNetwork.apiVersion,
        commentId: commentId,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Comment approved and published successfully",
        "comment": response.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to approve and publish comment: ${e.toString()}",
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
            hint: 'The ID of the comment to approve and publish',
            isRequired: true,
          ),
        ],
      };
}
