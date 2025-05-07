import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/orders/abandoned_checkouts/abstract/abandoned_checkouts.dart';
import 'package:apis/network/remote/orders/abandoned_checkouts/freezed_model/response/abandoned_checkouts_count_response.dart';
import 'package:apis/network/remote/orders/abandoned_checkouts/freezed_model/response/abandoned_checkouts_list_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_abandoned_checkouts_service.g.dart';

@RestApi()
@Injectable(as: AbandonedCheckoutsService)
abstract class AbandonedCheckoutsServiceClient
    implements AbandonedCheckoutsService {
  @factoryMethod
  factory AbandonedCheckoutsServiceClient(Dio dio) =>
      _AbandonedCheckoutsServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @GET('/api/{api_version}/checkouts/count.json')
  Future<AbandonedCheckoutsCountResponse> getAbandonedCheckoutsCount({
    @Path('api_version') required String apiVersion,
    @Query('since_id') String? sinceId,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
    @Query('updated_at_min') String? updatedAtMin,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('status') String? status,
  });

  @override
  @GET('/api/{api_version}/checkouts.json')
  Future<AbandonedCheckoutsListResponse> getAbandonedCheckoutsList({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
    @Query('updated_at_min') String? updatedAtMin,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('status') String? status,
  });
}
