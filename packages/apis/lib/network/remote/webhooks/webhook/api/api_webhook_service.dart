import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/webhooks/webhook/abstract/webhook_service.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/response/get_all_webhooks_response.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/response/get_a_webhook_response.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/response/get_count_of_webhooks_response.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/request/create_webhook_request.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/request/update_webhook_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_webhook_service.g.dart';

/// 🌐 GetWebhooksServiceClient
/// Retrofit client for retrieving a list of webhooks.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏬🔑
@RestApi()
@Injectable(as: GetWebhooksService)
abstract class GetWebhooksServiceClient implements GetWebhooksService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetWebhooksServiceClient(Dio dio) => _GetWebhooksServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📋 Get webhooks from API
  @override
  @GET('/api/{api_version}/webhooks.json')
  Future<GetAllWebhooksResponse> getWebhooks({
    @Path('api_version') required String apiVersion,
    @Query('fields') String? fields,
    @Query('address') String? address,
    @Query('topic') String? topic,
    @Query('since_id') String? since_id,
    @Query('created_at_min') String? created_at_min,
    @Query('created_at_max') String? created_at_max,
    @Query('updated_at_min') String? updated_at_min,
    @Query('updated_at_max') String? updated_at_max,
    @Query('limit') int? limit, // Add this parameter
  });
}

/// 🌐 GetWebhookServiceClient
/// Retrofit client for retrieving a single webhook.
@RestApi()
@Injectable(as: GetWebhookService)
abstract class GetWebhookServiceClient implements GetWebhookService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetWebhookServiceClient(Dio dio) => _GetWebhookServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔍 Get a single webhook by ID
  @override
  @GET('/api/{api_version}/webhooks/{id}.json')
  Future<GetAWebhookResponse> getWebhook({
    @Path('api_version') required String apiVersion,
    @Path('id') required int id,
    @Query('fields') String? fields,
  });
}

/// 🌐 GetWebhooksCountServiceClient
/// Retrofit client for retrieving the count of webhooks.
@RestApi()
@Injectable(as: GetWebhooksCountService)
abstract class GetWebhooksCountServiceClient implements GetWebhooksCountService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetWebhooksCountServiceClient(Dio dio) => _GetWebhooksCountServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔢 Get count of webhooks
  @override
  @GET('/api/{api_version}/webhooks/count.json')
  Future<GetCountOfWebhooksResponse> getWebhooksCount({
    @Path('api_version') required String apiVersion,
    @Query('address') String? address,
    @Query('topic') String? topic,
  });
}

/// 🌐 CreateWebhookServiceClient
/// Retrofit client for creating a webhook
@RestApi()
@Injectable(as: CreateWebhookService)
abstract class CreateWebhookServiceClient implements CreateWebhookService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CreateWebhookServiceClient(Dio dio) => _CreateWebhookServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📝 Create a new webhook
  @override
  @POST('/api/{api_version}/webhooks.json')
  Future<GetAWebhookResponse> createWebhook({
    @Path('api_version') required String apiVersion,
    @Body() required CreateWebhookRequest request,
  });
}

/// 🌐 UpdateWebhookServiceClient
/// Retrofit client for updating a webhook
@RestApi()
@Injectable(as: UpdateWebhookService)
abstract class UpdateWebhookServiceClient implements UpdateWebhookService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory UpdateWebhookServiceClient(Dio dio) => _UpdateWebhookServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// ✏️ Update an existing webhook
  @override
  @PUT('/api/{api_version}/webhooks/{id}.json')
  Future<GetAWebhookResponse> updateWebhook({
    @Path('api_version') required String apiVersion,
    @Path('id') required int id,
    @Body() required UpdateWebhookRequest request,
  });
}

/// 🌐 DeleteWebhookServiceClient
/// Retrofit client for deleting a webhook
@RestApi()
@Injectable(as: DeleteWebhookService)
abstract class DeleteWebhookServiceClient implements DeleteWebhookService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory DeleteWebhookServiceClient(Dio dio) => _DeleteWebhookServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🗑️ Delete an existing webhook
  @override
  @DELETE('/api/{api_version}/webhooks/{id}.json')
  Future<void> deleteWebhook({
    @Path('api_version') required String apiVersion,
    @Path('id') required int id,
  });
}