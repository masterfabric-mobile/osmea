import 'package:apis/network/remote/webhooks/webhook/freezed_model/webhook.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_a_webhook_response.freezed.dart';
part 'get_a_webhook_response.g.dart';

GetAWebhookResponse getAWebhookResponseFromJson(String str) =>
    GetAWebhookResponse.fromJson(json.decode(str));

String getAWebhookResponseToJson(GetAWebhookResponse data) =>
    json.encode(data.toJson());

@freezed
class GetAWebhookResponse with _$GetAWebhookResponse {
  const factory GetAWebhookResponse({
    @JsonKey(name: "webhook") Webhook? webhook,
  }) = _GetAWebhookResponse;

  factory GetAWebhookResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAWebhookResponseFromJson(json);
}