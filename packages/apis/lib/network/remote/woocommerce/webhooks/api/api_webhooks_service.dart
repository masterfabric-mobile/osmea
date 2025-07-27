import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/webhooks/abstract/webhooks_service.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/request/create_webhook_request.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/create_webhook_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/delete_webhook_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/list_all_webhooks_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/retrieve_webhook_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/update_webhook_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_webhooks_service.g.dart';

@RestApi()
@Injectable(as: WebhooksService)
abstract class WebhooksServiceClient implements WebhooksService {
  @factoryMethod
  factory WebhooksServiceClient(Dio dio) => _WebhooksServiceClient(
        ApiDioClient.wooDio(),
        baseUrl: WooNetwork.baseUrl,
      );

  @override
  @GET('/wp-json/wc/{apiVersion}/webhooks')
  Future<List<ListAllWebhooksResponse>> listAllWebhooks({
    @Path('apiVersion') required String apiVersion,
    @Query('context') String? context,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
    @Query('search') String? search,
    @Query('exclude') List<int>? exclude,
    @Query('include') List<int>? include,
    @Query('order') String? order,
    @Query('orderby') String? orderby,
    @Query('status') String? status,
  });

  @override
  @POST('/wp-json/wc/{apiVersion}/webhooks')
  Future<CreateWebhookResponse> createWebhook({
    @Path('apiVersion') required String apiVersion,
    @Body() required Map<String, dynamic> webhookData,
  });

  @override
  @GET('/wp-json/wc/{apiVersion}/webhooks/{webhookId}')
  Future<RetrieveWebhookResponse> retrieveWebhook({
    @Path('apiVersion') required String apiVersion,
    @Path('webhookId') required int webhookId,
  });

  @override
  @PUT('/wp-json/wc/{apiVersion}/webhooks/{webhookId}')
  Future<UpdateWebhookResponse> updateWebhook({
    @Path('apiVersion') required String apiVersion,
    @Path('webhookId') required int webhookId,
    @Body() required Map<String, dynamic> webhookData,
  });

  @override
  @DELETE('/wp-json/wc/{apiVersion}/webhooks/{webhookId}')
  Future<DeleteWebhookResponse> deleteWebhook({
    @Path('apiVersion') required String apiVersion,
    @Path('webhookId') required int webhookId,
    @Query('force') bool? force,
  });
}
