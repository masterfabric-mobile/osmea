// To parse this JSON data, do
//
//     final createImageAssetBaseResponse = createImageAssetBaseResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_image_asset_base_response.freezed.dart';
part 'create_image_asset_base_response.g.dart';

CreateImageAssetBaseResponse createImageAssetBaseResponseFromJson(String str) => CreateImageAssetBaseResponse.fromJson(json.decode(str));

String createImageAssetBaseResponseToJson(CreateImageAssetBaseResponse data) => json.encode(data.toJson());

@freezed
class CreateImageAssetBaseResponse with _$CreateImageAssetBaseResponse {
    const factory CreateImageAssetBaseResponse({
        @JsonKey(name: "asset")
        Asset? asset,
    }) = _CreateImageAssetBaseResponse;

    factory CreateImageAssetBaseResponse.fromJson(Map<String, dynamic> json) => _$CreateImageAssetBaseResponseFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        String? key,
        @JsonKey(name: "public_url")
        String? publicUrl,
        @JsonKey(name: "created_at")
        String? createdAt,
        @JsonKey(name: "updated_at")
        String? updatedAt,
        @JsonKey(name: "content_type")
        String? contentType,
        @JsonKey(name: "size")
        int? size,
        @JsonKey(name: "checksum")
        String? checksum,
        @JsonKey(name: "theme_id")
        int? themeId,
    }) = _Asset;

    factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
