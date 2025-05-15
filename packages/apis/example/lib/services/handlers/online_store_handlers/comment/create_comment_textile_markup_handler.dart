import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/request/create_comment_textile_markup_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 💬 CREATE COMMENT WITH TEXTILE MARKUP ********
///**************************************************************

class CreateCommentTextileMarkupHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for comment creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final articleId = params['article_id'];
    final author = params['author'];
    final email = params['email'];
    final body = params['body'];
    final ip = params['ip'];
    final blogId = params['blog_id'];

    // Validate required parameters
    if (articleId == null || articleId.isEmpty) {
      return {
        "status": "error",
        "message": "Article ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (author == null || author.isEmpty) {
      return {
        "status": "error",
        "message": "Author is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (email == null || email.isEmpty) {
      return {
        "status": "error",
        "message": "Email is required",
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

    if (blogId == null || blogId.isEmpty) {
      return {
        "status": "error",
        "message": "Blog ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the comment request model
      final commentRequest = CreateCommentTextileMarkupRequest(
        comment: Comment(
          articleId: int.parse(articleId),
          author: author,
          email: email,
          body: body,
          ip: ip,
          blogId: int.parse(
              blogId), 
        ),
      );

      // Call the API method
      final response =
          await GetIt.I<CommentService>().createCommentTextileMarkup(
        apiVersion: ApiNetwork.apiVersion,
        model: commentRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Comment created successfully",
        "comment": response.comment?.toJson(),
        "params": {
          "article_id": articleId,
          "author": author,
          "created_at": response.comment?.createdAt,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create comment: ${e.toString()}",
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
            name: 'article_id',
            label: 'Article ID',
            hint: 'The ID of the article to comment on',
            isRequired: true,
          ),
          const ApiField(
            name: 'author',
            label: 'Author',
            hint: 'The name of the comment author',
            isRequired: true,
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'The email of the comment author',
            isRequired: true,
          ),
          const ApiField(
            name: 'body',
            label: 'Body',
            hint: 'The comment text in Textile markup',
            isRequired: true,
          ),
          const ApiField(
            name: 'ip',
            label: 'IP Address',
            hint: 'The IP address of the comment author',
          ),
          const ApiField(
            name: 'blog_id',
            label: 'Blog ID',
            hint: 'The ID of the blog containing the article',
            isRequired: true,
          ),
        ],
      };
}
