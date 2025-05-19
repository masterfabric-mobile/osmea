// To parse this JSON data, do
//
//     final duplicateAssetSourceKeyResponse = duplicateAssetSourceKeyResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'duplicate_asset_source_key_response.freezed.dart';
part 'duplicate_asset_source_key_response.g.dart';

DuplicateAssetSourceKeyResponse duplicateAssetSourceKeyResponseFromJson(String str) => DuplicateAssetSourceKeyResponse.fromJson(json.decode(str));

String duplicateAssetSourceKeyResponseToJson(DuplicateAssetSourceKeyResponse data) => json.encode(data.toJson());

@freezed
class DuplicateAssetSourceKeyResponse with _$DuplicateAssetSourceKeyResponse {
    const factory DuplicateAssetSourceKeyResponse({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _DuplicateAssetSourceKeyResponse;

    factory DuplicateAssetSourceKeyResponse.fromJson(Map<String, dynamic> json) => _$DuplicateAssetSourceKeyResponseFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "public_url")
        required dynamic publicUrl,
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
