import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_webhook_request.freezed.dart';
part 'update_webhook_request.g.dart';

UpdateWebhookRequest updateWebhookRequestFromJson(String str) =>
    UpdateWebhookRequest.fromJson(json.decode(str));

String updateWebhookRequestToJson(UpdateWebhookRequest data) =>
    json.encode(data.toJson());

@freezed
class UpdateWebhookRequest with _$UpdateWebhookRequest {
  const factory UpdateWebhookRequest({
    @JsonKey(name: "webhook") required UpdateWebhookData webhook,
  }) = _UpdateWebhookRequest;

  factory UpdateWebhookRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWebhookRequestFromJson(json);
}

@freezed
class UpdateWebhookData with _$UpdateWebhookData {
  const factory UpdateWebhookData({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "address") required String address,
  }) = _UpdateWebhookData;

  factory UpdateWebhookData.fromJson(Map<String, dynamic> json) =>
      _$UpdateWebhookDataFromJson(json);
}