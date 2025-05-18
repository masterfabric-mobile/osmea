// To parse this JSON data, do
//
//     final countAllPagesResponse = countAllPagesResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_all_pages_response.freezed.dart';
part 'count_all_pages_response.g.dart';

CountAllPagesResponse countAllPagesResponseFromJson(String str) => CountAllPagesResponse.fromJson(json.decode(str));

String countAllPagesResponseToJson(CountAllPagesResponse data) => json.encode(data.toJson());

@freezed
class CountAllPagesResponse with _$CountAllPagesResponse {
    const factory CountAllPagesResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountAllPagesResponse;

    factory CountAllPagesResponse.fromJson(Map<String, dynamic> json) => _$CountAllPagesResponseFromJson(json);
}
