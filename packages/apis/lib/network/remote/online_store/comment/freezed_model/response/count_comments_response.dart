// To parse this JSON data, do
//
//     final countCommentsResponse = countCommentsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_comments_response.freezed.dart';
part 'count_comments_response.g.dart';

CountCommentsResponse countCommentsResponseFromJson(String str) => CountCommentsResponse.fromJson(json.decode(str));

String countCommentsResponseToJson(CountCommentsResponse data) => json.encode(data.toJson());

@freezed
class CountCommentsResponse with _$CountCommentsResponse {
    const factory CountCommentsResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountCommentsResponse;

    factory CountCommentsResponse.fromJson(Map<String, dynamic> json) => _$CountCommentsResponseFromJson(json);
}
