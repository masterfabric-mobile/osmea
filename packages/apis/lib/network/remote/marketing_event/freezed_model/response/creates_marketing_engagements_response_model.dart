// To parse this JSON data, do
//
//     final createsMarketingEngagementsResponseModel = createsMarketingEngagementsResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_marketing_engagements_response_model.freezed.dart';
part 'creates_marketing_engagements_response_model.g.dart';

CreatesMarketingEngagementsResponseModel
    createsMarketingEngagementsResponseModelFromJson(String str) =>
        CreatesMarketingEngagementsResponseModel.fromJson(json.decode(str));

String createsMarketingEngagementsResponseModelToJson(
        CreatesMarketingEngagementsResponseModel data) =>
    json.encode(data.toJson());

@freezed
class CreatesMarketingEngagementsResponseModel
    with _$CreatesMarketingEngagementsResponseModel {
  const factory CreatesMarketingEngagementsResponseModel({
    @JsonKey(name: "engagements") List<Engagement>? engagements,
  }) = _CreatesMarketingEngagementsResponseModel;

  factory CreatesMarketingEngagementsResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$CreatesMarketingEngagementsResponseModelFromJson(json);
}

@freezed
class Engagement with _$Engagement {
  const factory Engagement({
    @JsonKey(name: "occurred_on") DateTime? occurredOn,
    @JsonKey(name: "fetched_at") dynamic fetchedAt,
    @JsonKey(name: "views_count") int? viewsCount,
    @JsonKey(name: "impressions_count") dynamic impressionsCount,
    @JsonKey(name: "clicks_count") int? clicksCount,
    @JsonKey(name: "favorites_count") int? favoritesCount,
    @JsonKey(name: "comments_count") dynamic commentsCount,
    @JsonKey(name: "shares_count") dynamic sharesCount,
    @JsonKey(name: "ad_spend") String? adSpend,
    @JsonKey(name: "currency_code") dynamic currencyCode,
    @JsonKey(name: "is_cumulative") bool? isCumulative,
    @JsonKey(name: "unsubscribes_count") dynamic unsubscribesCount,
    @JsonKey(name: "complaints_count") dynamic complaintsCount,
    @JsonKey(name: "fails_count") dynamic failsCount,
    @JsonKey(name: "sends_count") dynamic sendsCount,
    @JsonKey(name: "unique_views_count") dynamic uniqueViewsCount,
    @JsonKey(name: "unique_clicks_count") dynamic uniqueClicksCount,
    @JsonKey(name: "utc_offset") dynamic utcOffset,
  }) = _Engagement;

  factory Engagement.fromJson(Map<String, dynamic> json) =>
      _$EngagementFromJson(json);
}
