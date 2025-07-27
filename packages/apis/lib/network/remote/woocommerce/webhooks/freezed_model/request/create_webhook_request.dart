// To parse this JSON data, do
//
//     final createWebhookRequest = createWebhookRequestFromJson(jsonString);

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
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "topic") String? topic,
    @JsonKey(name: "resource") String? resource,
    @JsonKey(name: "event") String? event,
    @JsonKey(name: "hooks") List<String>? hooks,
    @JsonKey(name: "delivery_url") String? deliveryUrl,
  }) = _CreateWebhookRequest;

  factory CreateWebhookRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWebhookRequestFromJson(json);
}
