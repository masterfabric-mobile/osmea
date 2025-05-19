// To parse this JSON data, do
//
//     final deletesAMarketingEventResponseModel = deletesAMarketingEventResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'deletes_a_marketing_event_response_model.freezed.dart';
part 'deletes_a_marketing_event_response_model.g.dart';

DeletesAMarketingEventResponseModel deletesAMarketingEventResponseModelFromJson(
        String str) =>
    DeletesAMarketingEventResponseModel.fromJson(json.decode(str));

String deletesAMarketingEventResponseModelToJson(
        DeletesAMarketingEventResponseModel data) =>
    json.encode(data.toJson());

@freezed
class DeletesAMarketingEventResponseModel
    with _$DeletesAMarketingEventResponseModel {
  const factory DeletesAMarketingEventResponseModel() =
      _DeletesAMarketingEventResponseModel;

  factory DeletesAMarketingEventResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$DeletesAMarketingEventResponseModelFromJson(json);
}
