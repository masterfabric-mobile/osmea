import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/comment/abstract/comment_service.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/request/create_comment_textile_markup_request.dart';
import 'package:apis/network/remote/online_store/comment/freezed_model/response/create_comment_textile_markup_response.dart';
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
}