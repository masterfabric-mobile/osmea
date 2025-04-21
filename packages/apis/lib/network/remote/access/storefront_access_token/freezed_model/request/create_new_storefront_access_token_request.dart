// To parse this JSON data, do
//
//     final createNewStorefrontAccessTokenRequest = createNewStorefrontAccessTokenRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_new_storefront_access_token_request.freezed.dart';
part 'create_new_storefront_access_token_request.g.dart';

CreateNewStorefrontAccessTokenRequest createNewStorefrontAccessTokenRequestFromJson(String str) => CreateNewStorefrontAccessTokenRequest.fromJson(json.decode(str));

String createNewStorefrontAccessTokenRequestToJson(CreateNewStorefrontAccessTokenRequest data) => json.encode(data.toJson());

@freezed
class CreateNewStorefrontAccessTokenRequest with _$CreateNewStorefrontAccessTokenRequest {
    const factory CreateNewStorefrontAccessTokenRequest({
        @JsonKey(name: "storefront_access_token")
        CreateNewStorefrontAccessTokenRequestBody? storefrontAccessToken,
    }) = _CreateNewStorefrontAccessTokenRequest;

    factory CreateNewStorefrontAccessTokenRequest.fromJson(Map<String, dynamic> json) => _$CreateNewStorefrontAccessTokenRequestFromJson(json);
    
    @override
    Map<String, dynamic> toJson();
}

@freezed
class CreateNewStorefrontAccessTokenRequestBody with _$CreateNewStorefrontAccessTokenRequestBody {
    const factory CreateNewStorefrontAccessTokenRequestBody({
        @JsonKey(name: "title")
        String? title,
    }) = _CreateNewStorefrontAccessTokenRequestBody;

    factory CreateNewStorefrontAccessTokenRequestBody.fromJson(Map<String, dynamic> json) => _$CreateNewStorefrontAccessTokenRequestBodyFromJson(json);
    
    @override
    Map<String, dynamic> toJson();
}
