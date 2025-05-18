// To parse this JSON data, do
//
//     final tenderTransaction = tenderTransactionFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'tender_transaction.freezed.dart';
part 'tender_transaction.g.dart';

TenderTransaction tenderTransactionFromJson(String str) =>
    TenderTransaction.fromJson(json.decode(str));

String tenderTransactionToJson(TenderTransaction data) =>
    json.encode(data.toJson());

@freezed
class TenderTransaction with _$TenderTransaction {
  const factory TenderTransaction({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "order_id") required int orderId,
    @JsonKey(name: "amount") required String amount,
    @JsonKey(name: "currency") required String currency,
    @JsonKey(name: "user_id") int? userId,
    @JsonKey(name: "test") required bool test,
    @JsonKey(name: "processed_at") required String processedAt,
    @JsonKey(name: "remote_reference") required String remoteReference,
    @JsonKey(name: "payment_method") required String paymentMethod,
    @JsonKey(name: "payment_details") required Map<String, dynamic> paymentDetails,
  }) = _TenderTransaction;

  factory TenderTransaction.fromJson(Map<String, dynamic> json) =>
      _$TenderTransactionFromJson(json);
}