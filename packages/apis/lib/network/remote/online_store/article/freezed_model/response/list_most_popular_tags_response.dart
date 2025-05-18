// To parse this JSON data, do
//
//     final listMostPopularTagsResponse = listMostPopularTagsResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'list_most_popular_tags_response.freezed.dart';
part 'list_most_popular_tags_response.g.dart';

ListMostPopularTagsResponse listMostPopularTagsResponseFromJson(String str) => ListMostPopularTagsResponse.fromJson(json.decode(str));

String listMostPopularTagsResponseToJson(ListMostPopularTagsResponse data) => json.encode(data.toJson());

@freezed
class ListMostPopularTagsResponse with _$ListMostPopularTagsResponse {
    const factory ListMostPopularTagsResponse({
        @JsonKey(name: "tags")
        List<String>? tags,
    }) = _ListMostPopularTagsResponse;

    factory ListMostPopularTagsResponse.fromJson(Map<String, dynamic> json) => _$ListMostPopularTagsResponseFromJson(json);
}
