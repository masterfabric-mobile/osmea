// To parse this JSON data, do
//
//     final updatesAMarketingEventRequestModel = updatesAMarketingEventRequestModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'updates_a_marketing_event_request_model.freezed.dart';
part 'updates_a_marketing_event_request_model.g.dart';

UpdatesAMarketingEventRequestModel updatesAMarketingEventRequestModelFromJson(
        String str) =>
    UpdatesAMarketingEventRequestModel.fromJson(json.decode(str));

String updatesAMarketingEventRequestModelToJson(
        UpdatesAMarketingEventRequestModel data) =>
    json.encode(data.toJson());

@freezed
class UpdatesAMarketingEventRequestModel
    with _$UpdatesAMarketingEventRequestModel {
  const factory UpdatesAMarketingEventRequestModel({
    @JsonKey(name: "marketing_event") MarketingEvent? marketingEvent,
  }) = _UpdatesAMarketingEventRequestModel;

  factory UpdatesAMarketingEventRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$UpdatesAMarketingEventRequestModelFromJson(json);
}

@freezed
class MarketingEvent with _$MarketingEvent {
  const factory MarketingEvent({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "remote_id") String? remoteId,
    @JsonKey(name: "started_at") String? startedAt,
    @JsonKey(name: "ended_at") String? endedAt,
    @JsonKey(name: "scheduled_to_end_at") String? scheduledToEndAt,
    @JsonKey(name: "budget") String? budget,
    @JsonKey(name: "budget_type") String? budgetType,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "utm_campaign") String? utmCampaign,
    @JsonKey(name: "utm_source") String? utmSource,
    @JsonKey(name: "utm_medium") String? utmMedium,
    @JsonKey(name: "event_type") String? eventType,
    @JsonKey(name: "referring_domain") String? referringDomain,
  }) = _MarketingEvent;

  factory MarketingEvent.fromJson(Map<String, dynamic> json) =>
      _$MarketingEventFromJson(json);
}
