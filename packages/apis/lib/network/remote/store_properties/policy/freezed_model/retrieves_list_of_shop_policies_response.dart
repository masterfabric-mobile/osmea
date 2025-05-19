// To parse this JSON data, do
//
//     final retrievesListOfShopPoliciesResponse = retrievesListOfShopPoliciesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_list_of_shop_policies_response.freezed.dart';
part 'retrieves_list_of_shop_policies_response.g.dart';

RetrievesListOfShopPoliciesResponse retrievesListOfShopPoliciesResponseFromJson(
        String str) =>
    RetrievesListOfShopPoliciesResponse.fromJson(json.decode(str));

String retrievesListOfShopPoliciesResponseToJson(
        RetrievesListOfShopPoliciesResponse data) =>
    json.encode(data.toJson());

@freezed
class RetrievesListOfShopPoliciesResponse
    with _$RetrievesListOfShopPoliciesResponse {
  const factory RetrievesListOfShopPoliciesResponse({
    @JsonKey(name: "policies") List<Policy>? policies,
  }) = _RetrievesListOfShopPoliciesResponse;

  factory RetrievesListOfShopPoliciesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesListOfShopPoliciesResponseFromJson(json);
}

@freezed
class Policy with _$Policy {
  const factory Policy({
    @JsonKey(name: "body") String? body,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "handle") String? handle,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "url") String? url,
  }) = _Policy;

  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);
}
