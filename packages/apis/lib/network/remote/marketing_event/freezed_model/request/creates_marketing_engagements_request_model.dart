// To parse this JSON data, do
//
//     final createsMarketingEngagementsRequestModel = createsMarketingEngagementsRequestModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_marketing_engagements_request_model.freezed.dart';
part 'creates_marketing_engagements_request_model.g.dart';

CreatesMarketingEngagementsRequestModel
    createsMarketingEngagementsRequestModelFromJson(String str) =>
        CreatesMarketingEngagementsRequestModel.fromJson(json.decode(str));

String createsMarketingEngagementsRequestModelToJson(
        CreatesMarketingEngagementsRequestModel data) =>
    json.encode(data.toJson());

@freezed
class CreatesMarketingEngagementsRequestModel
    with _$CreatesMarketingEngagementsRequestModel {
  const factory CreatesMarketingEngagementsRequestModel({
    @JsonKey(name: "engagements") List<Engagement>? engagements,
  }) = _CreatesMarketingEngagementsRequestModel;

  factory CreatesMarketingEngagementsRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$CreatesMarketingEngagementsRequestModelFromJson(json);
}

@freezed
class Engagement with _$Engagement {
  const factory Engagement({
    @JsonKey(name: "occurred_on") DateTime? occurredOn,
    @JsonKey(name: "views_count") int? viewsCount,
    @JsonKey(name: "clicks_count") int? clicksCount,
    @JsonKey(name: "favorites_count") int? favoritesCount,
    @JsonKey(name: "ad_spend") int? adSpend,
    @JsonKey(name: "is_cumulative") bool? isCumulative,
  }) = _Engagement;

  factory Engagement.fromJson(Map<String, dynamic> json) =>
      _$EngagementFromJson(json);
}
