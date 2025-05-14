// To parse this JSON data, do
//
//     final duplicateAssetSourceKeyRequest = duplicateAssetSourceKeyRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'duplicate_asset_source_key_request.freezed.dart';
part 'duplicate_asset_source_key_request.g.dart';

DuplicateAssetSourceKeyRequest duplicateAssetSourceKeyRequestFromJson(String str) => DuplicateAssetSourceKeyRequest.fromJson(json.decode(str));

String duplicateAssetSourceKeyRequestToJson(DuplicateAssetSourceKeyRequest data) => json.encode(data.toJson());

@freezed
class DuplicateAssetSourceKeyRequest with _$DuplicateAssetSourceKeyRequest {
    const factory DuplicateAssetSourceKeyRequest({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _DuplicateAssetSourceKeyRequest;

    factory DuplicateAssetSourceKeyRequest.fromJson(Map<String, dynamic> json) => _$DuplicateAssetSourceKeyRequestFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "source_key")
        required String sourceKey,
    }) = _Asset;

    factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
