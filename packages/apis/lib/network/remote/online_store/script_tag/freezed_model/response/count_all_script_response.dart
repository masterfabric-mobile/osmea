// To parse this JSON data, do
//
//     final countAllScriptResponse = countAllScriptResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'count_all_script_response.freezed.dart';
part 'count_all_script_response.g.dart';

CountAllScriptResponse countAllScriptResponseFromJson(String str) => CountAllScriptResponse.fromJson(json.decode(str));

String countAllScriptResponseToJson(CountAllScriptResponse data) => json.encode(data.toJson());

@freezed
class CountAllScriptResponse with _$CountAllScriptResponse {
    const factory CountAllScriptResponse({
        @JsonKey(name: "count")
        int? count,
    }) = _CountAllScriptResponse;

    factory CountAllScriptResponse.fromJson(Map<String, dynamic> json) => _$CountAllScriptResponseFromJson(json);
}
