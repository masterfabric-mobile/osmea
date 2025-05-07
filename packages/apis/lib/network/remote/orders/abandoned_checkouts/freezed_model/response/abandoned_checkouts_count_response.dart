import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'abandoned_checkouts_count_response.freezed.dart';
part 'abandoned_checkouts_count_response.g.dart';

AbandonedCheckoutsCountResponse abandonedCheckoutsCountResponseFromJson(
        String str) =>
    AbandonedCheckoutsCountResponse.fromJson(json.decode(str));

String abandonedCheckoutsCountResponseToJson(
        AbandonedCheckoutsCountResponse data) =>
    json.encode(data.toJson());

@freezed
class AbandonedCheckoutsCountResponse with _$AbandonedCheckoutsCountResponse {
  const factory AbandonedCheckoutsCountResponse({
    @JsonKey(name: "count") int? count,
  }) = _AbandonedCheckoutsCountResponse;

  factory AbandonedCheckoutsCountResponse.fromJson(Map<String, dynamic> json) =>
      _$AbandonedCheckoutsCountResponseFromJson(json);
}
