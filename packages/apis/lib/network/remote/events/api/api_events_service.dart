import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/events/abstract/events_service.dart';
import 'package:apis/network/remote/events/freezed_model/retrieves_list_of_events_response.dart';
import 'package:apis/network/remote/events/freezed_model/retrieves_single_events_response.dart';
import 'package:apis/network/remote/events/freezed_model/retrieves_count_events_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_events_service.g.dart';

/// 🌐 RetrievesListOfEventsClient
/// Retrofit client for retrieving a list of events.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏪🔐
@RestApi()
@Injectable(as: RetrievesListOfEvents)
abstract class RetrievesListOfEventsClient implements RetrievesListOfEvents {
  /// 🏗️ Factory for dependency injection
  @factoryMethod
  factory RetrievesListOfEventsClient(Dio dio) => _RetrievesListOfEventsClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔐 Get list of events from API
  @override
  @GET('/api/{api_version}/events.json')
  Future<RetrievesListOfEventsResponse> retrievesListOfEvents({
    @Path('api_version') required String apiVersion,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('filter') String? filter,
    @Query('sort_by') String? sortBy,
  });
}

/// 🌐 RetrievesSingleEventClient
/// Retrofit client for retrieving a single event.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏪🔐
@RestApi()
@Injectable(as: RetrievesSingleEvent)
abstract class RetrievesSingleEventClient implements RetrievesSingleEvent {
  /// 🏗️ Factory for dependency injection
  @factoryMethod
  factory RetrievesSingleEventClient(Dio dio) => _RetrievesSingleEventClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔐 Get a single event from API
  @override
  @GET('/api/{api_version}/events/{event_id}.json')
  Future<RetrievesSingleEventsResponse> retrievesSingleEvent({
    @Path('api_version') required String apiVersion,
    @Path('event_id') required int eventId,
  });
}

/// 🌐 RetrievesCountEventsClient
/// Retrofit client for retrieving the count of events.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏪🔐
@RestApi()
@Injectable(as: RetrievesCountEvents)
abstract class RetrievesCountEventsClient implements RetrievesCountEvents {
  /// 🏗️ Factory for dependency injection
  @factoryMethod
  factory RetrievesCountEventsClient(Dio dio) => _RetrievesCountEventsClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔐 Get count of events from API
  @override
  @GET('/api/{api_version}/events/count.json')
  Future<RetrievesCountEventsResponse> retrievesCountEvents({
    @Path('api_version') required String apiVersion,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
  });
}
