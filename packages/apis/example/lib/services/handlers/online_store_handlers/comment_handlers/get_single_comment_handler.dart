import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 GET SINGLE COMMENT ***********************
///**************************************************************

class GetSingleCommentHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for retrieving a single comment
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final commentId = params['comment_id'];
    final fields = params['fields']; // Optional parameter for field filtering
    
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
      final response = await GetIt.I<CommentService>().getSingleComment(
        apiVersion: ApiNetwork.apiVersion,
        commentId: commentId,
        fields: fields,
      );

      // Process the comment data based on fields parameter
      var commentData;
      if (fields == null || fields.isEmpty) {
        // Return full comment object if no fields specified
        commentData = response.comment?.toJson();
      } else {
        // Filter the response to only include requested fields
        final json = response.comment?.toJson() ?? {};
        final filteredJson = <String, dynamic>{};
        final fieldsList = fields.split(',').map((f) => f.trim()).toList();
        
        for (final field in fieldsList) {
          if (json.containsKey(field)) {
            filteredJson[field] = json[field];
          }
        }
        
        commentData = filteredJson;
      }

      // Return success response
      return {
        "status": "success",
        "message": "Comment retrieved successfully",
        "comment": commentData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve comment: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'GET': [
      const ApiField(
        name: 'comment_id',
        label: 'Comment ID',
        hint: 'The ID of the comment to retrieve',
        isRequired: true,
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include in the response',
      ),
    ],
  };
}
