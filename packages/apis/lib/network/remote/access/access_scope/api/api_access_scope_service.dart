import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/access/access_scope/abstract/access_scope_service.dart';
import 'package:apis/network/remote/access/access_scope/freezed_model/access_scope_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_access_scope_service.g.dart';

/// 🌐 AccessScopeServiceClient
/// Retrofit client for Access Scope API.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏬🔑
@RestApi()
@Injectable(as: AccessScopeService)
abstract class AccessScopeServiceClient implements AccessScopeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory AccessScopeServiceClient(Dio dio) => _AccessScopeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔓 Get access scopes from API
  @override
  @GET('/oauth/access_scopes.json')
  Future<AccessScopeResponse> accessScope();
}
