import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/metafield/abstract/metafield_service.dart';
import 'package:apis/network/remote/metafield/freezed_model/request/create_metafield_request.dart';
import 'package:apis/network/remote/metafield/freezed_model/response/create_metafield_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_metafield_service.g.dart';

@RestApi()
@Injectable(as: MetafieldService)

/// 🌐 MetafieldService
abstract class MetafieldServiceClient implements MetafieldService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory MetafieldServiceClient(Dio dio) =>
      _MetafieldServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📦 Creates a metafield in the API.
  @POST('/api/{api_version}/{owner_resource}/{owner_id}/metafields.json')
  Future<CreateMetafieldResponse> createMetafield({
    @Path('api_version') required String apiVersion,
    @Path('owner_resource') required String ownerResource,
    @Path('owner_id') required String ownerId,
    @Body() required CreateMetafieldRequest model,
  });
}