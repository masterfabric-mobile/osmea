// To parse this JSON data, do
//
//     final retrievesAListOfAllResponseModel = retrievesAListOfAllResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_a_list_of_all_response_model.freezed.dart';
part 'retrieves_a_list_of_all_response_model.g.dart';

RetrievesAListOfAllResponseModel retrievesAListOfAllResponseModelFromJson(
        String str) =>
    RetrievesAListOfAllResponseModel.fromJson(json.decode(str));

String retrievesAListOfAllResponseModelToJson(
        RetrievesAListOfAllResponseModel data) =>
    json.encode(data.toJson());

@freezed
class RetrievesAListOfAllResponseModel with _$RetrievesAListOfAllResponseModel {
  const factory RetrievesAListOfAllResponseModel({
    @JsonKey(name: "marketing_events") List<MarketingEvent>? marketingEvents,
  }) = _RetrievesAListOfAllResponseModel;

  factory RetrievesAListOfAllResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesAListOfAllResponseModelFromJson(json);
}

@freezed
class MarketingEvent with _$MarketingEvent {
  const factory MarketingEvent({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "event_type") String? eventType,
    @JsonKey(name: "remote_id") dynamic remoteId,
    @JsonKey(name: "started_at") DateTime? startedAt,
    @JsonKey(name: "ended_at") dynamic endedAt,
    @JsonKey(name: "scheduled_to_end_at") dynamic scheduledToEndAt,
    @JsonKey(name: "budget") dynamic budget,
    @JsonKey(name: "currency") dynamic currency,
    @JsonKey(name: "manage_url") dynamic manageUrl,
    @JsonKey(name: "preview_url") dynamic previewUrl,
    @JsonKey(name: "utm_campaign") String? utmCampaign,
    @JsonKey(name: "utm_source") String? utmSource,
    @JsonKey(name: "utm_medium") String? utmMedium,
    @JsonKey(name: "budget_type") dynamic budgetType,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "marketing_channel") String? marketingChannel,
    @JsonKey(name: "paid") bool? paid,
    @JsonKey(name: "referring_domain") String? referringDomain,
    @JsonKey(name: "breadcrumb_id") dynamic breadcrumbId,
    @JsonKey(name: "marketing_activity_id") int? marketingActivityId,
    @JsonKey(name: "admin_graphql_api_id") String? adminGraphqlApiId,
    @JsonKey(name: "marketed_resources") List<dynamic>? marketedResources,
  }) = _MarketingEvent;

  factory MarketingEvent.fromJson(Map<String, dynamic> json) =>
      _$MarketingEventFromJson(json);
}
