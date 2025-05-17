import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_order_risk_request.freezed.dart';
part 'update_order_risk_request.g.dart';

UpdateOrderRiskRequest updateOrderRiskRequestFromJson(String str) =>
    UpdateOrderRiskRequest.fromJson(json.decode(str));

String updateOrderRiskRequestToJson(UpdateOrderRiskRequest data) =>
    json.encode(data.toJson());

@freezed
class UpdateOrderRiskRequest with _$UpdateOrderRiskRequest {
  const factory UpdateOrderRiskRequest({
    @JsonKey(name: "risk") Risk? risk,
  }) = _UpdateOrderRiskRequest;

  factory UpdateOrderRiskRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderRiskRequestFromJson(json);
}

@freezed
class Risk with _$Risk {
  const factory Risk({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "recommendation") String? recommendation,
    @JsonKey(name: "source") String? source,
    @JsonKey(name: "cause_cancel") bool? causeCancel,
    @JsonKey(name: "score") int? score,
  }) = _Risk;

  factory Risk.fromJson(Map<String, dynamic> json) => _$RiskFromJson(json);
}
