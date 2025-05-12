import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_count_order_response.freezed.dart';
part 'get_count_order_response.g.dart';

GetCountOrderResponse getCountOrderResponseFromJson(String str) =>
    GetCountOrderResponse.fromJson(json.decode(str));

String getCountOrderResponseToJson(GetCountOrderResponse data) =>
    json.encode(data.toJson());

@freezed
class GetCountOrderResponse with _$GetCountOrderResponse {
  const factory GetCountOrderResponse({
    @JsonKey(name: "count") int? count,
  }) = _GetCountOrderResponse;

  factory GetCountOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCountOrderResponseFromJson(json);
}
