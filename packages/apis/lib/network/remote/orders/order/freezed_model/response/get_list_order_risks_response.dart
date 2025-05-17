import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_list_order_risks_response.freezed.dart';
part 'get_list_order_risks_response.g.dart';

GetListOrderRisksResponse getListOrderRisksResponseFromJson(String str) =>
    GetListOrderRisksResponse.fromJson(json.decode(str));

String getListOrderRisksResponseToJson(GetListOrderRisksResponse data) =>
    json.encode(data.toJson());

@freezed
class GetListOrderRisksResponse with _$GetListOrderRisksResponse {
  const factory GetListOrderRisksResponse({
    @JsonKey(name: "risks") List<Risk>? risks,
  }) = _GetListOrderRisksResponse;

  factory GetListOrderRisksResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListOrderRisksResponseFromJson(json);
}

@freezed
class Risk with _$Risk {
  const factory Risk({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "order_id") int? orderId,
    @JsonKey(name: "checkout_id") dynamic checkoutId,
    @JsonKey(name: "source") String? source,
    @JsonKey(name: "score") String? score,
    @JsonKey(name: "recommendation") String? recommendation,
    @JsonKey(name: "display") bool? display,
    @JsonKey(name: "cause_cancel") bool? causeCancel,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "merchant_message") String? merchantMessage,
  }) = _Risk;

  factory Risk.fromJson(Map<String, dynamic> json) => _$RiskFromJson(json);
}
