import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'webhook.freezed.dart';
part 'webhook.g.dart';

Webhook webhookFromJson(String str) => Webhook.fromJson(json.decode(str));

String webhookToJson(Webhook data) => json.encode(data.toJson());

@freezed
class Webhook with _$Webhook {
  const factory Webhook({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "address") required String address,
    @JsonKey(name: "topic") required String topic,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "updated_at") required String updatedAt,
    @JsonKey(name: "format") required String format,
    @JsonKey(name: "fields") required List<String> fields,
    @JsonKey(name: "metafield_namespaces") required List<String> metafieldNamespaces,
    @JsonKey(name: "api_version") required String apiVersion,
    @JsonKey(name: "private_metafield_namespaces") required List<String> privateMetafieldNamespaces,
    @JsonKey(name: "metafield_identifiers") required List<String> metafieldIdentifiers,
  }) = _Webhook;

  factory Webhook.fromJson(Map<String, dynamic> json) =>
      _$WebhookFromJson(json);
}