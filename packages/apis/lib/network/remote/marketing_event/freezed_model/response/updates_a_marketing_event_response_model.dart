// To parse this JSON data, do
//
//     final updatesAMarketingEventResponseModel = updatesAMarketingEventResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'updates_a_marketing_event_response_model.freezed.dart';
part 'updates_a_marketing_event_response_model.g.dart';

UpdatesAMarketingEventResponseModel updatesAMarketingEventResponseModelFromJson(
        String str) =>
    UpdatesAMarketingEventResponseModel.fromJson(json.decode(str));

String updatesAMarketingEventResponseModelToJson(
        UpdatesAMarketingEventResponseModel data) =>
    json.encode(data.toJson());

@freezed
class UpdatesAMarketingEventResponseModel
    with _$UpdatesAMarketingEventResponseModel {
  const factory UpdatesAMarketingEventResponseModel({
    @JsonKey(name: "marketing_event") MarketingEvent? marketingEvent,
  }) = _UpdatesAMarketingEventResponseModel;

  factory UpdatesAMarketingEventResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$UpdatesAMarketingEventResponseModelFromJson(json);
}

@freezed
class MarketingEvent with _$MarketingEvent {
  const factory MarketingEvent({
    @JsonKey(name: "started_at") DateTime? startedAt,
    @JsonKey(name: "ended_at") DateTime? endedAt,
    @JsonKey(name: "scheduled_to_end_at") DateTime? scheduledToEndAt,
    @JsonKey(name: "remote_id") String? remoteId,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "budget") String? budget,
    @JsonKey(name: "budget_type") String? budgetType,
    @JsonKey(name: "event_type") String? eventType,
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "manage_url") dynamic manageUrl,
    @JsonKey(name: "preview_url") dynamic previewUrl,
    @JsonKey(name: "utm_campaign") String? utmCampaign,
    @JsonKey(name: "utm_source") String? utmSource,
    @JsonKey(name: "utm_medium") String? utmMedium,
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
