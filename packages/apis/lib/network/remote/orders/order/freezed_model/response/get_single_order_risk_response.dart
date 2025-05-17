import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_single_order_risk_response.freezed.dart';
part 'get_single_order_risk_response.g.dart';

GetSingleOrderRiskResponse getSingleOrderRiskResponseFromJson(String str) =>
    GetSingleOrderRiskResponse.fromJson(json.decode(str));

String getSingleOrderRiskResponseToJson(GetSingleOrderRiskResponse data) =>
    json.encode(data.toJson());

@freezed
class GetSingleOrderRiskResponse with _$GetSingleOrderRiskResponse {
  const factory GetSingleOrderRiskResponse({
    @JsonKey(name: "risk") Risk? risk,
  }) = _GetSingleOrderRiskResponse;

  factory GetSingleOrderRiskResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSingleOrderRiskResponseFromJson(json);
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
