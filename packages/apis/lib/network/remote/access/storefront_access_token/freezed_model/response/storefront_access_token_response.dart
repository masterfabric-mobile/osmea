// To parse this JSON data, do
//
//     final storefrontAccessTokenResponse = storefrontAccessTokenResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'storefront_access_token_response.freezed.dart';
part 'storefront_access_token_response.g.dart';

StorefrontAccessTokenResponse storefrontAccessTokenResponseFromJson(String str) => StorefrontAccessTokenResponse.fromJson(json.decode(str));

String storefrontAccessTokenResponseToJson(StorefrontAccessTokenResponse data) => json.encode(data.toJson());

@freezed
class StorefrontAccessTokenResponse with _$StorefrontAccessTokenResponse {
    const factory StorefrontAccessTokenResponse({
        // ignore: invalid_annotation_target
        @JsonKey(name: "storefront_access_tokens")
        required List<StorefrontAccessToken> storefrontAccessTokens,
    }) = _StorefrontAccessTokenResponse;

    factory StorefrontAccessTokenResponse.fromJson(Map<String, dynamic> json) => _$StorefrontAccessTokenResponseFromJson(json);
}

@freezed
class StorefrontAccessToken with _$StorefrontAccessToken {
    const factory StorefrontAccessToken({
        // ignore: invalid_annotation_target
        @JsonKey(name: "access_token")
        required String accessToken,
        // ignore: invalid_annotation_target
        @JsonKey(name: "access_scope")
        required String accessScope,
        // ignore: invalid_annotation_target
        @JsonKey(name: "created_at")
        required DateTime createdAt,
        // ignore: invalid_annotation_target
        @JsonKey(name: "id")
        required int id,
        // ignore: invalid_annotation_target
        @JsonKey(name: "admin_graphql_api_id")
        required String adminGraphqlApiId,
        // ignore: invalid_annotation_target
        @JsonKey(name: "title")
        required String title,
    }) = _StorefrontAccessToken;

    factory StorefrontAccessToken.fromJson(Map<String, dynamic> json) => _$StorefrontAccessTokenFromJson(json);
}