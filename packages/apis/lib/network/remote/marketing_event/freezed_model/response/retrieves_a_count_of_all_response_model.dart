// To parse this JSON data, do
//
//     final retrievesACountOfAllResponseModel = retrievesACountOfAllResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'retrieves_a_count_of_all_response_model.freezed.dart';
part 'retrieves_a_count_of_all_response_model.g.dart';

RetrievesACountOfAllResponseModel retrievesACountOfAllResponseModelFromJson(
        String str) =>
    RetrievesACountOfAllResponseModel.fromJson(json.decode(str));

String retrievesACountOfAllResponseModelToJson(
        RetrievesACountOfAllResponseModel data) =>
    json.encode(data.toJson());

@freezed
class RetrievesACountOfAllResponseModel
    with _$RetrievesACountOfAllResponseModel {
  const factory RetrievesACountOfAllResponseModel({
    @JsonKey(name: "count") int? count,
  }) = _RetrievesACountOfAllResponseModel;

  factory RetrievesACountOfAllResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$RetrievesACountOfAllResponseModelFromJson(json);
}
