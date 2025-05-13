// To parse this JSON data, do
//
//     final createImageAssetBaseRequest = createImageAssetBaseRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_image_asset_base_request.freezed.dart';
part 'create_image_asset_base_request.g.dart';

CreateImageAssetBaseRequest createImageAssetBaseRequestFromJson(String str) => CreateImageAssetBaseRequest.fromJson(json.decode(str));

String createImageAssetBaseRequestToJson(CreateImageAssetBaseRequest data) => json.encode(data.toJson());

@freezed
class CreateImageAssetBaseRequest with _$CreateImageAssetBaseRequest {
    const factory CreateImageAssetBaseRequest({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _CreateImageAssetBaseRequest;

    factory CreateImageAssetBaseRequest.fromJson(Map<String, dynamic> json) => _$CreateImageAssetBaseRequestFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "attachment")
        required String attachment,
    }) = _Asset;

    factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
