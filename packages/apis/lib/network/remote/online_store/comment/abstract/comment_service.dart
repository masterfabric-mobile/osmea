import 'package:apis/network/remote/online_store/comment/freezed_model/request/create_comment_textile_markup_request.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/request/update_comment_body_request.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/approve_and_publish_comment_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/count_comments_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/create_comment_textile_markup_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/get_single_comment_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/list_all_comments_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/mark_comment_as_spam_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/mark_comment_not_spam_restore_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/restore_removed_comment_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/update_comment_body_response.dart';

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

    /// 📦 Restore Remove Comment Response
    Future<RestoreRemovedCommentResponse> restoreRemoveComment({
      required String apiVersion,
      required String commentId,
    });

    /// 📦 Mark a comment as spam
    Future<MarkCommentAsSpamResponse> markCommentAsSpam({
      required String apiVersion,
      required String commentId,
    });

    /// 📦 List all comments
    Future<ListAllCommentsResponse> listAllComments({
      required String apiVersion,
      int? limit,
      String? sinceId,
      String? createdAtMin,
      String? createdAtMax,
      String? updatedAtMin,
      String? updatedAtMax,
      String? publishedAtMin,
      String? publishedAtMax,
      String? fields,
      String? publishedStatus,
      String? status,
    });

    /// 📦 Get Single Comment Response
    Future<GetSingleCommentResponse> getSingleComment({
      required String apiVersion,
      required String commentId,
      String? fields,
    });

    /// 📦 Count Comments Response
    Future<CountCommentsResponse> countComments({
      required String apiVersion,
      String? createdAtMin,
      String? createdAtMax,
      String? updatedAtMin,
      String? updatedAtMax,
      String? publishedAtMin,
      String? publishedAtMax,
      String? publishedStatus,
      String? status,
    });

    /// 📦 Update Comment Body Response
    Future<UpdateCommentBodyResponse> updateCommentBody({
      required String apiVersion,
      required String commentId,
      required UpdateCommentBodyRequest model,
    });
}