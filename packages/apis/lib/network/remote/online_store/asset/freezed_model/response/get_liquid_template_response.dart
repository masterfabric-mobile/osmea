// To parse this JSON data, do
//
//     final getLiquidTemplateResponse = getLiquidTemplateResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_liquid_template_response.freezed.dart';
part 'get_liquid_template_response.g.dart';

GetLiquidTemplateResponse getLiquidTemplateResponseFromJson(String str) => GetLiquidTemplateResponse.fromJson(json.decode(str));

String getLiquidTemplateResponseToJson(GetLiquidTemplateResponse data) => json.encode(data.toJson());

@freezed
class GetLiquidTemplateResponse with _$GetLiquidTemplateResponse {
    const factory GetLiquidTemplateResponse({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _GetLiquidTemplateResponse;

    factory GetLiquidTemplateResponse.fromJson(Map<String, dynamic> json) => _$GetLiquidTemplateResponseFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "public_url")
        required dynamic publicUrl,
        @JsonKey(name: "value")
        required String value,
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
