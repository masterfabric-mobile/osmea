// To parse this JSON data, do
//
//     final createsMarketingEventRequestModel = createsMarketingEventRequestModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_marketing_event_request_model.freezed.dart';
part 'creates_marketing_event_request_model.g.dart';

CreatesMarketingEventRequestModel createsMarketingEventRequestModelFromJson(
        String str) =>
    CreatesMarketingEventRequestModel.fromJson(json.decode(str));

String createsMarketingEventRequestModelToJson(
        CreatesMarketingEventRequestModel data) =>
    json.encode(data.toJson());

@freezed
class CreatesMarketingEventRequestModel
    with _$CreatesMarketingEventRequestModel {
  const factory CreatesMarketingEventRequestModel({
    @JsonKey(name: "marketing_event") MarketingEvent? marketingEvent,
  }) = _CreatesMarketingEventRequestModel;

  factory CreatesMarketingEventRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$CreatesMarketingEventRequestModelFromJson(json);
}

@freezed
class MarketingEvent with _$MarketingEvent {
  const factory MarketingEvent({
    @JsonKey(name: "started_at") DateTime? startedAt,
    @JsonKey(name: "utm_campaign") String? utmCampaign,
    @JsonKey(name: "utm_source") String? utmSource,
    @JsonKey(name: "utm_medium") String? utmMedium,
    @JsonKey(name: "event_type") String? eventType,
    @JsonKey(name: "referring_domain") String? referringDomain,
    @JsonKey(name: "marketing_channel") String? marketingChannel,
    @JsonKey(name: "paid") bool? paid,
  }) = _MarketingEvent;

  factory MarketingEvent.fromJson(Map<String, dynamic> json) =>
      _$MarketingEventFromJson(json);
}
