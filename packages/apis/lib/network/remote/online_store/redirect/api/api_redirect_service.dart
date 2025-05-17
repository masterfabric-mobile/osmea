import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/request/create_redirect_full_url_request.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/request/create_redirect_request.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/request/update_redirect_path_and_target_request.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/request/update_redirect_path_uri_request.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/count_all_redirects_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/create_redirect_full_url_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/create_redirect_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/get_single_redirect_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/list_all_redirects_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/update_redirect_path_and_target_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/update_redirect_path_uri_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_redirect_service.g.dart';

@RestApi()
@Injectable(as: RedirectService)
/// 🌐 RedirectService
abstract class RedirectServiceClient implements RedirectService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory RedirectServiceClient(Dio dio) => _RedirectServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔄 List all redirects
  @GET('/api/{api_version}/redirects.json')
  Future<ListAllRedirectsResponse> listAllRedirects({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('path') String? path,
    @Query('target') String? target,
    @Query('fields') String? fields,
  });

  /// 🔄 Get Single Redirect
  @GET('/api/{api_version}/redirects/{redirect_id}.json')
  Future<GetSingleRedirectResponse> getSingleRedirect({
    @Path('api_version') required String apiVersion,
    @Path('redirect_id') required String redirectId,
    @Query('fields') String? fields,
  });

  /// 🔄 Count All Redirects
  @GET('/api/{api_version}/redirects/count.json')
  Future<CountAllRedirectsResponse> countAllRedirects({
    @Path('api_version') required String apiVersion,
    @Query('path') String? path,
    @Query('target') String? target,
  });

  /// 🆕 Create Redirect Full Url
  @POST('/api/{api_version}/redirects.json')
  Future<CreateRedirectFullUrlResponse> createRedirectFullUrl({
    @Path('api_version') required String apiVersion,
    @Body() required CreateRedirectFullUrlRequest body,
  });

  /// 🆕 Create Redirect
  @POST('/api/{api_version}/redirects.json')
  Future<CreateRedirectResponse> createRedirect({
    @Path('api_version') required String apiVersion,
    @Body() required CreateRedirectRequest body,
  });

  /// 🔄 Update Redirect Path Uri
  @PUT('/api/{api_version}/redirects/{redirect_id}.json')
  Future<UpdateRedirectPathUriResponse> updateRedirectPathUri({
    @Path('api_version') required String apiVersion,
    @Path('redirect_id') required String redirectId,
    @Body() required UpdateRedirectPathUriRequest body,
  });

  /// 🔄 Update Redirect Path And Target
  @PUT('/api/{api_version}/redirects/{redirect_id}.json')
  Future<UpdateRedirectPathAndTargetResponse> updateRedirectPathAndTarget({
    @Path('api_version') required String apiVersion,
    @Path('redirect_id') required String redirectId,
    @Body() required UpdateRedirectPathAndTargetRequest body,
  });

  /// 🗑️ Delete Redirect
  @DELETE('/api/{api_version}/redirects/{redirect_id}.json')
  Future<void> deleteRedirect({
    @Path('api_version') required String apiVersion,
    @Path('redirect_id') required String redirectId,
  });
} 