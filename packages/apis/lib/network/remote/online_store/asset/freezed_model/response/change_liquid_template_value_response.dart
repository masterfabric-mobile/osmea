// To parse this JSON data, do
//
//     final changeLiquidTemplateValueResponse = changeLiquidTemplateValueResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'change_liquid_template_value_response.freezed.dart';
part 'change_liquid_template_value_response.g.dart';

ChangeLiquidTemplateValueResponse changeLiquidTemplateValueResponseFromJson(String str) => ChangeLiquidTemplateValueResponse.fromJson(json.decode(str));

String changeLiquidTemplateValueResponseToJson(ChangeLiquidTemplateValueResponse data) => json.encode(data.toJson());

@freezed
class ChangeLiquidTemplateValueResponse with _$ChangeLiquidTemplateValueResponse {
    const factory ChangeLiquidTemplateValueResponse({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _ChangeLiquidTemplateValueResponse;

    factory ChangeLiquidTemplateValueResponse.fromJson(Map<String, dynamic> json) => _$ChangeLiquidTemplateValueResponseFromJson(json);
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
