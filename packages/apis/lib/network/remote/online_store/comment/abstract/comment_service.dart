import 'package:apis/network/remote/online_store/comment/freezed_model/request/create_comment_textile_markup_request.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/approve_and_publish_comment_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/create_comment_textile_markup_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/mark_comment_not_spam_restore_response.dart';

abstract class CommentService {
    /// 📦 Create a comment with textile markup
    Future<CreateCommentTextileMarkupResponse> createCommentTextileMarkup({
      required String apiVersion,
      required CreateCommentTextileMarkupRequest model,
    });

    /// 📦 Approve a comment and publish it to the blog
    Future<ApproveAndPublishCommentResponse> approveAndPublishComment({
      required String apiVersion,
      required String commentId,
    });

    /// 📦 Mark a comment as not spam, restoring it to an unapproved or published state
    Future<MarkCommentNotSpamRestoreResponse> MarkCommentNotSpamRestore({
      required String apiVersion,
      required String commentId,
    });

    /// 📦 Remove a comment 
    Future<void> removeComment({
      required String apiVersion,
      required String commentId,
    });
}