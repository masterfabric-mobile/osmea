import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_with_metafield_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/create_empty_blog_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/create_empty_blog_with_metafield_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_blog_service.g.dart';

@RestApi()
@Injectable(as: BlogService)
/// 🌐 BlogService
abstract class BlogServiceClient implements BlogService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory BlogServiceClient(Dio dio) => _BlogServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📦 Create an empty blog in the API.
  @POST('/api/{api_version}/blogs.json')
  Future<CreateEmptyBlogResponse> createEmptyBlog({
    @Path('api_version') required String apiVersion,
    @Body() required CreateEmptyBlogRequest model,
  });

  /// 📦 Create a new empty blog with a metafield 
  @POST('/api/{api_version}/blogs.json')
  Future<CreateEmptyBlogWithMetafieldResponse> createEmptyBlogWithMetafield({
    @Path('api_version') required String apiVersion,
    @Body() required CreateEmptyBlogWithMetafieldRequest model,
  });
}