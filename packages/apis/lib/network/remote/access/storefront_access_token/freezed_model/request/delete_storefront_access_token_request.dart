// To parse this JSON data, do
//
//     final deleteStorefrontAccessTokenRequest = deleteStorefrontAccessTokenRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'delete_storefront_access_token_request.freezed.dart';
part 'delete_storefront_access_token_request.g.dart';

DeleteStorefrontAccessTokenRequest deleteStorefrontAccessTokenRequestFromJson(String str) => DeleteStorefrontAccessTokenRequest.fromJson(json.decode(str));

String deleteStorefrontAccessTokenRequestToJson(DeleteStorefrontAccessTokenRequest data) => json.encode(data.toJson());

@freezed
class DeleteStorefrontAccessTokenRequest with _$DeleteStorefrontAccessTokenRequest {
    const factory DeleteStorefrontAccessTokenRequest() = _DeleteStorefrontAccessTokenRequest;

    factory DeleteStorefrontAccessTokenRequest.fromJson(Map<String, dynamic> json) => _$DeleteStorefrontAccessTokenRequestFromJson(json);
}
