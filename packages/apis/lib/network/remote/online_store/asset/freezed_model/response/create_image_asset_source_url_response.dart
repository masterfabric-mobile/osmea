// To parse this JSON data, do
//
//     final createImageAssetSourceUrlResponse = createImageAssetSourceUrlResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_image_asset_source_url_response.freezed.dart';
part 'create_image_asset_source_url_response.g.dart';

CreateImageAssetSourceUrlResponse createImageAssetSourceUrlResponseFromJson(String str) => CreateImageAssetSourceUrlResponse.fromJson(json.decode(str));

String createImageAssetSourceUrlResponseToJson(CreateImageAssetSourceUrlResponse data) => json.encode(data.toJson());

@freezed
class CreateImageAssetSourceUrlResponse with _$CreateImageAssetSourceUrlResponse {
    const factory CreateImageAssetSourceUrlResponse({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _CreateImageAssetSourceUrlResponse;

    factory CreateImageAssetSourceUrlResponse.fromJson(Map<String, dynamic> json) => _$CreateImageAssetSourceUrlResponseFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "public_url")
        required String publicUrl,
        @JsonKey(name: "created_at")
        required String createdAt,
        @JsonKey(name: "updated_at")
        required String updatedAt,
        @JsonKey(name: "content_type")
        required String contentType,
        @JsonKey(name: "size")
        required int size,
        @JsonKey(name: "checksum")
        required String checksum,
        @JsonKey(name: "theme_id")
        required int themeId,
    }) = _Asset;

    factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
