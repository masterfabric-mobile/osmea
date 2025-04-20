import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/access/storefront_access_token/abstract/storefront_access_token.dart';
import 'package:apis/network/remote/access/storefront_access_token/freezed_model/request/create_new_storefront_access_token_request.dart';
import 'package:apis/network/remote/access/storefront_access_token/freezed_model/response/create_new_storefront_access_token_response.dart';
import 'package:apis/network/remote/access/storefront_access_token/freezed_model/response/storefront_access_token_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_storefront_access_token.g.dart';

/// 🌐 StoreFrontAccessTokenServiceClient
/// Retrofit client for Access Scope API.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏬🔑
@RestApi()
@Injectable(as: StorefrontAccessTokenService)
abstract class StorefrontAccessTokenClient
    implements StorefrontAccessTokenService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory StorefrontAccessTokenClient(Dio dio) => _StorefrontAccessTokenClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔓 Get storefront access tokens
  @override
  @GET('/api/{api_version}/storefront_access_tokens.json')
  Future<StorefrontAccessTokenResponse> storefrontAccessToken({
    @Path('api_version') required String apiVersion,
  });

  @override
  @POST('/api/{api_version}/storefront_access_tokens.json')
  Future<CreateNewStorefrontAccessTokenResponse> createNewStorefrontAccessToken({
    @Path('api_version') required String apiVersion,
    @Body() required CreateNewStorefrontAccessTokenRequest model,
  });

  @override
  @DELETE('/api/{api_version}/storefront_access_tokens/{storefront_access_token_id}.json')
  Future<CreateNewStorefrontAccessTokenResponse> deleteStorefrontAccessToken({
    @Path('api_version') required String apiVersion,
    @Path('storefront_access_token_id') required String storefrontAccessTokenId,
  });

  
}
