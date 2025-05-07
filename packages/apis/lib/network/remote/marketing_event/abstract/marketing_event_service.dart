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

/// 🔑 Abstract contract for Marketing Event Events
/// Implement this to fetch access scopes from Shopify API! 🌐
abstract class MarketingEventEvents {
  /// 🚀 Fetches the Marketing Event Events from the API.

  Future<CreatesMarketingEngagementsResponseModel> createsMarketingEngagements(
      {required String apiVersion,
      required String marketingEventId,
      required CreatesMarketingEngagementsRequestModel model});

  Future<CreatesMarketingEventResponseModel> createsMarketingEvent(
      {required String apiVersion,
      required CreatesMarketingEventRequestModel model});

  Future<RetrievesACountOfAllResponseModel> retrievesACountOfAll({
    required String apiVersion,
  });

  Future<RetrievesAListOfAllResponseModel> retrievesAListOfAll({
    required String apiVersion,
  });

  Future<RetrievesASingleResponseModel> retrievesASingle({
    required String apiVersion,
    required String marketingEventId,
  });

  Future<UpdatesAMarketingEventResponseModel> updatesAMarketingEvent(
      {required String apiVersion,
      required String marketingEventId,
      required UpdatesAMarketingEventRequestModel model});

  Future<DeletesAMarketingEventResponseModel> deletesAMarketingEvent({
    required String apiVersion,
    required String marketingEventId,
  });
}
