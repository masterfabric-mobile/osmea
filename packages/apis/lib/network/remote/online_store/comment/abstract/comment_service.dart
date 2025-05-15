import 'package:apis/network/remote/online_store/comment/freezed_model/request/create_comment_textile_markup_request.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/create_comment_textile_markup_response.dart';

abstract class CommentService {
    /// 📦 Create a comment with textile markup
    Future<CreateCommentTextileMarkupResponse> createCommentTextileMarkup({
      required String apiVersion,
      required CreateCommentTextileMarkupRequest model,
    });
}