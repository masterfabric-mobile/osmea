import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_order_risk_request.freezed.dart';
part 'create_order_risk_request.g.dart';

CreateOrderRiskRequest createOrderRiskRequestFromJson(String str) =>
    CreateOrderRiskRequest.fromJson(json.decode(str));

String createOrderRiskRequestToJson(CreateOrderRiskRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateOrderRiskRequest with _$CreateOrderRiskRequest {
  const factory CreateOrderRiskRequest({
    @JsonKey(name: "risk") Risk? risk,
  }) = _CreateOrderRiskRequest;

  factory CreateOrderRiskRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRiskRequestFromJson(json);
}

@freezed
class Risk with _$Risk {
  const factory Risk({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "recommendation") String? recommendation,
    @JsonKey(name: "score")
    double? score, // Değiştirilen kısım: int? yerine double?
    @JsonKey(name: "source") String? source,
    @JsonKey(name: "cause_cancel") bool? causeCancel,
    @JsonKey(name: "display") bool? display,
  }) = _Risk;

  factory Risk.fromJson(Map<String, dynamic> json) => _$RiskFromJson(json);
}
