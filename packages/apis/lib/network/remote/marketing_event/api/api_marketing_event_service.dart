import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/marketing_event/abstract/marketing_event_service.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/request/creates_marketing_engagements_request_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/request/creates_marketing_event_request_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/request/updates_a_marketing_event_request_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/creates_marketing_engagements_response_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/creates_marketing_event_response_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/deletes_a_marketing_event_response_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/retrieves_a_count_of_all_response_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/retrieves_a_list_of_all_response_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/retrieves_a_single_response_model.dart';
import 'package:apis/network/remote/marketing_event/freezed_model/response/updates_a_marketing_event_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_marketing_event_service.g.dart';

/// 🌐 MarketingEventEventsApi
/// Retrofit client for retrieving a list of events.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏪🔐
@RestApi()
@Injectable(as: MarketingEventEvents)
abstract class MarketingEventEventsApi implements MarketingEventEvents {
  /// 🏗️ Factory for dependency injection
  @factoryMethod
  factory MarketingEventEventsApi(Dio dio) => _MarketingEventEventsApi(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔐 Get list of events from API
  @override
  @POST(
      '/api/{api_version}/marketing_events/{marketing_event_id}/engagements.json')
  Future<CreatesMarketingEngagementsResponseModel> createsMarketingEngagements(
      {@Path('api_version') required String apiVersion,
      @Path('marketing_event_id') required String marketingEventId,
      @Body() required CreatesMarketingEngagementsRequestModel model});

  @override
  @POST('/api/{api_version}/marketing_events.json')
  Future<CreatesMarketingEventResponseModel> createsMarketingEvent(
      {@Path('api_version') required String apiVersion,
      @Body() required CreatesMarketingEventRequestModel model});

  @override
  @GET('/api/{api_version}/marketing_events/count.json')
  Future<RetrievesACountOfAllResponseModel> retrievesACountOfAll({
    @Path('api_version') required String apiVersion,
  });

  @override
  @GET('/api/{api_version}/marketing_events.json')
  Future<RetrievesAListOfAllResponseModel> retrievesAListOfAll({
    @Path('api_version') required String apiVersion,
    @Query('limit') String? limit,
    @Query('offset') String? offset,
  });

  @override
  @GET('/api/{api_version}/marketing_events/{marketing_event_id}.json')
  Future<RetrievesASingleResponseModel> retrievesASingle({
    @Path('api_version') required String apiVersion,
    @Path('marketing_event_id') required String marketingEventId,
  });

  @override
  @PUT('/api/{api_version}/marketing_events/{marketing_event_id}.json')
  Future<UpdatesAMarketingEventResponseModel> updatesAMarketingEvent(
      {@Path('api_version') required String apiVersion,
      @Path('marketing_event_id') required String marketingEventId,
      @Body() required UpdatesAMarketingEventRequestModel model});

  @override
  @DELETE('/api/{api_version}/marketing_events/{marketing_event_id}.json')
  Future<DeletesAMarketingEventResponseModel> deletesAMarketingEvent({
    @Path('api_version') required String apiVersion,
    @Path('marketing_event_id') required String marketingEventId,
  });
}
