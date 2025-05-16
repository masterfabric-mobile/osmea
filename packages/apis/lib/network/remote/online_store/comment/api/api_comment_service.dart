import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/request/create_comment_textile_markup_request.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/approve_and_publish_comment_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/create_comment_textile_markup_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/get_single_comment_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/list_all_comments_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/mark_comment_as_spam_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/mark_comment_not_spam_restore_response.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/restore_removed_comment_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_comment_service.g.dart';

@RestApi()
@Injectable(as: CommentService)
/// 🌐 CommentService
abstract class CommentServiceClient implements CommentService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CommentServiceClient(Dio dio) => _CommentServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📦 Create a comment with textile markup
  @POST('/api/{api_version}/comments.json')
  Future<CreateCommentTextileMarkupResponse> createCommentTextileMarkup({
    @Path('api_version') required String apiVersion,
    @Body() required CreateCommentTextileMarkupRequest model,
  });

  /// 📦 Approve a comment and publish it to the blog 
  @POST('/api/{api_version}/comments/{comment_id}/approve.json')
  Future<ApproveAndPublishCommentResponse> approveAndPublishComment({
    @Path('api_version') required String apiVersion,
    @Path('comment_id') required String commentId,
  });

  /// 📦 Mark a comment as not spam, restoring it to an unapproved or published
  @POST('/api/{api_version}/comments/{comment_id}/not_spam.json')
  Future<MarkCommentNotSpamRestoreResponse> MarkCommentNotSpamRestore({
    @Path('api_version') required String apiVersion,
    @Path('comment_id') required String commentId,
  });

  /// 📦 Remove a comment 
  @POST('/api/{api_version}/comments/{comment_id}/remove.json')
  Future<void> removeComment({
    @Path('api_version') required String apiVersion,
    @Path('comment_id') required String commentId,
  });

  /// 📦 Restore Remove Comment Response
  @POST('/api/{api_version}/comments/{comment_id}/restore.json')
  Future<RestoreRemovedCommentResponse> restoreRemoveComment({
    @Path('api_version') required String apiVersion,
    @Path('comment_id') required String commentId,
  });

  /// 📦 Mark a comment as spam
  @POST('/api/{api_version}/comments/{comment_id}/spam.json')
  Future<MarkCommentAsSpamResponse> markCommentAsSpam({
    @Path('api_version') required String apiVersion,
    @Path('comment_id') required String commentId,
  });

  /// 📦 List All Comments
  @GET('/api/{api_version}/comments.json')
  Future<ListAllCommentsResponse> listAllComments({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
    @Query('updated_at_min') String? updatedAtMin,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('published_at_min') String? publishedAtMin,
    @Query('published_at_max') String? publishedAtMax,
    @Query('fields') String? fields,
    @Query('published_status') String? publishedStatus,
    @Query('status') String? status,
  });

  /// 📦 Get Single Comment Response
  @GET('/api/{api_version}/comments/{comment_id}.json')
  Future<GetSingleCommentResponse> getSingleComment({
    @Path('api_version') required String apiVersion,
    @Path('comment_id') required String commentId,
    @Query('fields') String? fields,
  });
}