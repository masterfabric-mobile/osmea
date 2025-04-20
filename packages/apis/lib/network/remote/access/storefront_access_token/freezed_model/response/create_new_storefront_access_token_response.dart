// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_new_storefront_access_token_response.freezed.dart';
part 'create_new_storefront_access_token_response.g.dart';

CreateNewStorefrontAccessTokenResponse createNewStorefrontAccessTokenResponseFromJson(String str) => CreateNewStorefrontAccessTokenResponse.fromJson(json.decode(str));

String createNewStorefrontAccessTokenResponseToJson(CreateNewStorefrontAccessTokenResponse data) => json.encode(data.toJson());

@freezed
class CreateNewStorefrontAccessTokenResponse with _$CreateNewStorefrontAccessTokenResponse {
    const factory CreateNewStorefrontAccessTokenResponse({
        // ignore: invalid_annotation_target
        @JsonKey(name: "storefront_access_token")
        StorefrontAccessToken? storefrontAccessToken,
        // ignore: invalid_annotation_target
        @JsonKey(name: "errors")
        dynamic errors,
    }) = _CreateNewStorefrontAccessTokenResponse;

    factory CreateNewStorefrontAccessTokenResponse.fromJson(Map<String, dynamic> json) => _$CreateNewStorefrontAccessTokenResponseFromJson(json);
}

@freezed
class StorefrontAccessToken with _$StorefrontAccessToken {
    const factory StorefrontAccessToken({
        // ignore: invalid_annotation_target
        @JsonKey(name: "access_token")
        String? accessToken,
        @JsonKey(name: "access_scope")
        String? accessScope,
        @JsonKey(name: "created_at")
        DateTime? createdAt,
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "admin_graphql_api_id")
        String? adminGraphqlApiId,
        @JsonKey(name: "title")
        String? title,
    }) = _StorefrontAccessToken;

    factory StorefrontAccessToken.fromJson(Map<String, dynamic> json) => _$StorefrontAccessTokenFromJson(json);
}

extension CreateNewStorefrontAccessTokenResponseX on CreateNewStorefrontAccessTokenResponse {
  List<String> get parsedErrors {
    if (errors == null) return [];
    if (errors is String) return [errors as String];
    if (errors is List) return (errors as List).whereType<String>().toList();
    return [];
  }
}
