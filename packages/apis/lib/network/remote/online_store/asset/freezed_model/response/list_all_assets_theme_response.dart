// To parse this JSON data, do
//
//     final listAllAssetsThemeResponse = listAllAssetsThemeResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_all_assets_theme_response.freezed.dart';
part 'list_all_assets_theme_response.g.dart';

ListAllAssetsThemeResponse listAllAssetsThemeResponseFromJson(String str) => ListAllAssetsThemeResponse.fromJson(json.decode(str));

String listAllAssetsThemeResponseToJson(ListAllAssetsThemeResponse data) => json.encode(data.toJson());

@freezed
class ListAllAssetsThemeResponse with _$ListAllAssetsThemeResponse {
    const factory ListAllAssetsThemeResponse({
        @JsonKey(name: "assets")
        List<Asset>? assets,
    }) = _ListAllAssetsThemeResponse;

    factory ListAllAssetsThemeResponse.fromJson(Map<String, dynamic> json) => _$ListAllAssetsThemeResponseFromJson(json);
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
