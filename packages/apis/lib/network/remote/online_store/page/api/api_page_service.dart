import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/count_all_blogs_response.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_page_with_metafield_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/create_page_with_metafield_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/get_single_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/list_all_pages_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_page_service.g.dart';

@RestApi()
@Injectable(as: PageService)
/// 🌐 PageService
abstract class PageServiceClient implements PageService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory PageServiceClient(Dio dio) => _PageServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📦 List all pages
  @GET('/api/{api_version}/pages.json')
  Future<ListAllPagesResponse> listAllPages({
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
    @Query('title') String? title,
    @Query('handle') String? handle,
  });

  /// 📄 Get single page
  @GET('/api/{api_version}/pages/{page_id}.json')
  Future<GetSinglePageResponse> getSinglePage({
    @Path('api_version') required String apiVersion,
    @Path('page_id') required String pageId,
    @Query('fields') String? fields,
  });

  /// 📄 Count All Pages
  @GET('/api/{api_version}/pages/count.json')
  Future<CountAllBlogsResponse> countAllPages({
    @Path('api_version') required String apiVersion,
    @Query('title') String? title,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
    @Query('updated_at_min') String? updatedAtMin,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('published_at_min') String? publishedAtMin,
    @Query('published_at_max') String? publishedAtMax,
    @Query('published_status') String? publishedStatus,
  });

  /// 📦 Create Page With Metafield
  @POST('/api/{api_version}/pages.json')
  Future<CreatePageWithMetafieldResponse> createPageWithMetafield({
    @Path('api_version') required String apiVersion,
    @Body() required CreatePageWithMetafieldRequest model,
  });
}