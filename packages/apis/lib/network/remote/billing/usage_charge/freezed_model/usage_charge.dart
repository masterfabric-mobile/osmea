import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'usage_charge.freezed.dart';
part 'usage_charge.g.dart';

UsageCharge usageChargeFromJson(String str) =>
    UsageCharge.fromJson(json.decode(str));

String usageChargeToJson(UsageCharge data) =>
    json.encode(data.toJson());

@freezed
class UsageCharge with _$UsageCharge {
  const factory UsageCharge({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "price") required String price,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "balance_used") String? balanceUsed,
    @JsonKey(name: "balance_remaining") String? balanceRemaining,
    @JsonKey(name: "risk_level") double? riskLevel,
  }) = _UsageCharge;

  factory UsageCharge.fromJson(Map<String, dynamic> json) =>
      _$UsageChargeFromJson(json);
}