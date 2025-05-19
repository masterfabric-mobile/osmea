// To parse this JSON data, do
//
//     final changeLiquidTemplateValueRequest = changeLiquidTemplateValueRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'change_liquid_template_value_request.freezed.dart';
part 'change_liquid_template_value_request.g.dart';

ChangeLiquidTemplateValueRequest changeLiquidTemplateValueRequestFromJson(String str) => ChangeLiquidTemplateValueRequest.fromJson(json.decode(str));

String changeLiquidTemplateValueRequestToJson(ChangeLiquidTemplateValueRequest data) => json.encode(data.toJson());

@freezed
class ChangeLiquidTemplateValueRequest with _$ChangeLiquidTemplateValueRequest {
    const factory ChangeLiquidTemplateValueRequest({
        @JsonKey(name: "asset")
        required Asset asset,
    }) = _ChangeLiquidTemplateValueRequest;

    factory ChangeLiquidTemplateValueRequest.fromJson(Map<String, dynamic> json) => _$ChangeLiquidTemplateValueRequestFromJson(json);
}

@freezed
class Asset with _$Asset {
    const factory Asset({
        @JsonKey(name: "key")
        required String key,
        @JsonKey(name: "value")
        required String value,
    }) = _Asset;

    factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
