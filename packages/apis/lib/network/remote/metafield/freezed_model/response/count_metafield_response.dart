// To parse this JSON data, do
//
//     final countMetafieldResponse = countMetafieldResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_metafield_response.freezed.dart';
part 'count_metafield_response.g.dart';

CountMetafieldResponse countMetafieldResponseFromJson(String str) => CountMetafieldResponse.fromJson(json.decode(str));

String countMetafieldResponseToJson(CountMetafieldResponse data) => json.encode(data.toJson());

@freezed
class CountMetafieldResponse with _$CountMetafieldResponse {
    const factory CountMetafieldResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountMetafieldResponse;

    factory CountMetafieldResponse.fromJson(Map<String, dynamic> json) => _$CountMetafieldResponseFromJson(json);
}
