// To parse this JSON data, do
//
//     final countAllBlogsResponse = countAllBlogsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_all_blogs_response.freezed.dart';
part 'count_all_blogs_response.g.dart';

CountAllBlogsResponse countAllBlogsResponseFromJson(String str) => CountAllBlogsResponse.fromJson(json.decode(str));

String countAllBlogsResponseToJson(CountAllBlogsResponse data) => json.encode(data.toJson());

@freezed
class CountAllBlogsResponse with _$CountAllBlogsResponse {
    const factory CountAllBlogsResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountAllBlogsResponse;

    factory CountAllBlogsResponse.fromJson(Map<String, dynamic> json) => _$CountAllBlogsResponseFromJson(json);
}
