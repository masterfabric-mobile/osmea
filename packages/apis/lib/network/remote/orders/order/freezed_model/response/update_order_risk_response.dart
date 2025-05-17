import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_order_risk_response.freezed.dart';
part 'update_order_risk_response.g.dart';

UpdateOrderRiskResponse updateOrderRiskResponseFromJson(String str) =>
    UpdateOrderRiskResponse.fromJson(json.decode(str));

String updateOrderRiskResponseToJson(UpdateOrderRiskResponse data) =>
    json.encode(data.toJson());

@freezed
class UpdateOrderRiskResponse with _$UpdateOrderRiskResponse {
  const factory UpdateOrderRiskResponse({
    @JsonKey(name: "risk") Risk? risk,
  }) = _UpdateOrderRiskResponse;

  factory UpdateOrderRiskResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderRiskResponseFromJson(json);
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
