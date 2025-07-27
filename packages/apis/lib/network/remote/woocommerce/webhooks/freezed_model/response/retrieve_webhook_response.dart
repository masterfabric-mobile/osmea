// To parse this JSON data, do
//
//     final retrieveWebhookResponse = retrieveWebhookResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieve_webhook_response.freezed.dart';
part 'retrieve_webhook_response.g.dart';

RetrieveWebhookResponse retrieveWebhookResponseFromJson(String str) =>
    RetrieveWebhookResponse.fromJson(json.decode(str));

String retrieveWebhookResponseToJson(RetrieveWebhookResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrieveWebhookResponse with _$RetrieveWebhookResponse {
  const factory RetrieveWebhookResponse({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "topic") String? topic,
    @JsonKey(name: "resource") String? resource,
    @JsonKey(name: "event") String? event,
    @JsonKey(name: "hooks") List<String>? hooks,
    @JsonKey(name: "delivery_url") String? deliveryUrl,
    @JsonKey(name: "date_created") String? dateCreated,
    @JsonKey(name: "date_created_gmt") String? dateCreatedGmt,
    @JsonKey(name: "date_modified") dynamic dateModified,
    @JsonKey(name: "date_modified_gmt") dynamic dateModifiedGmt,
    @JsonKey(name: "_links") Links? links,
  }) = _RetrieveWebhookResponse;

  factory RetrieveWebhookResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveWebhookResponseFromJson(json);
}

@freezed
class Links with _$Links {
  const factory Links({
    @JsonKey(name: "self") List<Self>? self,
    @JsonKey(name: "collection") List<Collection>? collection,
  }) = _Links;

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
}

@freezed
class Collection with _$Collection {
  const factory Collection({
    @JsonKey(name: "href") String? href,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}

@freezed
class Self with _$Self {
  const factory Self({
    @JsonKey(name: "href") String? href,
    @JsonKey(name: "targetHints") TargetHints? targetHints,
  }) = _Self;

  factory Self.fromJson(Map<String, dynamic> json) => _$SelfFromJson(json);
}

@freezed
class TargetHints with _$TargetHints {
  const factory TargetHints({
    @JsonKey(name: "allow") List<String>? allow,
  }) = _TargetHints;

  factory TargetHints.fromJson(Map<String, dynamic> json) =>
      _$TargetHintsFromJson(json);
}
