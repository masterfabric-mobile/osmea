// To parse this JSON data, do
//
//     final countCustomCollectionsResponse = countCustomCollectionsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_custom_collections_response.freezed.dart';
part 'count_custom_collections_response.g.dart';

CountCustomCollectionsResponse countCustomCollectionsResponseFromJson(String str) => CountCustomCollectionsResponse.fromJson(json.decode(str));

String countCustomCollectionsResponseToJson(CountCustomCollectionsResponse data) => json.encode(data.toJson());

@freezed
class CountCustomCollectionsResponse with _$CountCustomCollectionsResponse {
    const factory CountCustomCollectionsResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountCustomCollectionsResponse;

    factory CountCustomCollectionsResponse.fromJson(Map<String, dynamic> json) => _$CountCustomCollectionsResponseFromJson(json);
}
