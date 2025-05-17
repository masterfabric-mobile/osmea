import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_risk_response.freezed.dart';
part 'create_order_risk_response.g.dart';

CreateOrderRiskResponse createOrderRiskResponseFromJson(String str) =>
    CreateOrderRiskResponse.fromJson(json.decode(str));

String createOrderRiskResponseToJson(CreateOrderRiskResponse data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderRiskResponse with _$CreateOrderRiskResponse {
  const factory CreateOrderRiskResponse({
    @JsonKey(name: "risk") Risk? risk,
  }) = _CreateOrderRiskResponse;

  factory CreateOrderRiskResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRiskResponseFromJson(json);
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
