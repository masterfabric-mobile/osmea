import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/blog/abstract/blog_service.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_with_metafield_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/metafield_existing_blog_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/update_blog_title_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/update_existing_blog_title_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/count_all_blogs_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/create_empty_blog_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/create_empty_blog_with_metafield_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/get_all_blogs_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/get_single_blog_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/metafield_existing_blog_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/update_blog_title_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/update_existing_blog_title_response.dart';
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

  /// 📦 Get All Blogs
  @GET('/api/{api_version}/blogs.json')
  Future<GetAllBlogsResponse> getAllBlogs({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('handle') String? handle,
    @Query('fields') String? fields,
  });

  /// 📦 Get Single Blog
  @GET('/api/{api_version}/blogs/{blog_id}.json')
  Future<GetSingleBlogResponse> getSingleBlog({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required String blogId,
    @Query('fields') String? fields,
  });

  /// 📦 Count All Blogs
  @GET('/api/{api_version}/blogs/count.json')
  Future<CountAllBlogsResponse> countAllBlogs({
    @Path('api_version') required String apiVersion,
  });

    /// 📦 Add a metafield to an existing blog 
  @PUT('/api/{api_version}/blogs/{blog_id}.json')
  Future<MetafieldExistingBlogResponse> addMetafieldToExistingBlog({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required String blogId,
    @Body() required MetafieldExistingBlogRequest model,
  });

  /// 📦 Update an existing blog title and handle and also activate comments
  @PUT('/api/{api_version}/blogs/{blog_id}.json')
  Future<UpdateExistingBlogTitleResponse> updateExistingBlogTitle({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required String blogId,
    @Body() required UpdateExistingBlogTitleRequest model,
  });

  /// 📦 Update Blog Title
  @PUT('/api/{api_version}/blogs/{blog_id}.json')
  Future<UpdateBlogTitleResponse> updateBlogTitle({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required String blogId,
    @Body() required UpdateBlogTitleRequest model,
  });

  /// 📦 Remove Blog
  @DELETE('/api/{api_version}/blogs/{blog_id}.json')
  Future<void> removeBlog({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required String blogId,
  });
}
