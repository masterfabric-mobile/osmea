import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/get_single_redirect_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/list_all_redirects_response.dart';
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
}