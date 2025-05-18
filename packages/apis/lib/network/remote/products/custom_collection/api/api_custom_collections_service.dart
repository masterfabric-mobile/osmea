import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/products/custom_collection/abstract/custom_collections_service.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/response/list_all_custom_collections_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_custom_collections_service.g.dart';

@RestApi()
@Injectable(as: CustomCollectionsService)

/// 🌐 CustomCollectionsService
abstract class CustomCollectionsServiceClient
    implements CustomCollectionsService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CustomCollectionsServiceClient(Dio dio) =>
      _CustomCollectionsServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔄 List all custom collections
  @GET('/api/{api_version}/custom_collections.json')
  Future<ListAllCustomCollectionsResponse> listAllCustomCollections({
    @Path('api_version') required String apiVersion,
    @Query('fields') String? fields,
    @Query('handle') String? handle,
    @Query('ids') String? ids,
    @Query('limit') int? limit,
    @Query('product_id') String? product_id,
    @Query('published_at_max') String? publishedAtMax,
    @Query('published_at_min') String? publishedAtMin,
    @Query('published_status') String? published_status,
    @Query('since_id') String? since_id,
    @Query('title') String? title,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('updated_at_min') String? updatedAtMin,
    
  });
}
