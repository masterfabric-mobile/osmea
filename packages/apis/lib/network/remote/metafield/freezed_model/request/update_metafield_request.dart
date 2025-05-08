// To parse this JSON data, do
//
//     final updateMetafieldRequest = updateMetafieldRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_metafield_request.freezed.dart';
part 'update_metafield_request.g.dart';

UpdateMetafieldRequest updateMetafieldRequestFromJson(String str) => UpdateMetafieldRequest.fromJson(json.decode(str));

String updateMetafieldRequestToJson(UpdateMetafieldRequest data) => json.encode(data.toJson());

@freezed
class UpdateMetafieldRequest with _$UpdateMetafieldRequest {
    const factory UpdateMetafieldRequest({
        @JsonKey(name: "metafield")
        Metafield? metafield,
    }) = _UpdateMetafieldRequest;

    factory UpdateMetafieldRequest.fromJson(Map<String, dynamic> json) => _$UpdateMetafieldRequestFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "value")
        String? value,
        @JsonKey(name: "type")
        String? type,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
