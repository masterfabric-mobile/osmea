import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_webhook_request.freezed.dart';
part 'create_webhook_request.g.dart';

CreateWebhookRequest createWebhookRequestFromJson(String str) =>
    CreateWebhookRequest.fromJson(json.decode(str));

String createWebhookRequestToJson(CreateWebhookRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateWebhookRequest with _$CreateWebhookRequest {
  const factory CreateWebhookRequest({
    @JsonKey(name: "webhook") required WebhookData webhook,
  }) = _CreateWebhookRequest;

  factory CreateWebhookRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWebhookRequestFromJson(json);
}

@freezed
class WebhookData with _$WebhookData {
  const factory WebhookData({
    @JsonKey(name: "topic") required String topic,
    @JsonKey(name: "address") required String address,
    @JsonKey(name: "format") required String format,
  }) = _WebhookData;

  factory WebhookData.fromJson(Map<String, dynamic> json) =>
      _$WebhookDataFromJson(json);
}