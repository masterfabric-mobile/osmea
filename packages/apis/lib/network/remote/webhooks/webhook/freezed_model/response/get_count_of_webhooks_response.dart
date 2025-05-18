import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_count_of_webhooks_response.freezed.dart';
part 'get_count_of_webhooks_response.g.dart';

GetCountOfWebhooksResponse getCountOfWebhooksResponseFromJson(String str) =>
    GetCountOfWebhooksResponse.fromJson(json.decode(str));

String getCountOfWebhooksResponseToJson(GetCountOfWebhooksResponse data) =>
    json.encode(data.toJson());

@freezed
class GetCountOfWebhooksResponse with _$GetCountOfWebhooksResponse {
  const factory GetCountOfWebhooksResponse({
    @JsonKey(name: "count") required int count,
  }) = _GetCountOfWebhooksResponse;

  factory GetCountOfWebhooksResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCountOfWebhooksResponseFromJson(json);
}