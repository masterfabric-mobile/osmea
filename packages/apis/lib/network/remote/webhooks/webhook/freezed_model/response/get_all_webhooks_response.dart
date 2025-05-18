import 'package:apis/network/remote/webhooks/webhook/freezed_model/webhook.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_all_webhooks_response.freezed.dart';
part 'get_all_webhooks_response.g.dart';

GetAllWebhooksResponse getAllWebhooksResponseFromJson(String str) =>
    GetAllWebhooksResponse.fromJson(json.decode(str));

String getAllWebhooksResponseToJson(GetAllWebhooksResponse data) =>
    json.encode(data.toJson());

@freezed
class GetAllWebhooksResponse with _$GetAllWebhooksResponse {
  const factory GetAllWebhooksResponse({
    @JsonKey(name: "webhooks") List<Webhook>? webhooks,
  }) = _GetAllWebhooksResponse;

  factory GetAllWebhooksResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllWebhooksResponseFromJson(json);
}