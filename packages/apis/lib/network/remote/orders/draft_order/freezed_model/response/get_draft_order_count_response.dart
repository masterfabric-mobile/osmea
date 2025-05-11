import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_draft_order_count_response.freezed.dart';
part 'get_draft_order_count_response.g.dart';

GetDraftOrderCountResponse getDraftOrderCountResponseFromJson(String str) =>
    GetDraftOrderCountResponse.fromJson(json.decode(str));

String getDraftOrderCountResponseToJson(GetDraftOrderCountResponse data) =>
    json.encode(data.toJson());

@freezed
class GetDraftOrderCountResponse with _$GetDraftOrderCountResponse {
  const factory GetDraftOrderCountResponse({
    @JsonKey(name: "count") int? count,
  }) = _GetDraftOrderCountResponse;

  factory GetDraftOrderCountResponse.fromJson(Map<String, dynamic> json) =>
      _$GetDraftOrderCountResponseFromJson(json);
}
