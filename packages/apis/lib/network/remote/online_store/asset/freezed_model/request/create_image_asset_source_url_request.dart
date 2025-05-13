// To parse this JSON data, do
//
//     final createImageAssetSourceUrlRequest = createImageAssetSourceUrlRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_image_asset_source_url_request.freezed.dart';
part 'create_image_asset_source_url_request.g.dart';

CreateImageAssetSourceUrlRequest createImageAssetSourceUrlRequestFromJson(String str) => CreateImageAssetSourceUrlRequest.fromJson(json.decode(str));

String createImageAssetSourceUrlRequestToJson(CreateImageAssetSourceUrlRequest data) => json.encode(data.toJson());

@freezed
class CreateImageAssetSourceUrlRequest with _$CreateImageAssetSourceUrlRequest {
    const factory CreateImageAssetSourceUrlRequest({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _CreateImageAssetSourceUrlRequest;

    factory CreateImageAssetSourceUrlRequest.fromJson(Map<String, dynamic> json) => _$CreateImageAssetSourceUrlRequestFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "src")
        required String src,
    }) = _Asset;

    factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
