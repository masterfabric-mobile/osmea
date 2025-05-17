// To parse this JSON data, do
//
//     final countAllRedirectsResponse = countAllRedirectsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_all_redirects_response.freezed.dart';
part 'count_all_redirects_response.g.dart';

CountAllRedirectsResponse countAllRedirectsResponseFromJson(String str) => CountAllRedirectsResponse.fromJson(json.decode(str));

String countAllRedirectsResponseToJson(CountAllRedirectsResponse data) => json.encode(data.toJson());

@freezed
class CountAllRedirectsResponse with _$CountAllRedirectsResponse {
    const factory CountAllRedirectsResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountAllRedirectsResponse;

    factory CountAllRedirectsResponse.fromJson(Map<String, dynamic> json) => _$CountAllRedirectsResponseFromJson(json);
}
